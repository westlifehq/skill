# =========================================================
# Antigravity 个人设置与环境依赖一键恢复脚本 (Windows PowerShell 版)
# =========================================================

# 发生错误时停止执行
$ErrorActionPreference = "Stop"

$SCRIPT_DIR = $PSScriptRoot
$BACKUP_FILES_DIR = Join-Path $SCRIPT_DIR "files"

# 安全第一：创建本地现有配置的临时备份
$LOCAL_BACKUP_TIME = Get-Date -Format "yyyyMMdd_HHmmss"
$LOCAL_TEMP_BACKUP = Join-Path $env:USERPROFILE ".gemini\backup_before_restore_$LOCAL_BACKUP_TIME"

Write-Host "=== [1/4] 安全性保护：备份当前本地配置 ===" -ForegroundColor Cyan

function Backup-LocalPath {
    param (
        [string]$path
    )
    if (Test-Path $path) {
        Write-Host "正在安全备份本地已有路径: $path -> $LOCAL_TEMP_BACKUP\" -ForegroundColor Gray
        # 确保目标备份根目录存在
        if (!(Test-Path $LOCAL_TEMP_BACKUP)) {
            New-Item -ItemType Directory -Path $LOCAL_TEMP_BACKUP -Force | Out-Null
        }
        
        $leafName = Split-Path $path -Leaf
        $destPath = Join-Path $LOCAL_TEMP_BACKUP $leafName

        if (Test-Path $path -PathType Container) {
            # 目录复制
            Copy-Item -Path $path -Destination $destPath -Recurse -Force
        } else {
            # 文件复制
            Copy-Item -Path $path -Destination $destPath -Force
        }
    }
}

Backup-LocalPath (Join-Path $env:USERPROFILE ".gemini\antigravity-ide\mcp_config.json")
Backup-LocalPath (Join-Path $env:USERPROFILE ".gemini\antigravity\mcp_config.json")
Backup-LocalPath (Join-Path $env:USERPROFILE ".gemini\config")
Backup-LocalPath (Join-Path $env:USERPROFILE ".gemini\antigravity-ide\knowledge")
Backup-LocalPath (Join-Path $env:USERPROFILE ".gemini\antigravity-ide\skills")
Backup-LocalPath (Join-Path $env:USERPROFILE ".agents\skills")
Backup-LocalPath (Join-Path $env:APPDATA "Code\User\settings.json")
Backup-LocalPath (Join-Path $env:APPDATA "Code\User\keybindings.json")
Backup-LocalPath (Join-Path $env:APPDATA "Code\User\globalStorage\saoudrizwan.claude-dev\settings\cline_mcp_settings.json")
Backup-LocalPath (Join-Path $env:APPDATA "Code\User\globalStorage\roodev.rogue-dev\settings\cline_mcp_settings.json")
Backup-LocalPath (Join-Path $env:USERPROFILE ".claude.json")
Backup-LocalPath (Join-Path $env:USERPROFILE ".clauderules")

Write-Host "✔ 本地状态已安全备份至: $LOCAL_TEMP_BACKUP" -ForegroundColor Green


Write-Host ""
Write-Host "=== [2/4] 开始还原 Antigravity 配置与 Skills ===" -ForegroundColor Cyan

function Restore-Dir {
    param (
        [string]$src,
        [string]$dest
    )
    if (Test-Path $src) {
        Write-Host "正在还原目录: $src -> $dest" -ForegroundColor Gray
        # 确保父目录存在
        $parent = Split-Path $dest -Parent
        if (!(Test-Path $parent)) {
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
        }
        
        # 使用 robocopy 镜像拷贝，/MIR 类似于 rsync --delete
        # robocopy 退出代码小于 8 都代表复制成功或者没有严重错误发生
        robocopy $src $dest /MIR /NP /NFL /NDL /NJH /NJS | Out-Null
        if ($LASTEXITCODE -ge 8) {
            Write-Warning "还原目录 $src 失败，退出码: $LASTEXITCODE"
        }
    } else {
        Write-Host "ℹ 备份中无此目录，跳过: $src" -ForegroundColor Yellow
    }
}

function Restore-File {
    param (
        [string]$src,
        [string]$dest
    )
    if (Test-Path $src) {
        Write-Host "正在还原文件: $src -> $dest" -ForegroundColor Gray
        $parent = Split-Path $dest -Parent
        if (!(Test-Path $parent)) {
            New-Item -ItemType Directory -Path $parent -Force | Out-Null
        }
        Copy-Item $src $dest -Force
    } else {
        Write-Host "ℹ 备份中无此文件，跳过: $src" -ForegroundColor Yellow
    }
}

