# 计算资源自适应与可复现并行

本规则用于编写和修改 R / Python 分析代码。目标是缩短可拆分计算的运行时间，不以 CPU 占用率替代正确性、可复现性或内存安全。

目录：1 并行判定 · 2 Worker 预算 · 3 R 模式 · 4 Python 模式 · 5 验证与记录

## 1. 并行判定

满足以下条件才启用并行：

- 单元彼此独立，例如 bootstrap 重复、置换、Monte Carlo 模拟、重采样折、超参数组合、独立模型或独立文件；
- 单元主要消耗 CPU，或 I/O 等待可由有限线程并发隐藏；
- 单元数量和单次耗时足以覆盖进程启动、数据序列化和结果合并开销；
- 能为每个任务分配稳定任务 ID、独立随机流和确定的结果位置。

小数据、单次快速模型、顺序依赖、共享可变状态、内存占用过高或并行实测更慢时保持串行。不得为了“使用多核”改变统计方法或拆分不可独立的计算。

## 2. Worker 预算

1. 自动盘点物理核数和逻辑线程数；物理核仅用于诊断，worker 预算优先读取项目、调度器、容器或进程亲和性实际允许的逻辑线程，不直接使用机器标称总核数。现有运行时无法可靠取得物理核时记录为未知，不为盘点自行安装依赖。
2. 默认保留系统余量：可用线程不超过 4 时保留 1 个，否则保留 2 个。
3. `workers = min(可并行任务数, 可用线程 - 保留线程, 内存允许的 worker 数)`，下限为 1。
4. 先用一个代表性任务测量峰值内存；内存 worker 上限按 `floor(0.8 × 可用内存 / 单 worker 峰值内存)` 估计。无法可靠估计时从保守 worker 数开始实测，不盲目占满线程。
5. 项目已声明 worker 上限时取更小值，并把实际检测值、worker、内层线程和判定理由写入运行日志或正式项目 `SESSION_LOG.md`。

不得同时占满外层 worker 与内层线程。选择一种并行层级：

- 外层 bootstrap、折或参数组合并行时，每个 worker 的模型、BLAS、OpenMP 或 `n_jobs` 设为 1；
- 单个模型已有稳定的原生多线程时，外层保持串行，把线程预算交给模型；
- I/O 密集任务可用有限线程，CPU 密集的纯 Python 代码使用进程，不能用线程绕过全局解释器锁。

## 3. R 模式

优先使用项目已经具备且支持当前平台的后端，不得为并行自行安装包。`parallelly` 可用时用它识别调度器和进程约束；否则回退到 base R。Windows 不使用 `mclapply()`。

```r
available_workers <- function(task_count = Inf) {
  cores <- if (requireNamespace("parallelly", quietly = TRUE)) {
    parallelly::availableCores()
  } else {
    parallel::detectCores(logical = TRUE)
  }
  cores <- as.integer(cores[[1]])
  if (is.na(cores) || cores < 1L) cores <- 1L
  reserve <- if (cores <= 4L) 1L else 2L
  workers <- max(1L, cores - reserve)
  if (is.finite(task_count)) workers <- min(workers, as.integer(task_count))
  max(1L, workers)
}
```

`future` / `furrr` 已是项目依赖时，使用跨平台 `multisession`，恢复原计划并启用可复现随机流：

```r
workers <- available_workers(length(resample_ids))
old_plan <- future::plan(future::multisession, workers = workers)
results <- tryCatch(
  furrr::future_map(
    resample_ids,
    run_one_resample,
    .options = furrr::furrr_options(seed = 123)
  ),
  finally = future::plan(old_plan)
)
```

使用 base `parallel` 时显式 `clusterSetRNGStream()` 并确保 `stopCluster()` 在成功或失败后均执行。不得在每个 worker 内重复同一个 `set.seed()`；不得依赖任务完成先后决定输出顺序。

## 4. Python 模式

先识别当前进程实际可用逻辑线程，再按任务数保留余量。Python 3.13 优先使用 `os.process_cpu_count()`；旧版本在 POSIX 上优先读取进程亲和性，最后才回退到 `os.cpu_count()`。项目已经依赖 `psutil` 时另用 `psutil.cpu_count(logical=False)` 记录物理核数；未安装时记录为未知，不新增依赖。

```python
import os


def available_cpus() -> int:
    if hasattr(os, "process_cpu_count"):
        count = os.process_cpu_count()
    elif hasattr(os, "sched_getaffinity"):
        count = len(os.sched_getaffinity(0))
    else:
        count = os.cpu_count()
    return max(1, count or 1)


def worker_budget(task_count: int) -> int:
    cores = available_cpus()
    reserve = 1 if cores <= 4 else 2
    return max(1, min(task_count, cores - reserve))
```

CPU 密集的独立 Python 函数使用 `ProcessPoolExecutor`，并保留 Windows 必需的主入口保护：

```python
from concurrent.futures import ProcessPoolExecutor


if __name__ == "__main__":
    workers = worker_budget(len(tasks))
    with ProcessPoolExecutor(max_workers=workers) as pool:
        results = list(pool.map(run_one_task, tasks))
```

使用 NumPy、scikit-learn、XGBoost 或其他原生线程库时，只选择外层进程或库内 `n_jobs` / threads 其中一层。若已有 NumPy，可用 `numpy.random.SeedSequence(base_seed).spawn(n_tasks)` 为任务生成独立随机流；不得让多个 worker 继承同一随机状态。

## 5. 验证与记录

- 先在固定小样本、固定任务 ID 和固定基准种子上分别运行串行与并行版本；数值结果应在预设容差内一致，任务 ID 不得重复或缺失。
- 记录 detected logical CPUs、worker 数、并行后端、每个 worker 的内层线程数、种子方案、任务数、峰值内存和耗时。
- 完整扫描 worker 日志中的 `error|warning|traceback|failed|nan`；子进程失败必须使主流程失败，不得静默丢失重复。
- 先预热再比较串并行耗时；没有实际加速或出现内存压力时降低 worker 或回退串行，并保留判定记录。
- 并行优化不改变抽样单位、折分、纳排、模型、指标与结果排序。并行前后任何统计结果差异必须先定位随机流、共享状态、数值库或任务遗漏，不能当作正常波动带过。
