# 帳戶的基本概念

在與智能合約溝通的時候，經常會用到帳戶，所以勢必得先了解它。當我們聽到區塊鏈的時候，最常見的形容就是公開帳本 (public ledger) 技術。

帳本是大家最容易理解的原理，因為大家都有銀行戶頭，當我們要轉帳給某人的時候，我們需要填寫哪些資訊？

* 自己的銀行戶頭號碼
* 對方的銀行戶頭號碼
* 轉帳金額
* 簡短的備註資訊 (可選)

![](https://cdn2.ettoday.net/images/249/249290.jpg)
[圖片來源 - 東森新聞](https://www.ettoday.net/news/20130207/162668.htm)

那如果把這些概念搬到區塊鏈上大部分都成立，所以帳戶在區塊鏈是一個很基礎的元素。但區塊鏈的帳戶會在複雜一些，包含了`私鑰`、`公鑰`、`位址`元素。
<!-- 從介紹帳戶相關的一些專有名詞開始，及帳戶使用情境和帳戶的產生過程。 -->

#### 帳戶型態

在比特幣的世界帳戶就單純用來作為轉帳時的 FROM 跟 TO 指向，沒有其他特殊的意義，但在以太坊有智能合約，所以又把帳戶分成`外部帳戶`和`合約帳戶`兩種型態。

**外部帳戶**

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/04_eoa.png)

[圖片來源](https://etherscan.io/address/0xfb93a93df5ad461544f8a6ee48dfb4282099cc3d)

* 簡稱 EOA，全名 `Externally owned account`。
* 具有公鑰 (public key) 和 私鑰 (private key)
* 受私鑰所控制，如果弄丟了私鑰，就失去了帳戶的控制權。
* 跟比特幣指的帳戶的概念雷同

**合約帳戶**

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/04_contract_address.png)

[圖片來源](https://etherscan.io/address/0x06012c8cf97bead5deae237070f9587f8e7a266d)

* 簡稱 CA，全名 (Contract address)。
* 沒有私鑰，受智能合約的程式邏輯所掌控
* 每個智能合約在部署後，都會產一個對應的合約帳戶。
* 用來接收使用者轉帳錢智能合約

#### 解讀區塊鏈帳戶資訊

我們用一個實際的區塊鏈資料來說明。如下圖所示每筆交易都會有 `FROM` 和 `TO` 這兩個值，值得內容是某一個位址，你可以把位址想像成銀行的帳號。至於 `IN` 代表的則是匯入，`OUT` 代表的是匯出。

一分鐘前你收到了 0.01797717 Ether，然後你又快速地將這筆錢轉出去，所以你的帳戶又歸零了。

> 0.01780917 的原因是，0.01780917 + 0.000168 (手續費) = 0.01797717

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/04_account.png)

### 小結

你現在應該理解了什麼是帳戶，及以太坊的帳戶有哪兩種形式。因為區塊鏈內建的帳戶機制，所以讓我們開發智能合約時，可以不需要實作底層直接以太坊的機制就可以收款。不需要像第三方支付一樣，請會計定期與金流公司請款。