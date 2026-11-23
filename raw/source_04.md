# 原始資料整理 04：AWS 官方技術概覽 - 什麼是 RAG？

## 一、基本中繼資料 (Metadata)
* **文件標題**：What is RAG (Retrieval-Augmented Generation)?
* **發布機構**：Amazon Web Services (AWS)
* **官方網站連結**：[https://aws.amazon.com/what-is/retrieval-augmented-generation/](https://aws.amazon.com/what-is/retrieval-augmented-generation/)
* **發布年份**：2023 年
* **文獻性質**：全球領先雲端服務商針對企業架構師與開發者發布之商業與系統架構技術手冊。

---

## 二、文獻核心背景與解決問題
* 探討企業若直接採用一般基底大語言模型（Foundation LLMs），在實務落地時面臨的三大致命痛點：
  1. **模型幻覺（Hallucination）**：模型在面對不知曉的資訊時，會自信地編造不實答案。
  2. **知識過時（Out-of-date Information）**：模型訓練資料只截斷在特定日期（Knowledge Cutoff），無法得知昨日或當下最新新聞與數據。
  3. **缺乏來源可驗證性（Lack of Source Attribution）**：模型無法證明其回答的法律、醫療或商務依據為何，難以建立使用者與監管機構的信任。

---

## 三、文獻提出的企業級核心效益 (Business & Technical Benefits)
AWS 在文獻中明確整理出 RAG 相比於重新訓練或微調（Fine-tuning）的顯著優勢：

1. **極具成本效益（Cost-Effective Implementation）**：
   - 預訓練或微調大型模型的算力成本動輒數萬至數百萬美元，且耗時甚鉅。
   - RAG 僅需維護輕量級向量資料庫，運算開銷大幅降低數個數量級。
2. **資訊即時更新（Up-to-date Information）**：
   - 企業只需在資料庫中新增或刪除文件，檢索器立即能獲取最新知識，無需重新訓練任何模型權重。
3. **增進使用者信任與可解釋性（Enhanced User Trust）**：
   - RAG 系統能附帶具體引述（Citations）與原始網址/頁數，使用者可隨時點擊驗證事實。
4. **精細權限控制與隱私安全（Access Control & Governance）**：
   - 在檢索層（Retrieval Layer）即可根據使用者角色（RBAC）過濾敏感資料（例如：人資薪資、主管機密報告），確保 LLM 不會看到越權資訊。

---

## 四、RAG vs. Fine-tuning 權衡分析
AWS 特別對比了 RAG 與模型微調（Fine-tuning）的技術定位：
* **Fine-tuning（微調）**：
  * *目的*：改變模型的「行為模式、語氣風格、特定格式或特定語言習慣」（例如教模型講醫療術語風格，或是輸出特定的 JSON 語法）。
  * *缺點*：不適合用來學習頻繁變動的事實性新知識，依然可能產生幻覺。
* **RAG（檢索增強生成）**：
  * *目的*：提供動態事實依據、外部私有文件查詢。
  * *結論*：在實務上，「RAG + 微調」常結合使用，但若僅需要為模型補充外部知識庫，RAG 永遠是第一優先選擇。

---

## 五、對後續教學的啟示
* **電機與工程思維**：將 RAG 視為「輸入訊號的預先濾波與增益調整」，微調則是「修改硬體電路/內部參數」。
* **強調信任機制**：對初學者說明為什麼企業不敢直接問 ChatGPT 公司機密，而必須建立內部 RAG 架構。
