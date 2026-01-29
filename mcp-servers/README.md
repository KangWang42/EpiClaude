# MCP Servers 配置

## Windows 配置文件位置

`%USERPROFILE%\.claude.json` 或项目根目录 `.claude.json`

## 推荐配置

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

## 说明

| Server | 功能 |
|--------|------|
| filesystem | 文件系统读写访问 |
| memory | 会话间记忆持久化 |
| sequential-thinking | 复杂问题分步思考 |

## 可选扩展

```json
{
  "github": {
    "command": "cmd",
    "args": ["/c", "npx", "-y", "@anthropic/mcp-github"],
    "env": {
      "GITHUB_TOKEN": "<your-pat>"
    }
  }
}
```
