#!/bin/bash
set -e

# ==========================================
# Antigravity 个人设置与环境依赖一键备份脚本
# ==========================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_FILES_DIR="$SCRIPT_DIR/files"

echo "=== [1/4] 开始备份系统级环境依赖 ==="

# 1. 备份 Homebrew 依赖
if command -v brew &> /dev/null; then
    echo "正在导出 Brewfile..."
    brew bundle dump --file="$SCRIPT_DIR/Brewfile" --force
    echo "✔ Brewfile 备份完成"
else
    echo "ℹ 未检测到 brew，跳过 Brewfile 备份"
fi

# 2. 备份 NPM 全局包列表
if command -v npm &> /dev/null; then
    echo "正在导出全局 NPM 包列表..."
    # 仅获取包名，排除 npm 本身
    npm list -g --depth=0 --parseable | grep -v 'node_modules/npm$' | grep -v 'lib$' | awk -F/ '{print $NF}' > "$SCRIPT_DIR/npm-global.txt" || true
    echo "✔ npm-global.txt 备份完成"
else
    echo "ℹ 未检测到 npm，跳过 NPM 全局包备份"
fi


echo -e "\n=== [2/4] 开始备份 Antigravity 全局设置与 Skills ==="

# 辅助同步函数
sync_dir() {
    local src="$1"
    local dest="$2"
    if [ -d "$src" ]; then
        echo "正在备份目录: $src -> $dest"
        mkdir -p "$(dirname "$dest")"
        rsync -av --delete "$src/" "$dest/"
    else
        echo "ℹ 目录不存在，跳过: $src"
    fi
}

sync_file() {
    local src="$1"
    local dest="$2"
    if [ -f "$src" ]; then
        echo "正在备份文件: $src -> $dest"
        mkdir -p "$(dirname "$dest")"
        cp "$src" "$dest"
    else
        echo "ℹ 文件不存在，跳过: $src"
    fi
}

# 备份全局 MCP 配置
sync_file "$HOME/.gemini/antigravity-ide/mcp_config.json" "$BACKUP_FILES_DIR/antigravity-ide/mcp_config.json"
sync_file "$HOME/.gemini/antigravity/mcp_config.json" "$BACKUP_FILES_DIR/antigravity/mcp_config.json"

# 备份 VS Code 与 AI 插件配置 (Codex / Cline / Roo Code)
sync_file "$HOME/Library/Application Support/Code/User/settings.json" "$BACKUP_FILES_DIR/vscode/settings.json"
sync_file "$HOME/Library/Application Support/Code/User/keybindings.json" "$BACKUP_FILES_DIR/vscode/keybindings.json"
sync_file "$HOME/Library/Application Support/Code/User/globalStorage/saoudrizwan.claude-dev/settings/cline_mcp_settings.json" "$BACKUP_FILES_DIR/vscode/cline_mcp_settings.json"
sync_file "$HOME/Library/Application Support/Code/User/globalStorage/roodev.rogue-dev/settings/cline_mcp_settings.json" "$BACKUP_FILES_DIR/vscode/roo_mcp_settings.json"

# 备份 Claude Code CLI 配置与全局 Rules
sync_file "$HOME/.claude.json" "$BACKUP_FILES_DIR/claude/claude.json"
sync_file "$HOME/.clauderules" "$BACKUP_FILES_DIR/claude/clauderules"

# 备份全局 Config (含 plugins, agents, sidecars 等)
sync_dir "$HOME/.gemini/config" "$BACKUP_FILES_DIR/config"

# 备份 Skills 目录
sync_dir "$HOME/.gemini/antigravity-ide/knowledge" "$BACKUP_FILES_DIR/antigravity-ide/knowledge"
sync_dir "$HOME/.gemini/antigravity-ide/skills" "$BACKUP_FILES_DIR/antigravity-ide/skills"
sync_dir "$HOME/.agents/skills" "$BACKUP_FILES_DIR/agents/skills"

echo "✔ 配置与 Skills 备份完成"


echo -e "\n=== [3/4] 验证备份结构 ==="
if [ -d "$BACKUP_FILES_DIR" ]; then
    echo "备份文件目录结构如下："
    find "$BACKUP_FILES_DIR" -maxdepth 3 | sed "s|$BACKUP_FILES_DIR|  |"
fi


echo -e "\n=== [4/4] 自动提交至 Git 仓库 ==="
cd "$SCRIPT_DIR"

# 检查是否有更改需要提交
if [ -n "$(git status --porcelain)" ]; then
    git add .
    git commit -m "Backup: $(date +'%Y-%m-%d %H:%M:%S')"
    echo "✔ 备份已成功提交至本地 Git"
    echo "正在推送至远程 GitHub 仓库..."
    git push origin main
    echo "✔ 已成功增量同步至 GitHub"
else
    echo "✔ 没有检测到任何配置变化，无需推送"
fi

echo -e "\n🎉 备份全部完成！"
