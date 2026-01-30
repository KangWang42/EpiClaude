# MCP Servers 配置

## Windows 配置文件位置

`%USERPROFILE%\.claude.json` 或项目根目录 `.claude.json`

## 推荐配置

```json
{
"mcpServers": {
    "fetch": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-fetch"],
      "description": "网页内容抓取"
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-filesystem", "你的工作目录"],
      "description": "文件系统访问"
    },
    "memory": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-memory"],
      "description": "持久化记忆存储"
    },
    "sequential-thinking": {
      "command": "npx",
      "args": ["-y", "@anthropic-ai/mcp-server-sequential-thinking"],
      "description": "复杂推理增强"
    },
    "markitdown": {
      "command": "docker",
      "args": ["run", "--rm", "-i", "markitdown-mcp:latest"],
      "description": "PDF/Word/Excel 转 Markdown (需安装 Docker)"
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"],
      "description": "获取最新版本的文档和代码示例"
    }
  }
}
```

## 说明

| Server              | 功能             |
| ------------------- | ---------------- |
| filesystem          | 文件系统读写访问 |
| memory              | 会话间记忆持久化 |
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
