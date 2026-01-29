# EpiClaude - 安装指南

> **For Claude Code AI:**
> Execute the R code block below to install. This works on Windows/macOS/Linux.

---

## 🛠️ 方式 1: R 语言自动安装 (推荐)

流统人员最熟悉的安装方式。请在 RStudio 或 Claude Code 中运行：

```r
# =======================================================
# EpiClaude 自动安装脚本
# =======================================================

# 1. 自动识别 Claude 配置目录
detect_claude_dir <- function() {
  if (Sys.info()[['sysname']] == "Windows") {
    path <- file.path(Sys.getenv("USERPROFILE"), ".claude")
  } else {
    path <- file.path(Sys.getenv("HOME"), ".claude")
  }
  return(path)
}

# 2. 从 GitHub 下载并安装
install_epiclaude <- function() {
  claude_dir <- detect_claude_dir()
  temp_dir <- file.path(tempdir(), "epiclaude_install")
  repo_url <- "https://github.com/KangWang42/EpiClaude/archive/refs/heads/master.zip"
  zip_file <- file.path(tempdir(), "epiclaude.zip")
  
  message(sprintf("📂 Claude 配置目录: %s", claude_dir))
  
  # 下载
  message("⬇️ 正在下载 EpiClaude...")
  download.file(repo_url, zip_file, mode = "wb")
  
  # 解压
  message("📦 正在解压...")
  unzip(zip_file, exdir = temp_dir)
  source_dir <- file.path(temp_dir, "EpiClaude-master")
  
  # 安装 Skills
  skills_dest <- file.path(claude_dir, "skills")
  if (!dir.exists(skills_dest)) dir.create(skills_dest, recursive = TRUE)
  
  skills_src <- file.path(source_dir, "skills")
  skills <- list.dirs(skills_src, full.names = FALSE, recursive = FALSE)
  
  for (s in skills) {
    from <- file.path(skills_src, s)
    to <- file.path(skills_dest, s)
    if (dir.exists(to)) {
      message(sprintf("⚠️  Skill 已存在 (跳过): %s", s))
    } else {
      file.copy(from, skills_dest, recursive = TRUE)
      message(sprintf("✅ Skill 已安装: %s", s))
    }
  }
  
  # 安装 Agents
  agents_dest <- file.path(claude_dir, "agents")
  if (!dir.exists(agents_dest)) dir.create(agents_dest, recursive = TRUE)
  
  agents_src <- file.path(source_dir, "agents")
  agents <- list.files(agents_src, pattern = "\\.md$")
  
  for (a in agents) {
    from <- file.path(source_dir, "agents", a)
    to <- file.path(agents_dest, a)
    if (file.exists(to)) {
      message(sprintf("⚠️  Agent 已存在 (跳过): %s", a))
    } else {
      file.copy(from, to)
      message(sprintf("✅ Agent 已安装: %s", a))
    }
  }
  
  # 清理
  unlink(zip_file)
  unlink(temp_dir, recursive = TRUE)
  
  message("\n🎉 安装完成！请重启 Claude Code。")
}

# 运行安装
install_epiclaude()
```

---

## ⚙️ 方式 2: PowerShell (Windows 备用)

如果不想打开 R，可以使用 PowerShell：

```powershell
$ErrorActionPreference = "Stop"
$RepoUrl = "https://github.com/KangWang42/EpiClaude/archive/refs/heads/master.zip"
$TempDir = "$env:TEMP\EpiClaude"
$ZipPath = "$env:TEMP\EpiClaude.zip"
$ClaudeDir = "$env:USERPROFILE\.claude"

Write-Host "⬇️ 正在下载..." -ForegroundColor Green
Invoke-WebRequest -Uri $RepoUrl -OutFile $ZipPath

Write-Host "📦 正在解压..." -ForegroundColor Green
Expand-Archive -Path $ZipPath -DestinationPath $TempDir -Force
$SourceDir = "$TempDir\EpiClaude-master"

# 安装 Skills
$SkillsDest = "$ClaudeDir\skills"
if (!(Test-Path $SkillsDest)) { New-Item -ItemType Directory -Path $SkillsDest }
Copy-Item "$SourceDir\skills\*" -Destination $SkillsDest -Recurse -Force
Write-Host "✅ Skills 已安装" -ForegroundColor Green

# 安装 Agents
$AgentsDest = "$ClaudeDir\agents"
if (!(Test-Path $AgentsDest)) { New-Item -ItemType Directory -Path $AgentsDest }
Copy-Item "$SourceDir\agents\*.md" -Destination $AgentsDest -Force
Write-Host "✅ Agents 已安装" -ForegroundColor Green

# 清理
Remove-Item $TempDir -Recurse -Force
Remove-Item $ZipPath -Force

Write-Host "🎉 安装完成！" -ForegroundColor Cyan
```
