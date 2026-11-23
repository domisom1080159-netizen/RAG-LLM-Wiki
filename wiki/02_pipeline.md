# 02. RAG 核心生命週期與處理管道 (Pipeline)

## 一、生命週期總覽 (Lifecycle Overview)
一個標準的 RAG 系統並非單一程式，而是一套嚴謹的工程管道（Pipeline）。根據主流框架（如 LangChain 與 LlamaIndex）的定義，完整的 RAG 生命週期可分為兩大階段與三大核心步驟 [^2][^3]：

1. **離線/準備階段：資料索引（Indexing Pipeline）**
2. **在線/執行階段：檢索（Retrieval）與生成（Generation）**

```mermaid
flowchart TD
    subgraph 階段一：索引處理 [離線準備階段 Indexing]
        A[原始資料 PDF / Wiki / Code] --> B[載入器 Document Loader]
        B --> C[文本切塊 Chunking]
        C --> D[向量嵌入模型 Embedding Model]
        D --> E[(向量資料庫 Vector Database)]
    end

    subgraph 階段二：檢索與生成 [在線執行階段 Query-Time]
        F[使用者查詢 User Query] --> G[查詢向量化 Query Embedding]
        G --> H[相似度搜尋 Similarity Search]
        E -.-> H
        H -->|取出 Top-K 相關區塊| I[上下文拼接 Context Injection]
        F --> I
        I --> J[結構化提示詞 Prompt Template]
        J --> K[大語言模型 LLM]
        K --> L[最終精確回答 Final Answer]
    end
```

---

## 二、步驟拆解一：資料索引階段（Indexing）

### 1. 文件載入（Document Loading）
透過文件載入器（Document Loader），將異質來源（如 PDF 規格書、Markdown 筆記、HTML 網頁、Word 檔案）解析為具備統一結構的物件，並保留重要元數據（Metadata，例如：頁碼、檔名、發布日期）[^2]。

### 2. 文本切塊（Text Chunking）
由於嵌入模型（Embedding Model）與語言模型皆有長度限制，且單篇長篇大論若直接轉為向量會導致語意稀釋，因此必須切塊。
* **區塊大小（Chunk Size）的經驗起始參考值**：初學者工程實踐常以 500～1000 個字元（或 Token）作為**啟發式起始基準（Baseline Rule-of-Thumb）**，而非不可變動的固定標準 [^5]。
* **重疊長度（Chunk Overlap）的經驗起始參考值**：通常建議從 Chunk Size 的 10%～20%（例如 50～100 個字元）開始嘗試。
  * *為什麼需要 Overlap？*：在句子跨越切塊邊界時，保留重疊能確保相鄰區塊之間的語意脈絡不被硬生生截斷。
* **參數調整的考量因素**：最佳數值強烈取決於具體情境——例如文件排版型態（精簡 API 規格表 vs. 冗長法律合約）、Embedding 模型的有效注意力視窗、下游語言模型（LLM）的上下文窗口，以及任務目標是「單點事實查詢（適合較小 Chunk）」還是「跨段落總結（適合較大 Chunk）」。

### 3. 向量嵌入與入庫（Embedding & Storing）
將切塊後的純文字段落輸入嵌入模型，轉換為數學上的高維向量數值陣列（如 1536 維的浮點數），並存入向量資料庫建立索引結構 [^2]。

---

## 三、步驟拆解二：檢索階段（Retrieval）

當使用者發起提問時，系統進入即時檢索流程：
1. **查詢向量化（Query Embedding）**：使用**同一個**嵌入模型，將使用者的提問文字轉為相同維度的向量 [^1]。
2. **向量相似度度量（Similarity Measurement）**：在向量空間中計算查詢向量與資料庫中所有文字區塊的幾何距離。常用計算方式包含：
   - **餘弦相似度（Cosine Similarity）**：衡量夾角方向，不受文字長度絕對值影響。
   - **點積（Dot Product）**：若向量已正規化（Normalized），計算速度極快。
3. **取出 Top-K 候選文本**：擷取關聯度最高的前 $K$ 篇文本區塊（例如 $K=3 \sim 5$）作為參考依據 [^2][^3]。

---

## 四、步驟拆解三：生成階段（Generation）

生成階段的精髓在於**提示詞工程（Prompt Engineering）**。系統將檢索出的多個文本片段包裝為「上下文（Context）」，與使用者的問題共同注入預設的提示模板中：

### 典型 RAG 提示詞模板範例
```text
你是一個專業的技術教學助手。請嚴格根據以下提供的【參考資料】來回答【使用者問題】。
若參考資料中未包含足夠資訊，請直接回答「抱歉，現有參考資料不足以回答此問題」，切勿自行捏造事實。

【參考資料】：
{retrieved_context_chunks}

【使用者問題】：
{user_query}

請以繁體中文給出結構分明的解答，並於段落末標註引用的段落編號。
```

最後將此結構化 Prompt 送入大語言模型（如 GPT-4, Llama 3），生成條理清晰、具備事實依據的回答 [^2][^4]。

---

## 參考文獻
[^1]: Lewis, P., et al. (2020). *Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks*. NeurIPS 2020. [arXiv:2005.11401](https://arxiv.org/abs/2005.11401)
[^2]: LangChain. (2024). *Build a Retrieval Augmented Generation (RAG) App*. [LangChain 官方文件](https://python.langchain.com/docs/tutorials/rag/)
[^3]: LlamaIndex. (2024). *High-Level Concepts: Building a RAG Pipeline*. [LlamaIndex 官方文件](https://docs.llamaindex.ai/en/stable/getting_started/concepts/)
[^4]: Amazon Web Services (AWS). (2023). *What is RAG?*. [AWS 官方指南](https://aws.amazon.com/what-is/retrieval-augmented-generation/)
[^5]: Pinecone. (2024). *Chunking Strategies for LLM Applications*. [Pinecone Learning Center](https://www.pinecone.io/learn/chunking-strategies/)
