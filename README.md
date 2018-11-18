# 連續 30 天挑戰：Smart Contract 開發之使用 Solidity

**目錄**

* 區塊鏈和以太坊基礎
  * [Day01: 序](https://ithelp.ithome.com.tw/articles/10200395)
  * [Day02: 交易](https://ithelp.ithome.com.tw/articles/10200528)
  * [Day03: 區塊](https://ithelp.ithome.com.tw/articles/10200654)
  * [Day04: 帳戶的基本概念](https://ithelp.ithome.com.tw/articles/10200900)
  * [Day05: MetaMask 加密貨幣錢包](https://ithelp.ithome.com.tw/articles/10200992)
  * [Day06: 什麼是 Gas？](https://ithelp.ithome.com.tw/articles/10201207)
  * [Day07: 網路](https://ithelp.ithome.com.tw/articles/10201364)
  * [Day08: 用戶端 Geth, Parity](https://ithelp.ithome.com.tw/articles/10201462)
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
  * [Day25: 介紹 Oraclize 與資料來源](https://ithelp.ithome.com.tw/articles/10207290)
  * [Day26: Oraclize request](https://ithelp.ithome.com.tw/articles/10207495)
  * [Day27: Oraclize 可靠證明](https://ithelp.ithome.com.tw/articles/10207705)
  * [Day28: Oraclize 的 computation 資料來源](https://ithelp.ithome.com.tw/articles/10207843)
  * [Day29: 補充篇](https://ithelp.ithome.com.tw/articles/10208254)
  * [Day30: 總結](https://ithelp.ithome.com.tw/articles/10208317)

# Discussion

## 02_block.md
### Question
1. block值是存在哪? 備份資料的節點是指? 如何否認資料真實性?
1. 每一次需要寫入資料，就得用掉一個block是不可行的原因是? 每個節點都要多儲存一份block? 因為每多一個block就要多計算一個新的hash成本很高?因為Hash會用完?
1. Mine是指根據"Data"而算出的hash對吧? 不同區塊練有不同的hash code產生規則?
### Suggestion
1. "所以我們還有另一個東西叫 Transaction" (語意沒有完成)。通常這句話後面會接著引入這個新名詞的目的，例如 "所以我們還有另一個東西叫Transaction, 可以用來達到....的需求, 又可以避免...的缺點"

## 03_tx.md
### Question
1. 一個block有沒有限制存多少Trasaction? 還是看資料量?還是一個block有固定可以存的資料量, 存到資料量大的transaction,就只會存比較少筆。事由誰決定/控制要使用transaction來放入資料, 還是產生新的block
1. `產生一筆Transaction，等一段時間後，才由礦工批次處理` 處理的意思是產生這個block的新hash嗎? 如果我理解的正確, 這段語意可以寫完整一點, 例如`所以,每當我們寫入一筆資料,就產生一筆Transaction。礦工並不會每有一筆新的transaction就重新為這個block計算hash,而是一段時間計算一次,所以每一次計算涵蓋了多筆transaction的更動。`
1. 發布Smarkt Contract 程式是什麼意思?要把上面運作的程式邏輯修改嗎?例如改轉帳費Gas fee?
1. '呼叫 Smart Contract 的 function，所產生的 Transaction'是什麼意思? 如果他的作用在後面章節會提到,這邊可以稍稍說明一下,接下來會提到。
1. 如何取得 tx-hash 
### Suggestion
1. 我發現我02的問題在03一開始有描述。在 blockchain 的世界，需要存任何資料都要寫在鏈上，但產生一個 block 的成本是很高的，除了計算出符合條件的 hash 外，每個節點都需要備份同樣的資料。' 這一段應該算是block的特性,應該要在02介紹, 在導入因為成本高所以衍生出"Transaction"這樣的應用方式。 03一開始也還是可以保留目前的背景介紹。
1. 突然提到礦工(本系列第一次提到礦工) 可以稍稍用註解描述什麼是礦工
1. 熊熊提到 Etherscan
1. 通常拿來當標題的下法會是一個完整語意的句子'常見 Transaction 有三種' 通常會是一個小段落的開頭, 而且後面就要接內容, 要當作小標題通常是用`常見的Transaction應用/介紹` or `三種常見的Transaction`
1. `1. 一般轉帳的 Transaction` 以下是用乙太幣轉帳的範例,可以註明一下這是一個以太幣範例
1. `讀完此篇後，你將具有基本的 Transaction 概念`, 這種寫法是放在文章開頭,還沒讀之前。小結是表示讀完了,一般會用, "相信你現在已經具有基本的Transaction概念,..." 
1. 因為下一章是介紹"帳戶", 在小結可以提一下, 為什麼接下來要介紹"帳戶". Ex 最常普遍/熱門的區塊練技術應用?

##  05_account_secret.md
### Question
1. 不太懂第五章為什麼要做帳戶安全介紹，跟上一篇的關聯是?
1. 這一篇之後的帳戶安全作法是區塊練都這麼使用還是, 以太坊專用?
1. `而位址 (Address) 是由公鑰所決定的` 位址的作用是? 我看到後面才發現後面有地址的解釋,我覺得私鑰、公鑰、地址這些應該放在一開始的地方。或是在前面一點用備註的方式。
1. `發起交易時` 是指02_tx.md裡所指的產生transation? 
1. `礦工用公鑰檢查簽名，確認這筆交易的真假，在再把資料寫入區塊中` 這段是指算出block hash嗎?
1. MetaMask是?
1. 激活是指active對吧? 總覺得有點像是大陸翻法, 還是台灣也是這樣翻?
1. 硬體錢包、紙錢包是什麼?
1. `帳戶在 Dapp 跟智能合約溝通的時候，`我還是不太懂這幾個東西的關聯，而且這關聯的介紹再第一章就說明, 這樣才知道之後會介紹到帳戶。
### Suggestion
1. `產生過程` 這個標題改成 "如何產生公鑰與私鑰" or "公私鑰的產生"。你小標跟句子的第一行, 主詞要留著。有時候大家是跳著看, 有時候要截圖或複製內容, 會區少主詞, 不知道這段再描述什麼

##  06_network.md
### Question
1. 測試網路 / 測試鏈沒有networkid嗎?
1. Pow共識機制是什麼? Kovan用得POA跟Rinkeby用的POA是一樣的嗎? 都是這個嗎? `Clique PoA protocol & Rinkeby PoA testnet`
1. 可能沒相關的問題：測試網路是由誰來計算出hash還有儲存block, 既然沒有gas的話,就沒有minor要算吧?
1. Rposten, kovan, Rinkeby我要如何選擇我要使用哪個testnet?
1. `把位置發在twitter`?
1. geth是? 然後發現在下一章有教 冏
1. TestRPC是? 跟私鏈有什麼不同?  

### Suggestion
1. 開發鏈跟測試鏈沒有英文嗎?
1. `可以由你自己創造`,`可以只用本機環境` 感覺起來是 也可以不用本機環境
1. `取得測試幣，以 Rinkeby 為例` 這段感覺應該是全部類型介紹完在介紹

https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/