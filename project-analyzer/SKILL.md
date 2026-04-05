---
name: project-analyzer
description: 扫描和分析当前项目的架构、依赖以及潜在的技术债务（如 TODO 和 FIXME）。
---

# Project Analyzer Skill

当需要分析一个新项目或当前代码库状态时：

1. **识别技术栈**：检查 \`package.json\`, \`requirements.txt\`, \`go.mod\` 等文件以确定主要语言和框架。
2. **目录结构**：使用工具遍历根目录（跳过 node_modules, .git 等），理清核心模块。
3. **扫描技术债务**：
   - 搜索代码库中的 \`TODO\`, \`FIXME\`, \`HACK\` 等注释。
   - 提取出这些待办事项并按文件或模块归类。
4. **生成报告**：
   - 概要：项目目标和技术栈一览。
   - 架构：核心目录和文件职责。
   - 技术债务汇总：列出需要关注的遗留问题。
