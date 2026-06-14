#!/bin/bash
# ============================================
# AI 周报速递 - 一键部署脚本
# 用法: bash deploy.sh [commit message]
# ============================================

set -e

PROJECT_DIR="C:/Users/UncleC/Desktop/ai-weekly"
REPORTS_DIR="C:/Users/UncleC/WorkBuddy/automation-20260404114523"
PYTHON="C:/Users/UncleC/.workbuddy/binaries/python/versions/3.13.12/python.exe"

cd "$PROJECT_DIR"

echo "==> [1/4] 复制最新HTML周报..."
# 查找automation目录中最新的HTML文件（命名格式: AI周报速递-YYYY年X月X周.html）
latest_html=$(ls -t "$REPORTS_DIR"/AI周报速递-*.html 2>/dev/null | head -1)

if [ -z "$latest_html" ]; then
    echo "    未找到HTML周报文件，跳过复制"
else
    filename=$(basename "$latest_html")
    # 从文件名中提取日期（如：AI周报速递-2026年6月第2周.html -> 2026-06-14）
    # 这里简化处理，直接用当前日期
    date_str=$(date +%Y-%m-%d)
    cp "$latest_html" "weekly/$date_str.html"
    echo "    复制: $filename -> weekly/$date_str.html"
fi

echo "==> [2/4] 自动更新 index.html 存档数据..."
# 扫描 weekly/ 目录下所有 YYYY-MM-DD.html，自动生成 ARCHIVE_DATA 并替换到 index.html
$PYTHON -c "
import os, re, json
from datetime import datetime

weekly_dir = 'weekly'
index_path = 'index.html'

# 收集所有周报HTML文件
entries = []
weekdays = ['星期一','星期二','星期三','星期四','星期五','星期六','星期日']

for f in sorted(os.listdir(weekly_dir), reverse=True):
    m = re.match(r'(\d{4}-\d{2}-\d{2})\.html$', f)
    if not m:
        continue
    date_str = m.group(1)

    # 从HTML中提取关键词
    keywords = ''
    filepath = os.path.join(weekly_dir, f)
    try:
        with open(filepath, 'r', encoding='utf-8') as fh:
            content = fh.read()
            # 尝试从 headline-subtitle 提取
            kw_match = re.search(r'class=\"headline-subtitle\"[^>]*>(.*?)</p>', content, re.DOTALL)
            if kw_match:
                raw = re.sub(r'<[^>]+>', '', kw_match.group(1)).strip()
                # 截取前100个字符作为摘要
                keywords = raw[:100] + '...' if len(raw) > 100 else raw
    except Exception:
        pass

    # 计算星期
    try:
        d = datetime.strptime(date_str, '%Y-%m-%d')
        weekday = weekdays[d.weekday()]
    except Exception:
        weekday = ''

    entries.append({
        'date': date_str,
        'weekday': weekday,
        'keywords': keywords
    })

# 已按日期降序排列
entries.sort(key=lambda x: x['date'], reverse=True)

# 生成 ARCHIVE_DATA JS 代码
js_data = json.dumps(entries, ensure_ascii=False, indent=4)

# 替换 index.html 中的 ARCHIVE_DATA
with open(index_path, 'r', encoding='utf-8') as f:
    html = f.read()

pattern = r'(var ARCHIVE_DATA = )\[.*?\](;)'
replacement = r'\1' + js_data + r'\2'
new_html, count = re.subn(pattern, replacement, html, flags=re.DOTALL)

if count == 0:
    print('    警告: 未找到 ARCHIVE_DATA，index.html 未更新')
else:
    with open(index_path, 'w', encoding='utf-8') as f:
        f.write(new_html)
    print(f'    已更新 index.html ({len(entries)} 条存档记录)')
"

echo "==> [3/4] 提交变更..."
changed=$(git status --porcelain | wc -l)
if [ "$changed" -eq 0 ]; then
    echo "    没有变更，无需提交"
    exit 0
fi

msg="${1:-weekly update $(date +%Y-%m-%d)}"
git add -A
git commit -m "$msg"
echo "    提交: $msg"

echo "==> [4/4] 推送到远程..."
git push origin main
echo "    推送完成！"

echo ""
echo "✅ 部署成功！访问 https://unclecheng-li.github.io/AI-weekly/ 查看更新"
