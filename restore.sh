#!/bin/bash
set -e

# ==========================================
# Antigravity 个人设置与环境依赖一键恢复脚本
# ==========================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_FILES_DIR="$SCRIPT_DIR/files"

# 安全第一：创建本地现有配置的临时备份
LOCAL_BACKUP_TIME="$(date +'%Y%m%d_%H%M%S')"
LOCAL_TEMP_BACKUP="$HOME/.gemini/backup_before_restore_$LOCAL_BACKUP_TIME"

echo "=== [1/4] 安全性保护：备份当前本地配置 ==="
mkdir -p "$LOCAL_TEMP_BACKUP"

backup_local_path() {
    local path="$1"
    if [ -e "$path" ]; then
        echo "正在安全备份本地已有路径: $path -> $LOCAL_TEMP_BACKUP/"
        cp -R "$path" "$LOCAL_TEMP_BACKUP/"
    fi
}

backup_local_path "$HOME/.gemini/antigravity-ide/mcp_config.json"
backup_local_path "$HOME/.gemini/antigravity/mcp_config.json"
backup_local_path "$HOME/.gemini/config"
backup_local_path "$HOME/.gemini/antigravity-ide/knowledge"
backup_local_path "$HOME/.gemini/antigravity-ide/skills"
backup_local_path "$HOME/.agents/skills"

echo "✔ 本地状态已安全备份至: $LOCAL_TEMP_BACKUP"


echo -e "\n=== [2/4] 开始还原 Antigravity 配置与 Skills ==="

restore_dir() {
    local src="$1"
    local dest="$2"
    if [ -d "$src" ]; then
        echo "正在还原目录: $src -> $dest"
        mkdir -p "$(dirname "$dest")"
        rsync -av --delete "$src/" "$dest/"
    else
        echo "ℹ 备份中无此目录，跳过: $src"
    fi
}

restore_file() {
    local src="$1"
    local dest="$2"
    if [ -f "$src" ]; then
        echo "正在还原文件: $src -> $dest"
        mkdir -p "$(dirname "$dest")"
        cp "$src" "$dest"
    else
        echo "ℹ 备份中无此文件，跳过: $src"
    fi
}

# 还原全局 MCP 配置
restore_file "$BACKUP_FILES_DIR/antigravity-ide/mcp_config.json" "$HOME/.gemini/antigravity-ide/mcp_config.json"
restore_file "$BACKUP_FILES_DIR/antigravity/mcp_config.json" "$HOME/.gemini/antigravity/mcp_config.json"

# 还原全局 Config (含 plugins, agents, sidecars 等)
restore_dir "$BACKUP_FILES_DIR/config" "$HOME/.gemini/config"

# 还原 Skills 目录
restore_dir "$BACKUP_FILES_DIR/antigravity-ide/knowledge" "$HOME/.gemini/antigravity-ide/knowledge"
restore_dir "$BACKUP_FILES_DIR/antigravity-ide/skills" "$HOME/.gemini/antigravity-ide/skills"
restore_dir "$BACKUP_FILES_DIR/agents/skills" "$HOME/.agents/skills"

echo "✔ 配置与 Skills 还原完成"


echo -e "\n=== [3/4] 开始安装环境依赖 ==="

# 1. 恢复 Homebrew 依赖
if [ -f "$SCRIPT_DIR/Brewfile" ]; then
    if command -v brew &> /dev/null; then
        echo "检测到 Brewfile，正在安装/更新 Homebrew 依赖..."
        brew bundle --file="$SCRIPT_DIR/Brewfile" || echo "⚠️ 部分 Brew 依赖安装遇到警告，继续运行..."
        echo "✔ Homebrew 依赖恢复完成"
    else
        echo "⚠️ 警告: 检测到 Brewfile 但未找到 brew 命令，请先安装 Homebrew！"
    fi
else
    echo "ℹ 未检测到 Brewfile 备份，跳过 Brew 恢复"
fi

# 2. 恢复 NPM 全局包
if [ -f "$SCRIPT_DIR/npm-global.txt" ]; then
    if command -v npm &> /dev/null; then
        echo "检测到 npm-global.txt，正在比对并增量安装 NPM 全局工具..."
        while IFS= read -r pkg || [ -n "$pkg" ]; do
            if [ -n "$pkg" ]; then
                if ! npm list -g --depth=0 "$pkg" &> /dev/null; then
                    echo "正在安装全局包: $pkg"
                    npm install -g "$pkg" || echo "⚠️ $pkg 安装失败，继续..."
                else
                    echo "✔ 全局包已存在: $pkg"
                fi
            fi
        done < "$SCRIPT_DIR/npm-global.txt"
        echo "✔ NPM 全局依赖恢复完成"
    else
        echo "⚠️ 警告: 检测到 npm-global.txt 但未找到 npm 命令，请先安装 Node.js/NPM！"
    fi
else
    echo "ℹ 未检测到 npm-global.txt 备份，跳过 NPM 恢复"
fi


echo -e "\n=== [4/4] 完成还原 ==="
echo "🎉 还原工作全部结束！如有配置问题，可在 $LOCAL_TEMP_BACKUP 找回原始文件。"
