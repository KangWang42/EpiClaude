# EpiClaude Hooks 配置

> 将以下内容添加到 `~/.claude/settings.json` 中

## 功能说明

| Hook 类型 | 触发时机 | 功能 |
|-----------|----------|------|
| **PostToolUse** | 文件写入后 | 提醒更新 SESSION_LOG.md |
| **PreToolUse** | 文件写入前 | 检查 02_code 下文件命名规范 |

## 配置代码

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "powershell -NoProfile -Command \"Write-Host '⚠️ [EpiClaude] 记得更新 SESSION_LOG.md!'\""
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "powershell -NoProfile -Command \"$path = $env:CLAUDE_TOOL_INPUT_PATH; if ($path -match '02_code' -and $path -notmatch '^\\d{2}_') { Write-Host '❌ [EpiClaude] R脚本必须用 NN_xxx.R 格式命名!' -ForegroundColor Red; exit 1 }\""
          }
        ]
      }
    ]
  }
}
```

## macOS/Linux 版本

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "echo '⚠️ [EpiClaude] 记得更新 SESSION_LOG.md!'"
          }
        ]
      }
    ]
  }
}
```
