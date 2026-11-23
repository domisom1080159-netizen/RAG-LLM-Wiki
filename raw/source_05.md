# 原始資料整理 05：Pinecone 文本切塊策略與向量檢索實務

## 一、基本中繼資料 (Metadata)
* **文件標題**：Chunking Strategies for LLM Applications
* **作者 / 機構**：James Briggs & Pinecone Team
* **官方發布單位**：Pinecone Systems, Inc. (Pinecone Learning Center)
* **官方網站連結**：[https://www.pinecone.io/learn/chunking-strategies/](https://www.pinecone.io/learn/chunking-strategies/)
* **發布/更新年份**：2023–2024 年
* **文獻性質**：全球知名向量資料庫（Vector Database）領導廠商針對 RAG 切塊與索引之深度工程實戰指南。

---

## 二、文獻核心背景與解決問題
* 「文本切塊（Chunking）」是決定 RAG 系統成敗最關鍵的第一步。
* 若切塊過大（Large Chunks），一個區塊內塞入過多雜訊主題，向量嵌入（Embedding）會被「稀釋」，導致檢索相似度不準確，且耗費 LLM 上下文視窗（Context Window）；
* 若切塊過小（Small Chunks），單一區塊失去前後語境（Missing Context），LLM 看到破碎文字無法推論出完整答案。

---

## 三、文獻詳解之主流切塊策略 (Chunking Strategies)

1. **固定字數切塊（Fixed-size Chunking）**：
   - 依固定字元數（Characters）或標記數（Tokens）切分（如 500 tokens）。
   - **重疊機制（Overlap）**：設定如 10%~20% 的 overlap（如 50 tokens）。在相鄰區塊間保留交疊，防止語意正好在分界處被截斷。
2. **段落/內容感知切塊（Content-Aware / Semantic Chunking）**：
   - 依據自然語言標點符號（換行 `\n\n`、句號、段落）、Markdown 標題（`#`, `##`）或 HTML 標籤結構切分。
   - 保證每個 Chunk 在概念上是完整的段落或章節。
3. **專用結構切塊（Structure-based Chunking）**：
   - 針對特殊文件格式，如程式碼（依據 Class / Function 切分）、Markdown 表格（避免將表格行拆散）、問答對（FAQ Pair 保留）。

---

## 四、工程權衡矩陣 (Trade-off Matrix)
Pinecone 提供了清晰的工程選擇指南：

| 評估維度 | 較小區塊 (e.g. 100~250 tokens) | 較大區塊 (e.g. 800~1500 tokens) |
|:---|:---|:---|
| **向量嵌入精準度** | 高（語意集中單一，向量特徵明顯） | 較低（多個概念混雜，語意被平均化） |
| **上下文完整度** | 低（可能遺失因果關係與前文） | 高（保留豐富背景資訊與細節） |
| **檢索精準度（Precision）** | 高（精準命中特定關鍵句子） | 較低（容易帶入不相干資訊） |
| **適用場景** | 精確問答、事實檢索（如特定數字、定義） | 摘要總結（Summarization）、多論點綜合分析 |

---

## 五、混合檢索（Hybrid Search）的必要性
Pinecone 同時指出：
* 單純依靠向量語意檢索（Dense Retrieval）容易在**專有名詞、型號代碼（如 STM32F401、規格編號）或縮寫**上失真，因為模型未見過或難以捕捉字面完全吻合的精確性。
* 最佳工程實務是結合傳統關鍵字搜尋（Sparse / BM25 檢索）與向量搜尋（Dense），兩者分數融合（Hybrid Search），兼顧語意理解與精準字詞比對。
