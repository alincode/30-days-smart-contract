# 用戶端 (Client)

每當在網路上閱讀零散的文章來學習區塊鏈的時，看到 `Geth` 這個詞都會有點疑惑，它到底是什麼東西。

我知道 Geth 是以太坊的用戶端，它實作了以太坊，但有些文章又說 Geth 可以當作節點使用，即使我知道它可以做什麼，但我還是不知道它到底是什麼，因為這些解釋都太過抽象。

直到持續閱讀區塊鏈相關領域的文章多日，才終於了解它，希望大家看過這篇文章後，不需要像我一樣繞了這麼大圈的路。

從比較常見的例子來說，還記得紅極一時的 [BitTorrent](https://zh.wikipedia.org/wiki/BitTorrent_(%E5%8D%8F%E8%AE%AE)) (BT)，它伴隨了當年仍是窮學生的時光，我們用它來抓一些大型檔案，它的特色是若下載同一檔案的人越多，下載該檔案的速度越快，因為在下載檔案的同時，我們也變成了傳遞這個檔案的節點。所以當我們執行 Geth 之後，本機就會開始去下載區塊鏈的資料，就會變成以太坊網路中的一個節點。這樣算礦工嗎？答案是否定的，因為我們並沒有執行 miner 指令。

實際上我覺得翻譯成用戶端，其實會有點誤導，因為用戶端第一個會聯想到的是伺服器端，但區塊鏈是一個分散式架構，並沒有伺服器端，那 `implement ethereum` 可能會比較貼切，但中文要怎麼翻？實作以太坊？還是很模糊對吧。

那我們從 Geth 具備了哪些功能來看，它可以建立帳戶，也可以建立交易，還可以透過 API 查詢到區塊鏈裡的資料，所以它具有以太坊規範裡的那些功能，所以它「實作以太坊」，Geth 是用 Go 語言實作的，所以只有 Go 語言可以實作以太坊嗎？

你可以使用任何語言來實作以太坊，像是用 Rust 語言來實作以太坊，專案名稱就叫 [Parity](https://github.com/paritytech/parity-ethereum)。不管是 `Geth` 或 `Parity` 都是實作以太坊，只是使用了不同的程式語言，並且實作的完整度或提供的介面不太一樣。幾乎每種語言都有實作以太坊的相對應專案，但目前最受歡迎是 Geth 和 Parity。

**各專案所支援的協定**

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/08/support.png)

> WS 是 WebSocket 的縮寫，IPC 是指 IPC Socket

#### go-ethereum

* 簡稱 `Geth`，使用 `GO` 語言 (Golang)，由以太坊官方團隊所維護跟實作。
* 介面
  * `Javascript Console`：在 Geth 主控台與以太坊互動
  * [JSON-RPC server](https://github.com/ethereum/wiki/wiki/JSON-RPC)
* 官網：<https://geth.ethereum.org/>
* Github：<https://github.com/ethereum/go-ethereum>
* 文件：<https://github.com/ethereum/go-ethereum/wiki/geth>

#### Parity

![](https://wiki.parity.io/images/logo-parity.jpg)

* 使用 `Rust` 語言所開發
* 號稱最快最輕量的用戶端。不用下載全部的區塊鏈資料，就可以快速地進行節點的同步。
* 官網：<https://.arity.io/>
* Github：<https://github.com/paritytech/parity>
* 文件：<https://wiki.parity.io/>

#### Ethereumjs

* 使用 `Javascript` 語言所開發
* Github：<https://github.com/ethereumjs>

相關專案

* ethereumjs-client: <https://github.com/ethereumjs/ethereumjs-client>
* ethereumjs-tx: <https://github.com/ethereumjs/ethereumjs-tx>
* ethereumjs-util: <https://github.com/ethereumjs/ethereumjs-util>
* ethereumjs-wallet: <https://github.com/ethereumjs/ethereumjs-wallet>

<!-- 

**常見功能**

* 帳戶管理
  * 建立帳戶
  * 管理帳戶
  * key 匯入
* 交易
  * 進行轉帳
  * 查詢餘額
* 區塊
  * 挖礦
  * 作為一個節點，同步區塊資料。
  * 將交易寫入至區塊鏈中
  * 查詢區塊內容
  * 驗證區塊
* 智能合約
  * 編譯智能合約
  * 執行智能合約
  * 部署智能合約
* 做為 `HTTP-RPC` 伺服器




```sh
curl -X POST --data '{"jsonrpc":"2.0","method":"net_version","params":[],"id":67}'
```

回應的結果

```json
{
  "id":67,
  "jsonrpc": "2.0",
  "result": "3"
}
```

`result` 值是 3，這裡指的 3 是指網路編號，網路編號 3 是 `Ropsten` 測試網。


-->