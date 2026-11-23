# AGENTS.md - 「RAG 入門與應用」專案作業規範

本專案旨在為零基礎大學生（尤其是電機/資訊相關背景）建立「RAG（檢索增強生成）」知識庫 Wiki，並最終產出教學型 HTML 簡報與品質驗證報告。

---

## 1. 核心工作原則（Guiding Principles）
1. **真實資料優先**：所有技術論述必須基於真實、權威的文獻（論文、官方文檔、知名雲端或向量資料庫廠商白皮書），嚴禁虛構來源或不實數據。
2. **循序漸進攝取（Sequential Ingestion）**：資料必須逐篇處理，先入 `raw/` 建立詳細筆記與引用，再萃取融入 `wiki/`，並記錄於 `wiki/log.md`。
3. **繁體中文與專有名詞規範**：
   - 全文使用繁體中文（台灣習慣用語，如：程式碼、演算法、資料庫、伺服器）。
   - 專有名詞第一次出現必須標註：`中文（English）`，例如：`檢索增強生成（Retrieval-Augmented Generation, RAG）`、`向量嵌入（Vector Embedding）`。
   - 後續重複出現時，可使用標準中文簡稱或常用英文簡稱（如 RAG、Embedding）。
4. **工程權衡視角（Engineering Trade-offs）**：面對不同架構或參數分歧時（例如 Chunk Size 大小、Dense vs. Sparse 檢索），以客觀比較表列出優缺點及適用情境，不武斷定論。
5. **可追溯性（Traceability）**：Wiki 與投影片內容皆需包含 Markdown 引用標記或來源對照，確保任一重點可反查至 `raw/`。

---

## 2. 目錄與檔案結構規範
```text
11111111/
├── AGENTS.md            # 專案規範與工作流程指南（本檔案）
├── deck.html            # 10–12 頁現代科技感教學 HTML 簡報
├── report.md            # 專案實作歷程、真實 QA 檢驗結果與反思
├── raw/                 # 原始資料整理庫（至少 5 篇權威文獻，含 URL、作者、摘要）
│   ├── source_01.md
│   ├── source_02.md
│   ├── source_03.md
│   ├── source_04.md
│   └── source_05.md
└── wiki/                # 結構化知識庫
    ├── index.md         # 知識導覽地圖
    ├── log.md           # 處理紀錄日誌
    ├── 01_intro.md      # RAG 定義與解決痛點
    ├── 02_pipeline.md   # RAG 核心生命週期與三階段
    ├── 03_vector_db.md  # 向量化與向量資料庫
    ├── 04_advanced.md   # 進階檢索技術（Hybrid Search, Reranking, GraphRAG）
    ├── 05_evaluation.md # 評估指標與方法
    └── 06_tradeoffs.md  # 優缺點、工程權衡與應用場景
```

---

## 3. 簡報製作守則（deck.html）
- **頁數**：10 至 12 頁。
- **風格**：現代科技深色風格（深灰底、霓虹紫/天藍強調色），視覺層次分明。
- **互動**：支援底部上一頁/下一頁按鈕與鍵盤方向鍵（← / → / 空白鍵）切換。
- **單檔獨立**：HTML 內嵌 CSS 與原生 JavaScript，不依賴外部脆弱網路 CDN，保證離線可開啟。

---

## 4. 品質檢查標準（QA Checklist）
在完成 Wiki 與簡報後，必須執行以下驗收並記錄於 `report.md`：
- [ ] 是否完整 Ingest 至少 5 篇真實文獻（附完整資訊與來源連結）。
- [ ] Wiki 的每個論點是否皆有來源支撐與引用。
- [ ] 專有名詞第一次出現是否符合「中文（English）」格式。
- [ ] 簡報所有內容是否能在 Wiki 中找到對應知識點。
- [ ] HTML 簡報在瀏覽器中能否正常載入、切換無報錯。
- [ ] 簡報排版有無破版、字體溢出或圖表不清之情況。
