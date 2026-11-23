# 原始資料整理 03：LlamaIndex 官方核心架構概念指南

## 一、基本中繼資料 (Metadata)
* **文件標題**：High-Level Concepts: Building a RAG Pipeline
* **發布機構 / 負責人**：LlamaIndex (Jerry Liu & LlamaIndex Team)
* **官方網站連結**：[https://docs.llamaindex.ai/en/stable/getting_started/concepts/](https://docs.llamaindex.ai/en/stable/getting_started/concepts/)
* **發布/更新年份**：2023–2024 年
* **文獻性質**：專注於「資料索引與精準檢索增強」之高階 LLM 框架官方文檔。

---

## 二、文獻核心背景與解決問題
* LlamaIndex 專為以「資料為中心（Data-centric）」的 LLM 應用而設計。
* 解決傳統 RAG 僅做單純切塊（Naive Chunking）導致語意碎片化、檢索雜訊過多，以及生成答案缺乏上下文脈絡的問題。

---

## 三、文獻提出的五大抽象階段與核心元件
LlamaIndex 將 RAG 架構劃分為五個重要階段：

1. **載入階段（Loading）**：
   - 透過 `Readers` / `Data Connectors` 擷取不同來源的原始文本，封裝為 `Document`。
2. **切塊與節點化（Indexing / Node Parsing）**：
   - 不僅是文字切塊，而是解析成具備結構關聯的 **Node（節點）** 物件。
   - 每個 Node 包含父子關係（Parent-Child）、相鄰關係（Prev-Next Node）與自訂元數據（Metadata），保留完整的上下文視野。
3. **儲存階段（Storing）**：
   - `IndexStore`（儲存索引結構）、`DocStore`（儲存原始文本節點）與 `VectorStore`（儲存向量數值）協同運作。
4. **查詢與檢索階段（Querying - Retrieval & Post-processing）**：
   - **Retriever**：根據查詢檢索最相關的節點。
   - **Node Postprocessor / Reranker**：這是在基礎 RAG 上的重大優化步驟！檢索出來的候選 Node 不直接丟給 LLM，而是先經過過濾器（Filter）或重排序模型（如 Cohere Rerank、Cross-Encoder），依相關度重新排序，剃除雜訊，確保前幾名具備最高關聯性。
5. **回應合成階段（Response Synthesis）**：
   - **Synthesizer**：將處理後的節點與使用者的 Query 送交 LLM，支援多種合成策略（例如：`create_and_refine` 逐條精煉、`tree_summarize` 階層式歸納、或 `compact` 濃縮合併）。

---

## 四、進階技術視角：Advanced RAG vs. Naive RAG
LlamaIndex 文獻中清楚界定了基礎 RAG（Naive RAG）與進階 RAG（Advanced RAG）的界線：
* **Naive RAG**：固定長度切塊 → 轉向量存入 DB → 餘弦相似度取 Top-K → 丟給 LLM。
  * *問題*：容易檢索到字面上相似但語意無關的內容（低準確率），或上下文斷裂（低召回率）。
* **Advanced RAG**：
  * **Pre-retrieval 優化**：自適應切塊（Sentence Window Retrieval, Parent-Child Chunking）、Query 擴展或改寫。
  * **Post-retrieval 優化**：重排序（Reranking）、上下文壓縮（Context Compression）。

---

## 五、對後續教學的啟示
* **節點（Node）思維**：讓學生理解文字切塊不是單純切香腸，而是要保留節點間的上下文指針（Metadata pointers）。
* **Reranking 角色**：用生活例子說明：Retriever 就像快速篩選出前 50 名面試者，而 Reranker 是資深主管進行深度面試，只挑出最好的前 3 名給老闆（LLM）決策。
