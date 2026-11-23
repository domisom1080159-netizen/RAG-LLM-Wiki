# RAG 入門與應用知識庫 (Knowledge Index)

歡迎閱讀「RAG 入門與應用」LLM Wiki。本知識庫專為初學者設計，由淺入深解析檢索增強生成（Retrieval-Augmented Generation, RAG）的原理、架構與實務應用。

---

## 📚 知識庫導覽地圖

1. [01. 什麼是 RAG 與為什麼需要它？](01_intro.md)
   - 大語言模型（LLM）的先天挑戰：知識截斷（Knowledge Cutoff）與模型幻覺（Hallucination）
   - RAG 的核心定義：「開卷考試」比喻
   - RAG vs. 微調（Fine-tuning）核心思維差異
2. [02. RAG 核心生命週期與 Pipeline 架構](02_pipeline.md)
   - 階段一：索引階段（Indexing）與文件切塊（Chunking）
   - 階段二：檢索階段（Retrieval）與相似度計算
   - 階段三：生成階段（Generation）與提示詞工程（Prompt Engineering）
3. [03. 向量化與向量資料庫](03_vector_db.md)
   - 什麼是向量嵌入（Vector Embedding）？
   - 語意空間（Semantic Space）與距離度量（Cosine Similarity, Dot Product）
   - 向量資料庫（Vector Database）的角色與代表工具（Chroma, FAISS, Milvus）
4. [04. 進階檢索技術與架構延伸](04_advanced.md)
   - 混合檢索（Hybrid Search）：Dense 語意檢索 + Sparse 關鍵字檢索（BM25）
   - 重排序（Reranking）：提升 Top-K 檢索精準度
   - 知識圖譜 RAG（GraphRAG）：結構化關係理解
5. [05. RAG 系統評估與品質指標](05_evaluation.md)
   - 評估框架：RAG 三元組（RAG Triad - Context Relevance, Groundedness, Answer Relevance）
   - 評估工具簡介（Ragas, TruLens）
6. [06. 工程權衡、優缺點與常見應用場景](06_tradeoffs.md)
   - 核心優缺點盤點
   - 工程決策權衡矩陣（Trade-off Matrix）
   - 典型產業落地範例（客服問答、企業私有知識庫、法規合約檢索）

---

## 🔗 原始文獻索引（Raw Sources）
- [Source 01: Lewis et al. (NeurIPS 2020) - 原始 RAG 奠基論文](../raw/source_01.md)
- [Source 02: LangChain 官方教學 - Build a RAG App](../raw/source_02.md)
- [Source 03: LlamaIndex 官方指南 - High-Level RAG Concepts](../raw/source_03.md)
- [Source 04: AWS 官方技術白皮書 - 什麼是 RAG？](../raw/source_04.md)
- [Source 05: Pinecone Learning Center - RAG 與 Chunking 策略](../raw/source_05.md)
