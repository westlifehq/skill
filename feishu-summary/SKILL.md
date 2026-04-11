---
name: feishu-summary
description: 总结会话内容或根据特定需求生成精美的飞书 (Lark) 文档。当用户请求“总结讨论”、“生成飞书文档”或“基于内容写个报告”时触发。该 Skill 使用 lark-cli，支持“对话总结”和“自定义文档生成”两种模式。
---

# Feishu Summary Skill (High Performance)

本 Skill 旨在将对话或特定指令转化为逻辑严密、阅读体验极佳的飞书文档。

## 触发场景

- **对话总结**：“总结一下我们刚才聊的内容，发到飞书上。”
- **自定义文档（基于背景）**：“帮我把这个技术方案整理成飞书文档。”
- **定向内容生成**：“帮我写一份详细的苹果 M1/M2/M3 芯片对比，同步到飞书。”

## 核心流程 (Workflow)

1. **意图判断 (Intent Classification)**：
   - 如果是总结对话，进入 **模式 A (Summary Mode)**。
   - 如果是具体知识点或报告生成，进入 **模式 B (Generation Mode)**。

2. **内容准备**：
   - **模式 A (Summary Mode)**：读取 [assets/template.md](assets/template.md)，提取核心决策点和行动项进行填充。
   - **模式 B (Generation Mode)**：参考当前对话背景（如果相关且用户未明确禁止），直接构思一个专业的 Markdown 文档结构。标题应醒目，内容应包含深度调研（如果需要，先执行调研）或基于已知事实的系统化整理。

3. **创建飞书文档**：
   - **标题 (Title)**：如果是总结，使用 `Summary: [话题]`；如果是文档，使用 `[主题名称]`。
   - **执行命令**：
     ```bash
     lark-cli docs +create --title "[你的标题]" --markdown "[生成的Markdown内容]" --folder-token "PLmPfbXk7ltad0dOy9pcHIYEn7I"
     ```
   - **注意**：确保 Markdown 转义处理正确，特别是多行字符串和特殊字符。

## 设计原则 (Design Aesthetics)

- **Premium Feel**: 使用分级标题、列表、引用块和表格，确保文档具有“精装修”感。
- **PlantUML Standards (Drawing Board Mode)**: 默认所有业务流、时序、逻辑图必须采用 PlantUML。
    - **矢量优化语法**: 必须使用 `:start;` 与 `:end;`（而非 `start/stop`），确保用户在飞书端点击“转换为画板”后能完美矢量化。
    - **逻辑对齐**: 优先使用活动图 (Activity Diagram) 表述复杂决策分支。
- **Context Awareness**: 在自定义生成模式下，若对话中提到过特定细节（如用户的偏好、特定数据），应巧妙地融合进去。
- **Accuracy**: 确保技术参数（如汽车软件中的 SecOC, HSM, Thatcham S5 等参数）准确无误。

## 资源引用

- **总结模板**: [assets/template.md](assets/template.md)
- **通用模板 (参考)**: [assets/generic_template.md](assets/generic_template.md)