# 还原全局 MCP 配置
Restore-File (Join-Path $BACKUP_FILES_DIR "antigravity-ide\mcp_config.json") (Join-Path $env:USERPROFILE ".gemini\antigravity-ide\mcp_config.json")
Restore-File (Join-Path $BACKUP_FILES_DIR "antigravity\mcp_config.json") (Join-Path $env:USERPROFILE ".gemini\antigravity\mcp_config.json")

# 还原 VS Code 与 AI 插件配置 (Codex / Cline / Roo Code)
Restore-File (Join-Path $BACKUP_FILES_DIR "vscode\settings.json") (Join-Path $env:APPDATA "Code\User\settings.json")
Restore-File (Join-Path $BACKUP_FILES_DIR "vscode\keybindings.json") (Join-Path $env:APPDATA "Code\User\keybindings.json")
Restore-File (Join-Path $BACKUP_FILES_DIR "vscode\cline_mcp_settings.json") (Join-Path $env:APPDATA "Code\User\globalStorage\saoudrizwan.claude-dev\settings\cline_mcp_settings.json")
Restore-File (Join-Path $BACKUP_FILES_DIR "vscode\roo_mcp_settings.json") (Join-Path $env:APPDATA "Code\User\globalStorage\roodev.rogue-dev\settings\cline_mcp_settings.json")

# 还原 Claude Code CLI 配置与全局 Rules
Restore-File (Join-Path $BACKUP_FILES_DIR "claude\claude.json") (Join-Path $env:USERPROFILE ".claude.json")
Restore-File (Join-Path $BACKUP_FILES_DIR "claude\clauderules") (Join-Path $env:USERPROFILE ".clauderules")

# 还原全局 Config (含 plugins, agents, sidecars 等)
Restore-Dir (Join-Path $BACKUP_FILES_DIR "config") (Join-Path $env:USERPROFILE ".gemini\config")

# 还原 Skills 目录
Restore-Dir (Join-Path $BACKUP_FILES_DIR "antigravity-ide\knowledge") (Join-Path $env:USERPROFILE ".gemini\antigravity-ide\knowledge")
Restore-Dir (Join-Path $BACKUP_FILES_DIR "antigravity-ide\skills") (Join-Path $env:USERPROFILE ".gemini\antigravity-ide\skills")
Restore-Dir (Join-Path $BACKUP_FILES_DIR "agents\skills") (Join-Path $env:USERPROFILE ".agents\skills")

Write-Host "✔ 配置与 Skills 还原完成" -ForegroundColor Green


Write-Host ""
Write-Host "=== [3/4] 开始安装环境依赖 ===" -ForegroundColor Cyan

# 1. 恢复 Brewfile 提示
$brewFile = Join-Path $SCRIPT_DIR "Brewfile"
if (Test-Path $brewFile) {
    Write-Host "ℹ 检测到 Brewfile，但 Windows 环境不支持 Homebrew。" -ForegroundColor Yellow
    Write-Host "   建议你手动打开 Brewfile，对照其中的依赖列表，使用 Windows 原生包管理器安装。" -ForegroundColor Yellow
    Write-Host "   例如，使用 Winget 或者是 Scoop 进行安装：" -ForegroundColor Yellow
    Write-Host "   winget install <package-id>   或   scoop install <package-name>" -ForegroundColor Yellow
} else {
    Write-Host "ℹ 未检测到 Brewfile 备份，跳过 Brew 提示" -ForegroundColor Gray
}

# 2. 恢复 NPM 全局包
$npmGlobalFile = Join-Path $SCRIPT_DIR "npm-global.txt"
if (Test-Path $npmGlobalFile) {
    if (Get-Command npm -ErrorAction SilentlyContinue) {
        Write-Host "检测到 npm-global.txt，正在比对并增量安装 NPM 全局工具..." -ForegroundColor Gray
        $pkgs = Get-Content $npmGlobalFile
        foreach ($pkg in $pkgs) {
            $pkg = $pkg.Trim()
            if ($pkg) {
                # 检查包是否已全局安装
                npm list -g --depth=0 $pkg | Out-Null
                if ($LASTEXITCODE -ne 0) {
                    Write-Host "正在安装全局包: $pkg" -ForegroundColor Yellow
                    npm install -g $pkg
                } else {
                    Write-Host "✔ 全局包已存在: $pkg" -ForegroundColor Green
                }
            }
        }
        Write-Host "✔ NPM 全局依赖恢复完成" -ForegroundColor Green
    } else {
        Write-Warning "⚠️ 警告: 检测到 npm-global.txt 但未找到 npm 命令，请先安装 Node.js/NPM！"
    }
} else {
    Write-Host "ℹ 未检测到 npm-global.txt 备份，跳过 NPM 恢复" -ForegroundColor Gray
}


Write-Host ""
Write-Host "=== [4/4] 完成还原 ===" -ForegroundColor Cyan
Write-Host "🎉 还原工作全部结束！如有配置问题，可在 $LOCAL_TEMP_BACKUP 找回原始文件。" -ForegroundColor Green
