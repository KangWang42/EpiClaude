# EpiAgent - Claude Code 卫生统计工作流库 - 安装指南

> 此文档供 Claude Code 读取并自动执行安装

---

## 安装目标

将以下内容安装到用户的 Claude Code 环境：

1. **Skills** → `~/.claude/skills/`
2. **MCP Servers** → `~/.claude.json`

---

## 自动安装步骤

### 步骤 1: 克隆仓库

```bash
git clone https://github.com/KangWang42/EpiAgent.git /tmp/epiagent
```

如果 git 不可用，跳过此步骤，直接从源仓库读取文件。

---

### 步骤 2: 创建 Skills 目录

**Windows:**
```powershell
$skillsDir = "$env:USERPROFILE\.claude\skills"
if (!(Test-Path $skillsDir)) { 
    New-Item -ItemType Directory -Path $skillsDir -Force 
}
```

**macOS/Linux:**
```bash
mkdir -p ~/.claude/skills
```

---

### 步骤 3: 复制 Skills

将以下技能目录复制到 skills 目录：

- `skills/r-biostats/` → `~/.claude/skills/r-biostats/`
- `skills/project-init/` → `~/.claude/skills/project-init/`
- `skills/paper-writing/` → `~/.claude/skills/paper-writing/`

**Windows:**
```powershell
Copy-Item -Recurse -Force "/tmp/claudecode4epi/skills/*" "$env:USERPROFILE\.claude\skills\"
```

**macOS/Linux:**
```bash
cp -r /tmp/claudecode4epi/skills/* ~/.claude/skills/
```

---

### 步骤 4: 配置 MCP Servers

读取或创建 `~/.claude.json`，添加以下 MCP 配置：

**Windows 配置:**
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "cmd",
      "args": ["/c", "npx", "-y", "@anthropic/mcp-filesystem", "."]
    },
    "memory": {
      "command": "cmd",
      "args": ["/c", "npx", "-y", "@anthropic/mcp-memory"]
    },
    "sequential-thinking": {
      "command": "cmd",
      "args": ["/c", "npx", "-y", "@anthropic/mcp-sequential-thinking"]
    }
  }
}
```

**macOS/Linux 配置:**
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-filesystem", "."]
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-memory"]
    },
    "sequential-thinking": {
      "command": "npx", 
      "args": ["-y", "@anthropic/mcp-sequential-thinking"]
    }
  }
}
```

---

### 步骤 5: 验证安装

告知用户：

```
✅ 安装完成！

已安装的 Skills:
- r-biostats (R 生物统计分析)
- project-init (项目初始化)
- paper-writing (论文生成)

已配置的 MCP Servers:
- filesystem (文件读写)
- memory (会话记忆)
- sequential-thinking (分步推理)

⚠️ 请重启 Claude Code 使配置生效！
```

---

## 项目级配置 (可选)

如果用户有特定项目，还可以：

1. 复制 `CLAUDE.md` 到项目根目录
2. 复制 `workflows/` 到项目的 `.agent/workflows/`

---

## 清理

安装完成后删除临时文件：

```bash
rm -rf /tmp/claudecode4epi
```
