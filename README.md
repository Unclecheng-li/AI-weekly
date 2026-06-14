<div align="center">

# AI 周报速递

> 每周一份 AI 领域深度简报，覆盖大模型、LLM、AI Coding、AI Agent、Skill 及相关方向。AI 生成，人工校验，自动发布。

[![GitHub Pages](https://img.shields.io/badge/Deploy-GitHub_Pages-blue)](https://unclecheng-li.github.io/ai-weekly/)
[![Status](https://img.shields.io/badge/Status-Weekly-green)](#运行方式)
[![Auto](https://img.shields.io/badge/Automation-WorkBuddy-orange)](#技术栈)

**在线阅读**：https://unclecheng-li.github.io/ai-weekly/

</div>

---

## 这是什么

一个自动化 AI 周报项目。每周日中午自动抓取本周的 AI 领域动态，挑出 5-7 条值得看的，生成 Markdown 报告和 HTML 页面，推送到 GitHub Pages。

跟新闻聚合和 RSS 转发不一样，这边每条内容都带筛选、解读和原始出处链接。

---

## 为什么要搞这个

AI 领域信息量爆炸，每周都有大量模型发布、融资事件、技术突破。真正值得关注的可能就那么几条。

这个项目就干一件事，帮你过一遍，把本周该看的挑出来，说清楚为什么该看。10 分钟，跟上本周的 AI 态势。

---

## 内容长什么样

每期周报包含：

| 板块 | 说明 |
|------|------|
| 头条 | 本周最值得关注的事件，通常带深度分析 |
| 重点分析 | 5-7 条深度内容，包含事件背景、影响分析、值得关注的原因 |
| 可视化 | Mermaid 图表（象限图、流程图、时序图、饼图、甘特图等，按内容选配） |
| 时间线 | 本周事件时间线 |
| 下周关注 | 下周值得关注的事件预告 |
| 出处链接 | 每条内容的原始来源，方便你进一步追踪 |

HTML 页面用了报纸风格的排版，支持移动端和打印。

---

## 运行方式

周报由 WorkBuddy 自动化工作流驱动，每周日中午 12:00 自动执行：

1. 搜索本周 AI 领域新闻（大模型、LLM、AI Coding、AI Agent 等）
2. 筛选 5-7 条最有价值的内容
3. 生成 Markdown 报告（含 Mermaid 图表）
4. 基于 HTML 模板生成周报页面
5. 生成全页长截图
6. 更新首页存档列表
7. 推送到 GitHub 仓库，Pages 自动更新

---

## 技术栈

- **内容生成**：WorkBuddy 自动化 + AI 模型（信息检索、筛选、摘要）
- **页面**：纯静态 HTML + CSS，无框架依赖
- **图表**：Mermaid.js（象限图、流程图、时序图、饼图、甘特图）
- **截图**：Python Playwright（全页长截图）
- **部署**：GitHub Pages，推送到 `main` 分支即发布
- **自动化**：WorkBuddy 定时任务（`rrule: FREQ=WEEKLY;BYDAY=SU;BYHOUR=12`）

---

## 项目结构

```text
ai-weekly/
├── index.html              # 首页（存档列表，数据内联）
├── assets/
│   └── style.css           # 公共样式（报纸风格）
├── weekly/
│   ├── 2026-06-14.html     # 周报页面（按日期命名）
│   ├── 2026-06-07.html
│   └── ...
└── deploy.sh               # 部署脚本（复制HTML + 更新首页 + git push）
```

---

## 本地预览

```bash
git clone https://github.com/Unclecheng-li/ai-weekly.git
cd ai-weekly

# 直接用浏览器打开
open index.html        # macOS
start index.html       # Windows
```

或者起个本地服务器：

```bash
python -m http.server 8080
# 访问 http://localhost:8080
```

---

## 许可证

本项目使用 [MIT License](LICENSE)。

---

<div align="center">

**每周 10 分钟，跟上 AI 态势。**

</div>
