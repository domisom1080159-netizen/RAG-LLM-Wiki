# Automated Verification Script for RAG Wiki & Deck Project
$ErrorActionPreference = "Stop"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host " 啟動專案自動化程式檢核 (verify.ps1)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$allPassed = $true

# 1. 檢驗專案核心文字與腳本檔案（共 16 項主要交付檔案）
$coreFiles = @(
    "AGENTS.md", "deck.html", "report.md", "tests/verify.ps1",
    "wiki/index.md", "wiki/log.md",
    "wiki/01_intro.md", "wiki/02_pipeline.md", "wiki/03_vector_db.md",
    "wiki/04_advanced.md", "wiki/05_evaluation.md", "wiki/06_tradeoffs.md",
    "raw/source_01.md", "raw/source_02.md", "raw/source_03.md",
    "raw/source_04.md", "raw/source_05.md"
)

Write-Host "`n[檢查項 1] 核心檔案存在性與長度檢核 (共 $($coreFiles.Count) 項)..."
foreach ($file in $coreFiles) {
    if (Test-Path $file) {
        $fileInfo = Get-Item $file
        if ($fileInfo.Length -gt 500) {
            Write-Host "  [PASS] $file ($($fileInfo.Length) bytes)" -ForegroundColor Green
        } else {
            Write-Host "  [WARN] $file 檔案過小 ($($fileInfo.Length) bytes)" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  [FAIL] 缺少必要檔案: $file" -ForegroundColor Red
        $allPassed = $false
    }
}

# 2. 檢驗 deck.html 結構與切換邏輯
Write-Host "`n[檢查項 2] deck.html 投影片結構與 JavaScript 函式檢核..."
$deckPath = "deck.html"
if (Test-Path $deckPath) {
    $deckContent = Get-Content -Raw -Encoding utf8 $deckPath
    
    # 檢查投影片數量
    $slideMatches = [regex]::Matches($deckContent, 'class="slide(?:\s|")')
    $slideCount = $slideMatches.Count
    if ($slideCount -ge 10 -and $slideCount -le 12) {
        Write-Host "  [PASS] 投影片數量符合規範: $slideCount 頁 (目標 10-12 頁)" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] 投影片數量異常: $slideCount 頁" -ForegroundColor Red
        $allPassed = $false
    }

    # 檢查關鍵導覽元件與函式
    $checks = @(
        @{ Name = "上一頁按鈕函式 (prevSlide)"; Pattern = "function prevSlide\(\)" },
        @{ Name = "下一頁按鈕函式 (nextSlide)"; Pattern = "function nextSlide\(\)" },
        @{ Name = "狀態更新函式 (updateSlide)"; Pattern = "function updateSlide\(index\)" },
        @{ Name = "進度條指示器 (progress-bar)"; Pattern = 'id="progress-bar"' },
        @{ Name = "頁碼計數器 (slide-indicator)"; Pattern = 'id="slide-indicator"' },
        @{ Name = "鍵盤向右鍵監聽 (ArrowRight)"; Pattern = "ArrowRight" },
        @{ Name = "鍵盤向左鍵監聽 (ArrowLeft)"; Pattern = "ArrowLeft" },
        @{ Name = "鍵盤空白鍵防滾動 (preventDefault)"; Pattern = "preventDefault" },
        @{ Name = "餘弦相似度精確值域 [-1, 1]"; Pattern = "\[-1,\s*1\]" }
    )

    foreach ($chk in $checks) {
        if ($deckContent -match $chk.Pattern) {
            Write-Host "  [PASS] $($chk.Name) 存在" -ForegroundColor Green
        } else {
            Write-Host "  [FAIL] 未找到: $($chk.Name)" -ForegroundColor Red
            $allPassed = $false
        }
    }
} else {
    Write-Host "  [FAIL] 找不到 deck.html" -ForegroundColor Red
    $allPassed = $false
}

# 3. 檢驗專有名詞繁中與英文雙標註及技術嚴謹性
Write-Host "`n[檢查項 3] Wiki 專有名詞第一次出現標註與關鍵修正檢核..."
$wiki1 = Get-Content -Raw -Encoding utf8 "wiki/01_intro.md"
$wiki2 = Get-Content -Raw -Encoding utf8 "wiki/02_pipeline.md"
$wiki3 = Get-Content -Raw -Encoding utf8 "wiki/03_vector_db.md"
$wiki4 = Get-Content -Raw -Encoding utf8 "wiki/04_advanced.md"
$wiki6 = Get-Content -Raw -Encoding utf8 "wiki/06_tradeoffs.md"

$term1 = $wiki1 -match "檢索增強生成（Retrieval-Augmented Generation"
$term2 = $wiki1 -match "大語言模型（Large Language Model"
$term3 = $wiki3 -match "向量嵌入（Vector Embedding"
$tech1 = $wiki1 -match "不保證答案 100% 正確"
$tech2 = $wiki2 -match "經驗起始參考值"
$tech3 = $wiki3 -match "近似最近鄰"
$tech4 = $wiki4 -match "額外推論延遲"
$tech5 = $wiki6 -match "快取層失效機制"

if ($term1 -and $term2 -and $term3) {
    Write-Host "  [PASS] 專有名詞符合「中文（English）」格式規範" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] 專有名詞格式未通過" -ForegroundColor Red
    $allPassed = $false
}

if ($tech1 -and $tech2 -and $tech3 -and $tech4 -and $tech5) {
    Write-Host "  [PASS] Wiki 技術修正點（HNSW 近似性、切塊參考值、非百分百保證、Rerank延遲、更新延遲）全數驗證存在" -ForegroundColor Green
} else {
    Write-Host "  [FAIL] Wiki 技術修正點未完整體現" -ForegroundColor Red
    $allPassed = $false
}

Write-Host "`n========================================" -ForegroundColor Cyan
if ($allPassed) {
    Write-Host " 測試結果: 全數通過 (Exit Code 0)" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Cyan
    exit 0
} else {
    Write-Host " 測試結果: 存在未通過項目 (Exit Code 1)" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Cyan
    exit 1
}
