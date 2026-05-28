#!/usr/bin/env bash
# ==============================================================================
# 🤖 obsidian-sync 附件与源文件极速同步脚本 (sync.sh)
# ==============================================================================
# 作用：将其他 Skill 产出的原始 HTML、图片或飞书导出文件安全地搬运至 Obsidian 库的
#      /99 附件与源文件/ 文件夹下，同时处理同名冲突、防覆盖后缀累加及目录自动初始化。
# ==============================================================================

set -euo pipefail

# 默认 Obsidian Vault 物理基准路径
VAULT_DIR="/Users/hq/Desktop/Obsidian/ai"
TARGET_SUBDIR="99 附件与源文件"
TARGET_DIR="${VAULT_DIR}/${TARGET_SUBDIR}"

# 打印使用说明
usage() {
    echo "使用方法: $0 <源文件绝对路径> [简要标题] [调用者Skill名称]"
    echo "示例: $0 /Users/hq/Desktop/report.html \"家庭网络讨论会\" \"summary-html\""
    exit 1
}

# 参数校验
if [ "$#" -lt 1 ]; then
    usage
fi

SRC_FILE="$1"
RAW_TITLE="${2:-"未命名附件"}"
SOURCE_SKILL="${3:-"ad-hoc"}"

# 验证源文件存在性
if [ ! -f "${SRC_FILE}" ]; then
    echo "❌ 错误: 源文件不存在 -> ${SRC_FILE}"
    exit 1
fi

# 确保目标输出目录绝对存在
mkdir -p "${TARGET_DIR}"

# 提取源文件后缀名
EXT="${SRC_FILE##*.}"
TODAY=$(date "+%Y-%m-%d")

# 清洗标题中的非法字符 (防止文件路径崩溃)
# 去除 \ / : * ? " < > | 等非法字符
CLEAN_TITLE=$(echo "${RAW_TITLE}" | sed 's/[\\/:*?"<>|]/_/g')

# 拼装基础目标文件名
DEST_FILENAME="${TODAY} · ${CLEAN_TITLE}.${EXT}"
DEST_PATH="${TARGET_DIR}/${DEST_FILENAME}"

# ------------------------------------------------------------------------------
# 🔄 核心防覆盖重名累加器
# ------------------------------------------------------------------------------
COUNTER=1
while [ -f "${DEST_PATH}" ]; do
    COUNTER=$((COUNTER + 1))
    DEST_FILENAME="${TODAY} · ${CLEAN_TITLE}-${COUNTER}.${EXT}"
    DEST_PATH="${TARGET_DIR}/${DEST_FILENAME}"
done

# ------------------------------------------------------------------------------
# 🚀 物理复制动作与校验
# ------------------------------------------------------------------------------
echo "📦 正在复制附件..."
echo "👉 源地址: ${SRC_FILE}"
echo "👉 目标地: ${DEST_PATH}"

cp "${SRC_FILE}" "${DEST_PATH}"

if [ -f "${DEST_PATH}" ]; then
    echo "✅ 附件同步成功！"
    # 输出相对路径，供调用者 skill 作为 related 或 Wiki 链接直接引用
    echo "RELATIVE_PATH: ../${TARGET_SUBDIR}/${DEST_FILENAME}"
else
    echo "❌ 错误: 复制失败！"
    exit 1
fi
