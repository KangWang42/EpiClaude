# 🔌 Claude Code Plugins 教程

> 使用 `/plugin` 命令管理插件，扩展 Claude Code 功能

---

## 什么是 Plugins？

Plugins（插件）可以为 Claude Code 添加：
- 自定义 slash 命令
- 新的 Agents
- 额外功能

---

## 管理插件

在 Claude Code 中输入：

```bash
/plugin
```

会打开插件管理界面，可以：
- 查看已安装插件
- 安装新插件
- 卸载插件
- 启用/禁用插件

---

## 安装插件

### 从 URL 安装

```bash
/plugin
→ 选择 "Install"
→ 输入插件 URL
```

### 从本地安装

```bash
/plugin
→ 选择 "Install from path"
→ 输入本地路径
```

---

## Plugins vs MCP vs Skills vs Agents

| 组件 | 安装方式 | 功能 |
| ---- | -------- | ---- |
| **Plugins** | `/plugin` 命令 | 扩展包 (命令+代理) |
| **MCP Servers** | `.claude.json` | 连接外部服务 |
| **Skills** | 复制到 `~/.claude/skills/` | 领域知识库 |
| **Agents** | `/agents` 创建 | 专门化代理 |

---

## 推荐插件

| 插件 | 用途 |
| ---- | ---- |
| code-simplifier | 代码简化 |
| 更多插件持续更新... | |

---

## 创建自定义插件

插件结构：

```
my-plugin/
├── plugin.json          # 插件配置
├── commands/            # 自定义命令
│   └── my-command.md
└── agents/              # 插件代理
    └── my-agent.md
```

**plugin.json:**

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "我的插件"
}
```

---

## 更多资源

- [Claude Code Plugins 文档](https://docs.anthropic.com/en/docs/claude-code/plugins)
- [Agents 教程](AGENTS.md)
