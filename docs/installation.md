# EpiClaude - Claude Code 流行病学工作流库 - 安装指南

> 此文档供 Claude Code 读取并自动执行安装

---

## ⚠️ 重要：安装前检查

在安装前，你需要检查用户是否已有现有配置，并询问用户如何处理：

### 1. 检查现有 Skills

检查以下路径是否存在：
- Windows: `C:\Users\用户名\.claude\skills\`
- macOS/Linux: `~/.claude/skills/`

**如果存在同名 skill (如 `r-biostats`)，询问用户：**

```
📋 检测到你已有以下 Skills:
   - r-biostats (已存在)
   
请选择处理方式：
1️⃣ 替换 - 用 EpiClaude 的版本覆盖现有 skill
2️⃣ 保留 - 保持你现有的 skill 不变
3️⃣ 合并 - 将 EpiClaude 的内容智能合并到现有 skill

请输入 1/2/3:
```

### 2. 检查现有 CLAUDE.md

检查以下路径是否存在：
- 全局: `~/.claude/CLAUDE.md`
- 项目: `当前目录/CLAUDE.md`

**如果存在，询问用户：**

```
📋 检测到你已有 CLAUDE.md 文件

请选择处理方式：
1️⃣ 替换 - 用 EpiClaude 的版本覆盖
2️⃣ 保留 - 保持你现有的不变
3️⃣ 合并 - 将 EpiClaude 的规范追加到现有文件末尾
4️⃣ 智能合并 - 让我分析两个文件并智能整合 (推荐)

请输入 1/2/3/4:
```

### 3. 检查现有 Agents

检查 `~/.claude/agents/` 是否存在同名 agent

---

## 合并策略

### Skills 合并

如果用户选择"合并"，执行以下操作：

1. 读取用户现有的 `SKILL.md`
2. 读取 EpiClaude 的 `SKILL.md`
3. 保留用户的自定义内容
4. 添加 EpiClaude 的新功能和模板
5. 去重并保持结构清晰

### CLAUDE.md 智能合并

如果用户选择"智能合并"：

1. 分析两个文件的结构
2. 合并禁止规则 (去重)
3. 合并必须执行规则 (去重)
4. 保留用户的项目特定配置
5. 添加 EpiClaude 的工作流日志规范
6. 输出合并后的文件供用户确认

---

## 安装步骤

### ⚠️ Windows 用户注意

在 Windows 上请使用 **PowerShell** 而不是 Git Bash，因为 Git Bash 存在路径和编码兼容性问题。

**Windows 路径:**
- Skills 目录: `C:\Users\你的用户名\.claude\skills\`
- CLAUDE.md: `C:\Users\你的用户名\.claude\CLAUDE.md`
- Agents 目录: `C:\Users\你的用户名\.claude\agents\`

### 步骤 1: 下载仓库

**方法 A: 使用 Git (推荐)**
```powershell
git clone https://github.com/KangWang42/EpiClaude.git $env:TEMP\epiclaude
```

**方法 B: 手动下载**
1. 打开 https://github.com/KangWang42/EpiClaude
2. 点击 Code → Download ZIP
3. 解压到任意位置

---

### 步骤 2: 检查并处理现有配置

按上述检查流程询问用户处理方式。

---

### 步骤 3: 安装 Skills

根据用户选择执行：

**替换模式:**
```
覆盖 ~/.claude/skills/r-biostats/
覆盖 ~/.claude/skills/project-init/
覆盖 ~/.claude/skills/paper-writing/
```

**保留模式:**
```
跳过已存在的 skill
只安装不存在的 skill
```

**合并模式:**
```
读取现有 SKILL.md
合并 EpiClaude 内容
写入合并后的文件
```

---

### 步骤 4: 安装 CLAUDE.md

根据用户选择执行相应操作。

---

### 步骤 5: 安装 Agents (可选)

复制 agents 到 `~/.claude/agents/`:
- r-analyst.md
- paper-writer.md
- code-reviewer.md
- lit-helper.md

---

### 步骤 6: 配置 MCP Servers

检查 `~/.claude.json` 是否存在：

**如果不存在:** 创建新文件

**如果存在:** 合并 mcpServers 配置 (保留用户现有的，添加新的)

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
    }
  }
}
```

---

### 步骤 7: 验证安装

显示安装摘要：

```
✅ EpiClaude 安装完成！

📦 Skills:
   - r-biostats: ✅ 已安装 / 🔄 已合并 / ⏭️ 已跳过
   - project-init: ✅ 已安装
   - paper-writing: ✅ 已安装

📋 CLAUDE.md: ✅ 已安装 / 🔄 已合并

🤖 Agents: ✅ 4 个已安装

🔌 MCP Servers: ✅ 已配置

⚠️ 请重启 Claude Code 使配置生效！
```

---

## 项目级配置 (可选)

询问用户是否需要为当前项目配置：

```
是否为当前项目安装配置？
1️⃣ 是 - 复制 CLAUDE.md 和 templates 到当前项目
2️⃣ 否 - 只保留全局配置
```

如果选择"是"：
1. 复制 `CLAUDE.md` 到项目根目录
2. 复制 `templates/SESSION_LOG.md` 到项目根目录
3. 复制 `templates/DECISIONS.md` 到项目根目录
4. 创建标准七层目录结构 (如果不存在)

---

## 清理

安装完成后删除临时文件：

```bash
rm -rf /tmp/epiclaude
```
