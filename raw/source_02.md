# 原始資料整理 02：LangChain 官方 RAG 教學文檔

## 一、基本中繼資料 (Metadata)
* **文件標題**：Build a Retrieval Augmented Generation (RAG) App: Overview & Tutorial
* **發布機構 / 作者**：LangChain, Inc.
* **官方網站連結**：[https://python.langchain.com/docs/tutorials/rag/](https://python.langchain.com/docs/tutorials/rag/)
* **發布/更新年份**：2023–2024 年
* **文獻性質**：現代生成式 AI 框架中應用最廣泛的 RAG 實作工程標準指南。

---

## 二、文獻核心背景與解決問題
* 現代企業應用需結合未公開在網際網路上的私有資料（如內部 Wiki、PDF 報告、Notion 頁面）。
* LangChain 將 RAG 系統抽象化為可插拔、模組化的處理管道（Pipeline），解決從原始檔案讀取到生成最終答案的繁瑣工程串接問題。

---

## 三、文獻規範之五大工程階段 (Core Stages)
LangChain 將現代 RAG 流程明確拆解為兩大生命週期、五個關鍵步驟：

### (A) 索引構建階段（Indexing Pipeline - 離線或批次處理）
1. **載入（Load）**：
   - 使用 `DocumentLoader` 讀取各類格式（PDF、HTML、Markdown、Word 等），將其轉換為統一的 LangChain `Document` 物件（包含 `page_content` 內文與 `metadata` 來源中繼資料）。
2. **切塊（Split / Chunking）**：
   - 使用文本切分器（如 `RecursiveCharacterTextSplitter`）將過長的文章切成固定大小且語意連貫的段落（Chunks）。
   - 設定合適的 `chunk_size`（如 500~1000 字元）與 `chunk_overlap`（如 50~100 字元），避免語意在斷句處被硬生生切斷。
3. **儲存（Store）**：
   - 透過 Embedding 模型將文字段落轉換為高維浮點數向量（如 1536 維）。
   - 存入向量資料庫（VectorStore，如 Chroma、FAISS、Qdrant），建立快速搜尋索引。

### (B) 檢索與生成階段（Retrieval & Generation - 即時在線處理）
4. **檢索（Retrieve）**：
   - 使用者發送自然語言查詢（Query）。
   - 檢索器（Retriever）將查詢同樣轉為向量，並向向量資料庫搜尋出語意關聯性最高的 Top-K 篇文本區塊。
5. **生成（Generate）**：
   - 將檢索出的文本區塊作為「上下文（Context）」，與使用者的原始問題組合成結構化提示詞（Prompt Template）。
   - 輸入大語言模型（LLM，如 GPT-4, Claude），指令 LLM 嚴格「僅根據提供的 Context」回答問題，產出具備根據的解答。

---

## 四、關鍵程式碼與實作概念架構 (LCEL)
在 LangChain 中，RAG 常透過 LangChain Expression Language (LCEL) 鏈結成管道：
```python
# 概念表達：Retrieval -> Prompt -> LLM -> OutputParser
rag_chain = (
    {"context": retriever | format_docs, "question": RunnablePassthrough()}
    | prompt
    | llm
    | StrOutputParser()
)
```
* **好處**：邏輯高度清晰，每個環節皆可獨立替換與除錯（例如抽換不同的 Retriever 或不同供應商的 LLM）。

---

## 五、對後續教學的啟示
* **標準切塊技巧**：強調節點重疊（Overlap）的重要性，並說明 Metadata 追蹤（如記錄第幾頁、章節名）對後續生成時標註來源的必要性。
* **Prompt 防護**：在 Prompt 中加上「若參考資料中未提及，請明確告知不知道，切勿捏造答案」，是防範幻覺的實務手段。
