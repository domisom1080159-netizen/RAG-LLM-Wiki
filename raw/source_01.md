# 原始資料整理 01：RAG 奠基論文 (Lewis et al., 2020)

## 一、基本中繼資料 (Metadata)
* **論文標題**：Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks
* **作者群**：Patrick Lewis, Ethan Perez, Aleksandra Piktus, Fabio Petroni, Vladimir Karpukhin, Naman Goyal, Heinrich Küttler, Mike Lewis, Wen-tau Yih, Tim Rocktäschel, Sebastian Riedel, Douwe Kiela
* **所屬機構**：Facebook AI Research (FAIR), University College London, New York University
* **發表年份**：2020 年（NeurIPS 2020）
* **論文連結 / 原始網址**：[https://arxiv.org/abs/2005.11401](https://arxiv.org/abs/2005.11401)
* **文獻性質**：學術界首次正式提出「RAG（Retrieval-Augmented Generation）」架構之經典奠基論文。

---

## 二、文獻核心背景與解決問題
1. **參數化記憶（Parametric Memory）的局限**：
   - 傳統預訓練語言模型（如 BERT、BART、T5）將世界知識隱含存儲在模型權重（Weights）中。
   - 缺點是難以精確擴展、無法隨時動態更新外部知識，且模型容易產生無中生有的「幻覺（Hallucination）」。
2. **非參數化記憶（Non-parametric Memory）的引入**：
   - 結合外部向量檢索系統（如維基百科全文的密集向量索引），作為模型的動態外掛知識庫。
   - 既具備生成模型（Seq2Seq）的語言表達靈活性，又具備檢索器的知識可驗證性與精準度。

---

## 三、論文提出的核心架構與技術要點
1. **DPR（Dense Passage Retrieval）檢索器**：
   - 使用雙塔架構（Bi-encoder）計算問題（Query）與文本段落（Document/Passage）的稠密向量內積（Dot Product），找出語意最相近的 Top-K 篇參考段落。
2. **Seq2Seq 生成器（以 BART 為例）**：
   - 將使用者的輸入題目與檢索出來的 Top-K 篇文本共同送入解碼器，以條件機率方式生成最終答案。
3. **兩大生成機制對比**：
   - **RAG-Sequence**：整句回答都基於同一篇檢索到的參考文本進行條件生成。
   - **RAG-Token**：回答中的每一個詞（Token）都可以動態依據不同篇檢索文本的機率分佈進行加權生成（表現更靈活）。

---

## 四、關鍵實驗結果與結論
1. **開放領域問答（Open-Domain QA）**：在 Natural Questions、WebQuestions 及 CuratedTREC 等基準測試中，表現顯著超越當時純參數化模型（如 T5）與其他混合架構。
2. **事實查核（Fact Verification）**：在 FEVER 資料集上展現出優異的事實準確度。
3. **降低幻覺**：外部檢索機制提供了具體來源，使得產生的文字更具事實根據（Factual Grounding），且能夠藉由抽換或擴充後端向量資料庫，直接更新模型知識，無需耗費昂貴成本重新訓練或微調模型權重。

---

## 五、對後續 RAG 發展的啟示（教學精華）
* **比喻**：就像把「閉卷死記硬背考試」轉變為「開卷查資料考試」。
* **解耦（Decoupling）**：將「語言推理能力（參數化）」與「世界事實知識（非參數化資料庫）」分離，大幅降低大模型維護與更新成本。
