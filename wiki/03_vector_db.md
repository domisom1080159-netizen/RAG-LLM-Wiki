# 03. 向量化與向量資料庫 (Vector Embeddings & Databases)

## 一、什麼是向量嵌入（Vector Embedding）？
在電腦中，文字本質上只是純字元字串（Strings）。傳統搜尋引擎主要比對字詞是否完全相同（Keyword Matching）；然而，在自然語言中，「汽車」與「轎車」字面完全不同，但語意卻高度相近。

**向量嵌入（Vector Embedding）** 是一種將離散的文字（詞彙、句子或段落）轉換為連續高維空間座標點（即一組浮點數數列，如 768 維或 1536 維向量）的技術 [^1][^2]。

### 直觀幾何概念：語意空間（Semantic Space）
* 嵌入模型（如 `text-embedding-3-small` 或開源的 BGE / E5）經過海量文本訓練，能夠學習出語意幾何空間。
* 在這個高維空間中，**「意義相近的概念，其幾何距離也會彼此接近」**：
  * 「蘋果」與「香蕉」的向量距離會很近（同屬於水果）。
  * 「蘋果」與「電晶體」的向量距離則會相當遙遠。

---

## 二、向量相似度幾何度量（Similarity Metrics）
在檢索時，我們需要數學工具來衡量使用者提問向量 $\vec{A}$ 與文件區塊向量 $\vec{B}$ 的相似程度。常見的三大計算方法包括：

### 1. 餘弦相似度（Cosine Similarity）
度量兩向量夾角 $\theta$ 的餘弦值：
$$\text{Cosine Similarity} = \frac{\vec{A} \cdot \vec{B}}{\|\vec{A}\| \|\vec{B}\|}$$
* 數值介於 $-1$ 到 $1$ 之間（在文本嵌入中通常介於 $0$ 到 $1$）。
* **特性**：只關注「方向」是否一致，不受到文字長度造成的向量長度影響，是 RAG 最通用的度量標準。

### 2. 點積（Dot Product / Inner Product）
$$\text{Dot Product} = \vec{A} \cdot \vec{B} = \sum_{i=1}^n A_i B_i$$
* **特性**：若在入庫前已將所有向量長度正規化（$\|\vec{A}\| = 1, \|\vec{B}\| = 1$），點積結果完全等同於餘弦相似度，且硬體（如 GPU、SIMD 指令集）計算速度極快。

### 3. 歐幾里得距離（Euclidean Distance / L2 Distance）
計算兩點在空間中的直線距離：
$$L2(\vec{A}, \vec{B}) = \sqrt{\sum_{i=1}^n (A_i - B_i)^2}$$
* **特性**：距離越小代表越相似。

---

## 三、為什麼傳統關聯式資料庫不適用？
傳統關聯式資料庫（如 MySQL、PostgreSQL）擅長處理純數值或字串的「精確匹配（Exact Match）」（例如 `WHERE age = 20` 或 `WHERE name LIKE '%陳%'`），並使用 B-Tree 索引。

但在 RAG 系統中，我們需要的是**「最近鄰搜尋（Nearest Neighbor Search）」**——給定一個 1536 維的查詢點，要在百萬個高維點中找出距離最近的前 $K$ 個點。若直接進行全資料庫暴力逐一比對（Brute-force Scan），計算複雜度為 $O(N \times D)$，在大規模資料下系統會完全卡死 [^5]。

---

## 四、向量資料庫（Vector Database）的誕生
**向量資料庫（Vector Database）** 專門針對高維向量設計，採用**近似最近鄰演算法（Approximate Nearest Neighbor, ANN）**，在極短的時間內（毫秒級）從海量向量中找出最接近的一組候選者。

### 核心索引演算法：HNSW（分層可導航小世界圖）
* **HNSW (Hierarchical Navigable Small World)** 是目前效能最頂尖的**近似最近鄰（ANN）**圖演算法之一。
* **運作原理**：其概念借鑑了跳躍表（Skip List）與小世界網路多層拓撲結構。最上層圖的邊長跨度大、節點稀疏，用於進行大範圍的快速全域導航定位；越往下層節點越密集、局部連結越精細，進行精準的局部鄰近貪婪搜尋（Greedy Search）。
* **複雜度特性與效能影響因素**：
  * **非絕對保證的對數複雜度**：在理想且資料分佈均勻的狀態下，HNSW 的經驗平均搜尋時間呈現對數規模（$\approx O(\log N)$），但這**並非嚴格的最壞情況數學保證**。
  * **維度詛咒（Curse of Dimensionality）**：當向量維度極高時，幾何距離的對比度會下降（所有點距離趨於相近），可能導致圖走訪陷入局部最優解或走訪更多節點。
  * **關鍵超參數權衡**：
    * $M$（每個節點的最大雙向連結數）：控制圖的密度與記憶體消耗，$M$ 越大建立時間與記憶體越高，但搜尋連通性較好。
    * $efConstruction$（建圖動態候選清單長度）：決定索引建立品質與耗時。
    * $efSearch$（查詢時動態候選清單長度）：直接主導「召回率（Recall）vs. 查詢延遲（Latency）」的權衡。$efSearch$ 調高可提升找到真實最近鄰的機率，但會線性增加距離計算次數與耗時。
  * **硬體與計算度量**：實際搜尋效能亦高度受底層硬體的 SIMD / AVX 向量指令集優化程度與距離計算（如 Cosine、L2）輸送量影響。

### 常見主流向量資料庫與工具對比
| 工具名稱 | 類型 | 適用規模與特性 | 代表使用場景 |
|:---|:---|:---|:---|
| **Chroma** | 輕量嵌入式 / 本機檔案 | 極易安裝、零設定、支援 Python 原生快速上手。 | 開發原型、自學實作、課堂專題展示 [^2]。 |
| **FAISS** | Meta 開源演算法函式庫 | 專注於底層極致效能的 ANN 函式庫，支援 GPU 加速。 | 演算法研究、大型本機單機檢索 [^1]。 |
| **Pinecone** | 全受管雲端原生（SaaS） | 無需管維運伺服器、支援自動水平擴展與混合檢索。 | 企業正式生產環境、大規模商用服務 [^5]。 |
| **Milvus / Qdrant** | 專用分散式開源資料庫 | 支援分散式集群部屬、多租戶隔離與精細元數據過濾。 | 大規模內部私有化部署、高併發企業架構。 |

---

## 參考文獻
[^1]: Lewis, P., et al. (2020). *Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks*. NeurIPS 2020. [arXiv:2005.11401](https://arxiv.org/abs/2005.11401)
[^2]: LangChain. (2024). *Build a Retrieval Augmented Generation (RAG) App*. [LangChain 官方文件](https://python.langchain.com/docs/tutorials/rag/)
[^5]: Pinecone. (2024). *Chunking Strategies for LLM Applications*. [Pinecone Learning Center](https://www.pinecone.io/learn/chunking-strategies/)
