# 財務報告網站集成指南

## 系統概述

此系統自動管理財務報告 PDF 在網站上的發佈，支持中英文版本、歷史記錄和每日更新。

## 文件夾結構

```
website/
└── assets/
    └── reports/
        ├── 2026-05-19/
        │   ├── financial_report_zh.pdf   (中文版)
        │   └── financial_report_en.pdf   (英文版)
        ├── 2026-05-20/
        │   ├── financial_report_zh.pdf
        │   └── financial_report_en.pdf
        └── archive/                      (過期報告存檔)
```

## 更新流程

### 1️⃣ 生成報告（在 daliy_report 文件夾中）

```bash
cd daliy_report/py

# 每日運行報告生成
./run_report.sh

# 編輯LaTeX文件
nano reports/2026-05-19/editable/financial_report_en.tex
nano reports/2026-05-19/editable/financial_report_zh.tex

# 生成PDF（使用您現有的腳本）
# 例如：python generate_pdf_latex.py 或 python generate_pdf_reportlab.py
```

### 2️⃣ 同步報告到網站

```bash
# 同步今天的報告
python3 sync_reports_to_website.py

# 同步指定日期的報告
python3 sync_reports_to_website.py 2026-05-19

# 列出所有可用的報告
python3 sync_reports_to_website.py --list
```

### 3️⃣ 重建網站（在 website 文件夾中）

```bash
cd website

# 使用 Quarto 重建
quarto render

# 或使用 build.sh
./build.sh
```

## 網站展示

### 中文版本
- **URL**: `daily-reports.html`
- **顯示**: 最新的 `financial_report_zh.pdf`
- **下載**: 過往所有報告的下載表格

### 英文版本
- **URL**: `en/daily-reports.html`
- **顯示**: 最新的 `financial_report_en.pdf`
- **下載**: 過往所有報告的下載表格

## 自動化建議

### Option 1: 使用 cron 定時任務（macOS/Linux）

```bash
# 編輯 crontab
crontab -e

# 添加每日 14:30 UTC 自動同步（根據您的需求調整時間）
30 14 * * * cd /Users/mista/coding/daliy_report/py && python3 sync_reports_to_website.py && cd /Users/mista/coding/website && quarto render
```

### Option 2: 使用 GitHub Actions（如果使用 Git）

在 `.github/workflows/daily-report.yml` 創建工作流：

```yaml
name: Daily Report Sync

on:
  schedule:
    - cron: '30 14 * * *'  # 每日 14:30 UTC
  workflow_dispatch:       # 手動觸發

jobs:
  sync:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      - name: Sync reports
        run: |
          cd daliy_report/py
          python3 sync_reports_to_website.py
      - name: Build website
        run: |
          cd website
          pip install quarto
          quarto render
```

## 故障排除

### 問題：找不到 PDF 文件

**解決方案：**
- 確保 PDF 已生成在 `daliy_report/py/reports/[DATE]/editable/` 目錄
- 檢查文件名是否正確：`financial_report_en.pdf` 和 `financial_report_zh.pdf`

### 問題：符號鏈接失敗

**解決方案：**
- 腳本會自動降級為複製文件模式
- 檢查目錄權限是否正確

### 問題：網站未顯示新報告

**解決方案：**
1. 確認同步腳本已成功運行
2. 運行 `quarto render` 重建網站
3. 清除瀏覽器緩存（Ctrl+F5 或 Cmd+Shift+R）

## 高級設置

### 自訂報告保留期限

編輯 `sync_reports_to_website.py` 中的 `archive_old_reports()` 函數：

```python
# 保留最近 60 天的報告，較早的歸檔
RETENTION_DAYS = 60
```

### 添加自動生成腳本

在 `daliy_report/py/` 中創建 `auto_daily_report.sh`：

```bash
#!/bin/bash
# 自動生成和發佈每日報告

set -e  # 任何錯誤則退出

echo "🔄 正在生成報告..."
python3 financial_report.py

echo "📤 同步到網站..."
python3 sync_reports_to_website.py

echo "🌐 重建網站..."
cd ../website
quarto render
cd ../py

echo "✅ 完成！"
```

## 常用命令速查

```bash
# 檢查最新報告狀態
ls -la website/assets/reports/ | head -20

# 查看同步日誌
python3 sync_reports_to_website.py 2>&1 | tee sync.log

# 查看網站本地預覽
cd website
quarto preview

# 打包舊報告到存檔
tar -czf website/assets/reports/archive/reports_2026-04.tar.gz website/assets/reports/2026-04-*/
```

## 支援的文件格式

- **PDF**: financial_report_en.pdf, financial_report_zh.pdf
- **CSV**: 歷史數據文件（自動包含）
- **TEX**: LaTeX 源文件（可選）

## 限制與注意事項

1. **文件大小**: 單個 PDF 建議 < 50MB
2. **更新頻率**: 建議每天最多更新一次
3. **備份**: 定期備份 `website/assets/reports/` 目錄
4. **版本控制**: 考慮將舊報告提交到 Git LFS（Large File Storage）

## 支援與反饋

如有任何問題或建議，請檢查：
1. 文件夾權限
2. PDF 生成過程是否完成
3. Python 依賴是否已安裝
