# 序

因為區塊鏈 (blockchain) 涵蓋範圍非常的廣，這次主題會著重於智能合約 (smart contract) 開發的部分。偏理論的部份，坊間已有不少書可以閱讀，將不包含在這次分享的內容範圍。

**30 篇的文章會分成三大部分**

1. 介紹與智能合約相關的基本區塊鏈知識
1. 實際開發智能合約程式，並編寫部署到測試鏈上。
1. 補充案例說明

### 目錄

* 區塊鏈和以太坊基礎
  * [Day01: 序](https://ithelp.ithome.com.tw/articles/10200395)
  * [Day02: 交易](https://ithelp.ithome.com.tw/articles/10200528)
  * [Day03: 區塊](https://ithelp.ithome.com.tw/articles/10200654)
  * [Day04: 帳戶的基本概念](https://ithelp.ithome.com.tw/articles/10200900)
  * [Day05: 帳戶安全](https://ithelp.ithome.com.tw/articles/10200992)
  * [Day06: 網路](https://ithelp.ithome.com.tw/articles/10201207)
  * [Day07: 用戶端 Geth, Parity](https://ithelp.ithome.com.tw/articles/10201364)
  * [Day08: 什麼是 Gas？](https://ithelp.ithome.com.tw/articles/10201462)
* 開發工具準備
  * [Day09: 線上版 IDE 之 Remix 基礎篇](https://ithelp.ithome.com.tw/articles/10201750)
  * [Day10: 線上版 IDE 之 Remix 進階篇](https://ithelp.ithome.com.tw/articles/10202347)
* 程式語言和實戰練習
  * [Day11: 介紹 Solidity 語言](https://ithelp.ithome.com.tw/articles/10202884)
  * [Day12: 合約的結構](https://ithelp.ithome.com.tw/articles/10203280)
  * [Day13: Solidity 型別](https://ithelp.ithome.com.tw/articles/10203495)
  * [Day14: 表達示與流程控制](https://ithelp.ithome.com.tw/articles/10203645)
  * [Day15: 修飾標記 view、pure、fallback 及重載函式](https://ithelp.ithome.com.tw/articles/10204079)
  * [Day16: mapping 型別](https://ithelp.ithome.com.tw/articles/10204297)
  * [Day17: 可見度和自動生成 getter 函式](https://ithelp.ithome.com.tw/articles/10204818)
  * [Day18: 單位和全域變數](https://ithelp.ithome.com.tw/articles/10205053)
  * [Day19: 實戰練習「簡易版 King of the Ether」(1/2)](https://ithelp.ithome.com.tw/articles/10205298)
  * [Day20: 實戰練習「簡易版 King of the Ether」(2/2)](https://ithelp.ithome.com.tw/articles/10205760)
  * [Day21: 繼承、抽象合約](https://ithelp.ithome.com.tw/articles/10206052)
  * [Day22: 介面](https://ithelp.ithome.com.tw/articles/10206191)
  * [Day23: 實戰練習「Rinkeby Faucet」](https://ithelp.ithome.com.tw/articles/10206576)
  * [Day24: 函式庫](https://ithelp.ithome.com.tw/articles/10206994)
* Oraclize
  * [Day25: 介紹 Oraclize 與資料來源](https://ithelp.ithome.com.tw/articles/10207290)
  * [Day26: Oraclize request](https://ithelp.ithome.com.tw/articles/10207495)
  * [Day27: Oraclize 可靠證明](https://ithelp.ithome.com.tw/articles/10207705)
  * [Day28: Oraclize 的 computation 資料來源](https://ithelp.ithome.com.tw/articles/10207843)

### 一般傳統的合約？

在進入到主題之前，我們先瞭解一下什麼是合約？下面這張圖片是我在網路上找到的合約範例。

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/01_contract_templete.jpg)

讓我們來看看一般的傳統合約，需要具備哪些基本條件：

1. 甲、乙方資訊
2. 合約條款：大家須遵守的邏輯
3. 合約效期
4. 不可變動性：劃押後，雙方各執一份，不允許在變動。未來有其他需求，需重新定義一份新的合約。

除了基本條件之外，可能還有付款辦法、驗收條件等資訊。

| 付款項目    | 付款日期      | 付款金額（含稅） |
|---------|-----------|----------|
| 第一期：簽約金 | 107/01/01 | XXX      |
| 第二期：期中款 | 107/03/01 | XXX      |
| 第三期：尾款  | 107/05/01 | XXX      |

 從上面的資訊中，若要把整個流程變成自動化，需要做哪些事？

 * 我們需要一個平台，甲乙雙方都需要有帳號，帳號要具有可辨識性，並確保帳號的安全性，不容易被盜用，這樣大家才會認可這個合約的有效性。
 * 我們需要寫一些程式邏輯，來處理合約內容的商業邏輯。
 * 程式邏輯就如同，合約內容簽訂後，沒有人可以在任意再修改。
 * 有一些公司會用支票支付，所以我們也必須要有類似銀行的服務，確保支票可以兌現。

說到著，大家是不是開始覺得頭昏眼花了...

是的，如果在沒有基礎建設的情況下，要自己從頭實作自動化的合約，是非常困難的。

但好在，有了以太坊 (Ethereum) 的基礎建設，我們不需要從頭開始。

> 以太坊官網：<https://www.ethereum.org/>

### 什麼是智能合約？

<!-- 補充為什麼 -->

若用一句話來說，它就是可以在「區塊鏈上執行的程式」。

目前發布智能合約最大宗的平台是以太坊，但能開發智能合約的平台不是只有一個，像是後起之秀 `EOS` 也是可以開發智能合約。

> EOS 官網：<https://eos.io/>

### 智能合約和一般程式的差異

**1. 整合金流容易**

每個智能合約發布後都內建一個合約帳戶，程式透過以太坊內建機制，很容易可以做到收款、付款等操作。

**2. 寫入資料需要成本**

在智能合約裡需要儲存資料，需要透過礦工將資料寫入至區塊鏈上，區塊鏈的資料是以點對點的方式，儲存在世界各地以太坊的節點，所以成本非常的昂貴，所以就定義了 `gas` 機制，讓使用資源的人付費。

> gas 是程式執行的成本，付給礦工努力工作的報酬。會有一篇獨立的篇幅，做更詳細的解釋。

**3. 部署之後不能修改**

一般程式上線之後，還是可以持續進行多次改版，但智能合約部署之後，程式邏輯就會固定，屏除了人為操縱的因素，所以與智能合約整合開發出的應用程式，又稱為去中心化應用程式 (DApp)。

**4. 不需要有固定主機**

普遍認知，當我們需要發布程式時，我們會將程式執行在一台永不關機的主機。但智能合約運作原理，是透過以太坊網路上眾多的節點，幫我們執行程式，而不是只靠一台主機。

### 常見應用

* 發行 `ICO` (Initial Coin Offering)
* 博弈、卡牌、寵物遊戲
* 交易所

> ICO：數位貨幣首次公開募資

### 小結

今天我們稍微了解了什麼是智能合約，它跟我們熟悉的程式有什麼不同，接下將說明與智能合約開發相關，所一定要了解的區塊鏈基礎概念。
