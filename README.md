# 🚀 Antigravity Settings & Skills Sync

本仓库用于**一键备份与恢复** Antigravity (Claude/Gemini Agent) 的全局个性化配置、已安装的 Skills 知识库以及 macOS 开发环境依赖。

同时，本仓库结构经过精心设计，**其他主流 AI 编程工具与 Agent**（如 Cursor, Windsurf, Cline, Roo Code 等）可以直接读取、解析并加载本仓库中的配置与技能规则，实现跨工具的个性化能力无缝复用。

---

## 📂 目录结构说明

```text
.
├── Brewfile                # Homebrew 导出的软件与 CLI 工具依赖清单
├── npm-global.txt          # NPM 全局包依赖清单
├── backup.sh               # 一键备份脚本（收集本地配置并推送至本仓库）
├── restore.sh              # 一键恢复脚本（macOS 还原配置并增量装配本地依赖）
├── restore.ps1             # 一键恢复脚本（Windows 还原配置并增量装配本地依赖）
└── files/                  # 核心配置与技能打包目录
    ├── config/             # Antigravity 核心插件、Agents 声明与 sidecars
    ├── antigravity/        # 全局配置，包括 mcp_config.json 等
    └── antigravity-ide/
        ├── mcp_config.json # MCP 服务集成定义 (如 DevTools 等)
        ├── knowledge/      # 核心 Skills 库 (每个 Skill 均包含定制的 SKILL.md)
        └── skills/         # 快速技能快捷声明
```

---

## 🛠 一键备份与恢复指南

### 1. 首次备份 (Backup)
在当前已配置好的 macOS 环境中，运行以下命令：
```bash
./backup.sh
```
* **效果**：脚本会自动扫描本地 `~/.gemini` 下的配置、Skills，生成最新的 `Brewfile` 与 `npm-global.txt`，并生成带时间戳的 commit 自动推送到 GitHub。

### 2. 新机或重装恢复 (Restore)

#### 🍏 macOS 环境恢复
在新环境克隆本仓库后，直接运行：
```bash
./restore.sh
```
* **安全性保护**：脚本执行前会**自动**将你本地已有的配置备份至 `~/.gemini/backup_before_restore_<timestamp>`，绝不丢失任何数据。
* **效果**：一键还原所有全局配置、技能；智能检测并增量安装缺少的 Brew 软件和全局 NPM 包。

#### 🪟 Windows 环境恢复
在新环境使用 PowerShell 克隆本仓库后，执行以下命令：
1. **允许脚本运行（若遇到权限受阻）**：
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
   ```
2. **运行恢复脚本**：
   ```powershell
   ./restore.ps1
   ```
* **安全性保护**：脚本执行前会**自动**将你本地已有的配置备份至 `$env:USERPROFILE\.gemini\backup_before_restore_<timestamp>`，绝不丢失任何数据。
* **效果**：使用 Windows 原生 `robocopy` 增量还原所有全局配置与 Skills 库；智能检测并增量安装缺少的全局 NPM 包。对于 macOS 专有的 Homebrew 依赖，会输出友好指引，引导使用 Windows 包管理器（如 `winget` 或 `scoop`）对照手动安装。

---

## 🤖 跨 AI 工具免配置无缝使用指南

本仓库中备份的 **MCP 插件**、**用户规则 (User Rules)** 和 **Skills 知识库** 可以直接应用到其他 AI 工具中：

### 1. Cursor / Windsurf / VS Code Copilot
你可以直接将本仓库的规则作为全局/项目级的 Prompt 指引。
* **系统级/项目规则复用**：
  * **Cursor**: 复制 `files/config/` 或 `files/antigravity-ide/knowledge/` 下的特定 `SKILL.md`（如 `feishu-summary` 的提示词）到你的项目根目录 `.cursorrules` 文件中。
  * **Windsurf**: 复制对应规则到项目根目录的 `.windsurfrules` 文件中。
  * **GitHub Copilot**: 复制对应规则到 `.github/copilot-instructions.md`。

### 2. Cline / Roo Code (VS Code 插件级 Agent)
Cline 和 Roo Code 支持完整的 **MCP 协议** 与 **自定义 Rules**：
* **MCP 插件复用**：
  * 复制 `files/antigravity-ide/mcp_config.json` 中的 `mcpServers` 定义，直接粘贴到 Cline 的全局 MCP 配置文件中：
    * **Mac 路径**：`~/Library/Application Support/Code/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json`
  * 这将使 Cline 立即获得与 Antigravity 相同的工具能力（如 `chrome-devtools` 浏览器操作等）。
* **Skills/Rules 技能复用**：
  * Cline 支持在项目根目录放置 `.clinerules`。你可以直接通过软链接或复制本仓库中的 `SKILL.md` 规则作为 `.clinerules`，让 Cline 继承对应的专业技能。

### 3. 其他 LLM/Agent 消费本仓库中的 Skills
本仓库 `files/antigravity-ide/knowledge/` 目录下的子文件夹是**模块化设计**的技能包：
- **Feishu Summary (`feishu-summary/`)**：包含 Lark/飞书会议及会话深度提炼总结的技能设计。
- **Memory Management (`memory/`)**：包含跨会话自动上下文记忆与维护的技能设计。
- **Changelog Sync (`github-changelog-sync/`)**：自动同步变更日志的技能。

任何 AI 只要读取这些技能目录下的 `SKILL.md`，即可立即充当该领域的专家角色。
