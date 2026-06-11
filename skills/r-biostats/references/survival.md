# 生存分析

## 核心包

```r
library(survival)
library(survminer)
library(gtsummary)
```

## Kaplan-Meier

```r
fit <- survfit(Surv(time, event) ~ group, data = data)

ggsurvplot(fit,
  pval = TRUE,
  risk.table = TRUE,
  conf.int = TRUE,
  palette = "lancet",
  xlab = "时间 (月)",
  ylab = "生存概率"
)
```

## Cox 回归

```r
cox <- coxph(Surv(time, event) ~ exposure + age + sex, data = data)

tbl_regression(cox, exponentiate = TRUE) |>  # HR
  add_global_p()
```

## PH 假设检验

```r
cox.zph(cox)  # P > 0.05 表示满足 PH 假设

# 违反 PH 时:
# 1. 分层: strata(var)
# 2. 时变系数: tt(var)
```

## 竞争风险

```r
library(tidycmprsk)
crr(Surv(time, event_type) ~ exposure, data = data)
```

## 中位生存时间

```r
summary(fit)$table[, "median"]
```
