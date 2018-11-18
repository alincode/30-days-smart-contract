# 什麼是 Gas

什麼是 `Gas`？很少人把它翻譯為中文，少數人稱它為「瓦斯」，但在後面的內容我們仍然用 Gas 這個單詞，不特別去翻譯它。它在區塊鏈是一個非常基礎的概念，即使你不開發智能合約，當你買賣以太幣或轉以太幣給別人時，也需要使用到 Gas。

![](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSHfJIYxbCgrRUNppcb35MykYlSARqlRXyHW3jc3w7rjakZxsgWPg)

#### 為什麼會需要 Gas

我們為什麼會需要 Gas？當你撰寫的智能合約要上線的時候，不需要租一台固定的主機來部署你的程式，因為合約是部署在區塊鏈上，每當有人呼叫合約裡的函式，將會透過礦工的主機來執行函式，若程式中有修改到合約狀態，主機將會把修改的內容寫入區塊鏈中(建立一筆交易紀錄)。

所以實際執行程式的地方，是由區塊鏈中的眾多節點所協助完成，部署或呼叫合約的人，只需要負擔 Gas 作為交易手續費來支付花費區塊鏈資源的成本。交易手續費是由 `gas limit` 和 `gas price` 兩個值來決定，每筆交易都一定會包含這兩個值。

### Gas Price

Gas Price 代表的是你願意支付 Gas 的單價，以 `gwei` 為單位，在交易中 Gas Price 是交易發起人決定的，但礦工會依照 Gas Price 的高低來決定處理交易的優先權，如果你訂的單價比較低，交易手續費會比較省，但交易會比較慢被處理。

### Gas Limit

Gas Limit 代表的是你最多允許消耗多少 `Gas` 為上限，這樣的設計是為了安全考量，若有一個交易需要花費大量的運算資源，或也許它根本就是一個程式的 bug 導致無限迴圈，不管如何，當約定的 Gas limit 耗盡時，執行就會被終止。

**Gas Limit 設定太低**

當 Gas Limit 設定太低，若函式前兩行是修改變數值，執行到第三行時，你的 `Gas` 沒了，在這種情況下交易失敗，交易之前所有修改的狀態會被回復到前一個狀態，並且交易費會被沒收。

以下面的圖為例，`0.08 Ether` 的交易手續費會被礦工收走，這個概念像是沒有功勞也有苦勞一樣，雖然只做了一半，但是因為你設定的 `Gas Limit` 太低，所以礦工沒把交易完成，但你實際還是用到了礦工的資源，所以還是需要付費。

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/02/transaction_fail.png)

**Gas Limit 設定過高**

若 Gas limit 估算太高，但實際上不需要消耗掉那麼多的 Gas，剩餘的部分會退回，不會有損失。

#### Gas 單位表

這裡只列出幾種單位，如果想查詢全部的單位可以看[以太坊黃皮書](https://ethereum.github.io/yellowpaper/paper.pdf)，實際上僅 wei、Gwei、ether 比較常見。

| Unit                | Wei Value | Wei                       |
|---------------------|-----------|---------------------------|
| wei                 | 1 wei     | 1                         |
| Kwei (babbage)      | 1e3 wei   | 1,000                     |
| Mwei (lovelace)     | 1e6 wei   | 1,000,000                 |
| Gwei (shannon)      | 1e9 wei   | 1,000,000,000             |
| microether (szabo)  | 1e12 wei  | 1,000,000,000,000         |
| milliether (finney) | 1e15 wei  | 1,000,000,000,000,000     |
| ether               | 1e18 wei  | 1,000,000,000,000,000,000 |

**每個指令所需的 GAS 數量**

* 每一個交易的基本費是 21000 Gas

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/06/fee_schedule.png)

#### 交易手續費計算公式

```
預估交易費 = Gas Limit x Gas Price
實際交易費 = Gas Used x Gas Price
```

以下面的圖為例

* Gas Price 是 20 Gwei (= 0.00000002 Ether)
* Gas Limit 是 39000
* Gas Used 是 21000

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/02/transaction1.png)

所以計算結果為

```
預估交易費 = 39000 x 0.00000002 Ether = 0.00078 Ether
實際交易費 = 21000 x 0.00000002 Ether = 0.00042 Ether
大約等於 0.09 USD 或 2.7 TWD
```

#### 查詢 Gas 資訊

我們經常會使用到 Gas，但 Gas 就跟我們日常會用到的汽油一樣，單價會因為市場而浮動，那我們要怎麼知道單價該設多少才適合？下面這兩個網站可以找到當下 Gas 單價的建議值。

Ethereum GAS Tracker
* 網址：<https://etherscan.io/gastracker>
* 可以參考 Safe Gas Price 的值

![Ethereum GAS Tracker](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/06/gas_tracker.png)

ETH Gas Station
* 網址：<https://ethgasstation.info>
* 可以參考 Gas Price Std (Gwei) 的值

![ETH Gas Station](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/06/ethgasstation.png)

ETH Gas Station 裡面有一個[計算機](https://ethgasstation.info/calculatorTxV.php)，可以快速幫妳算出建議的交易手續費參考值。

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/06/calculatorTxV.png)

#### 小結

如果你之前沒接觸過區塊鏈，Gas 對你可能會是一個很新奇的觀念，因為我們已經習慣網路上的資源是由提供網站的人買單。

例如今天我們在一個網站註冊成為會員，網站會把我們填寫的資訊寫入至資料庫中，在這個過程中，我們雖然使用了資料庫的資源，但並沒有付費，因為提供網站的人已經預付了這樣的費用。

但我們在執行智能合約時邏輯則不太一樣，若需要把資料寫入至區塊鏈中，合約會向實際使用資源的人收費。

### 資料來源

* [以太坊黃皮書](https://ethereum.github.io/yellowpaper/paper.pdf)