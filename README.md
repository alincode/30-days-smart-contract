# 連續 30 天挑戰：Smart Contract 開發之使用 Solidity

[Day01: 什麼是智能合約)](https://ithelp.ithome.com.tw/articles/10200395)
[Day02: 區塊](https://ithelp.ithome.com.tw/articles/10200528)
[Day03: 交易](https://ithelp.ithome.com.tw/articles/10200654)
[Day04: 帳戶的基本概念](https://ithelp.ithome.com.tw/articles/10200900)
[Day05: 帳戶安全](https://ithelp.ithome.com.tw/articles/10200992)
[Day06: 網路](https://ithelp.ithome.com.tw/articles/10201207)
[Day07: 用戶端 Geth, Parity](https://ithelp.ithome.com.tw/articles/10201364)
[Day08: 什麼是 Gas？](https://ithelp.ithome.com.tw/articles/10201462)
[Day09: 線上版 IDE 之 Remix 基礎篇](https://ithelp.ithome.com.tw/articles/10201750)
[Day10: 線上版 IDE 之 Remix 進階篇](https://ithelp.ithome.com.tw/articles/10202347)
[Day11: 介紹 Solidity 語言](https://ithelp.ithome.com.tw/articles/10202884)
[Day12: 合約的結構](https://ithelp.ithome.com.tw/articles/10203280)
[Day13: Solidity 型別](https://ithelp.ithome.com.tw/articles/10203495)
[Day14: 表達示與流程控制](https://ithelp.ithome.com.tw/articles/10203645)
[Day15: 修飾標記 view、pure、fallback 及重載函式](https://ithelp.ithome.com.tw/articles/10204079)
[Day16: mapping 型別](https://ithelp.ithome.com.tw/articles/10204297)


# Discussion
## 01_introduction.md
### Suggestion
1. 第一次提到的關鍵字，可以把英文原文寫出來。Ex.  智能合約、共識機制、加密貨幣、去中心化、匿名性 等。主要是怕大家翻譯造成的認知誤差
1. 同理，第一次提到的英文，可以把中文寫出來，如果有的話。Ex. Gas Fee, 礦工費。
1. 大標題講完之後, 第一段通常會把關鍵字重複。例如 
 </br><b>什麼是Smart Contract?></b></br>
 Smart Contract中文大多翻為「智能合約」。....

## 02_block.md
### Question
1. block值是存在哪? 備份資料的節點是指? 如何否認資料真實性?
1. 每一次需要寫入資料，就得用掉一個block是不可行的原因是? 每個節點都要多儲存一份block? 因為每多一個block就要多計算一個新的hash成本很高?因為Hash會用完?
1. Mine是指根據"Data"而算出的hash對吧? 不同區塊練有不同的hash code產生規則?
### Suggestion
1. "所以我們還有另一個東西叫 Transaction" (語意沒有完成)。通常這句話後面會接著引入這個新名詞的目的，例如 "所以我們還有另一個東西叫Transaction, 可以用來達到....的需求, 又可以避免...的缺點"

## 03_tx.md
### Question
1.一個block有沒有限制存多少Trasaction? 還是看資料量?還是一個block有固定可以存的資料量, 存到資料量大的transaction,就只會存比較少筆。事由誰決定/控制要使用transaction來放入資料, 還是產生新的block
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
1. '讀完此篇後，你將具有基本的 Transaction 概念', 這種寫法是放在文章開頭,還沒讀之前。小結是表示讀完了,一般會用, "相信你現在已經具有基本的Transaction概念,..." 
