# EpiClaude Hooks 配置

> 将以下内容添加到 `~/.claude/settings.json` 中

## 功能说明

| Hook 类型 | 触发时机 | 功能 |
|-----------|----------|------|
| **PostToolUse** | 文件写入后 | 提醒检查 SESSION_LOG.md 和 0_result_summaries.md |
| **PreToolUse** | 文件写入前 | 检查 02_code 下文件命名规范 |

## Windows 配置

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "powershell -NoProfile -Command \"Write-Host '⚠️ [EpiClaude] 检查: SESSION_LOG.md + 0_result_summaries.md 是否需要更新?'\""
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
  },
  "permissions": {
    "defaultMode": "dontAsk",
    "allow": [
      "Bash(Rscript:*)",
      "Bash(R:*)"
    ]
  }
}
```

## macOS/Linux 配置

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "echo '⚠️ [EpiClaude] 检查: SESSION_LOG.md + 0_result_summaries.md 是否需要更新?'"
          }
        ]
      }
    ]
  },
  "permissions": {
    "allow": [
      "Bash(Rscript:*)",
      "Bash(R:*)"
    ]
  }
}
```

## 规则说明

1. **SESSION_LOG.md** - 每次操作后记录
2. **0_result_summaries.md** - 结果变化时同步更新，只保留最终方案
3. **Rscript 权限** - 允许 AI 自动运行 R 代码验证
