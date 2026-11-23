# Wiki 處理與資料攝取紀錄 (Ingestion & Processing Log)

本文件即時記錄資料蒐集、攝取（Ingestion）、檢查與 Wiki 更新歷程。

| 序號 | 處理時間 | 來源檔案 / 標題 | 狀態 | 檢查重點與動作摘要 |
|:---|:---|:---|:---|:---|
| 00 | 2026-11-23 | 專案初始化 | 已完成 | 建立 `AGENTS.md` 規範與目錄結構。 |
| 01 | 2026-11-23 | `raw/source_01.md`: Lewis et al. (2020) NeurIPS 論文 | 已完成 | 查核原始論文架構：驗證 DPR 密集檢索、BART 生成器、參數化/非參數化記憶概念與降幻覺機制。 |
| 02 | 2026-11-23 | `raw/source_02.md`: LangChain 官方 RAG 教學文檔 | 已完成 | 萃取五大工程生命週期（Load, Split, Store, Retrieve, Generate）、LCEL 管道思維與 Chunk Overlap 概念。 |
| 03 | 2026-11-23 | `raw/source_03.md`: LlamaIndex 官方核心架構概念指南 | 已完成 | 萃取 Node 結構關係、Node Postprocessing / Reranking 重排序機制，以及 Naive RAG vs. Advanced RAG 演進概念。 |
| 04 | 2026-11-23 | `raw/source_04.md`: AWS 官方技術概覽 - 什麼是 RAG？ | 已完成 | 萃取企業落地三大痛點（幻覺、知識截斷、缺乏溯源）、RAG 商業核心效益與 RAG vs. Fine-tuning 深度權衡對比。 |
| 05 | 2026-11-23 | `raw/source_05.md`: Pinecone 文本切塊策略與向量檢索實務 | 已完成 | 萃取三大切塊策略（Fixed-size, Content-aware, Structure-based）、區塊大小 Trade-off 矩陣與 Hybrid Search 必要性。 |
| 06 | 2026-11-23 | `wiki/` 知識庫六大專題文件建置完成 | 已完成 | 完成 01_intro.md 至 06_tradeoffs.md，完整涵蓋核心與進階技術、Mermaid 圖解、術語標註及文獻溯源引用。 |
