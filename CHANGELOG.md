# 📝 Antigravity Sync 变更日志 (Changelog)

所有本同步工具的重要更新都将在此文件中记录。本文件遵循 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/) 规范。

---

## [v1.0.1] - 2026-05-24

### 📝 变更概述
- **分支/提交**: `main`
- **受影响范围**: `backup.sh`

### 🚀 新增功能
- 为 `backup.sh` 脚本新增**自动推送 (Automatic Push)** 能力。现在运行 `./backup.sh` 会在本地提交完成后，全自动执行 `git push origin main` 将增量更新推送至远程 GitHub 仓库，真正实现“一键全自动同步”。

---

## [v1.0.0] - 2026-05-24

### 📝 变更概述
- **分支/提交**: `main` (Commit: `19522da`)
- **受影响范围**: `/` (根目录初始化)

### 🚀 新增功能
- **一键备份脚本 (`backup.sh`)**：收集全局 MCP 配置、IDE 技能库 (`knowledge/` & `skills/`) 以及导出全局 NPM 包和 Homebrew 依赖。
- **一键恢复脚本 (`restore.sh`)**：支持安全的本地已有配置自动备份机制（防丢失），并自动安装缺失的系统级开发依赖。
- **跨 AI 工具无缝整合**：提供详尽的 `README.md`，深度支持 **Cursor**, **Windsurf**, **VS Code Cline / Roo Code** 直接加载本仓库的规则与 MCP 工具。
