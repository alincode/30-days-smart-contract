# 介紹 Oraclize 與資料來源

區塊鏈網路與我們一般所認知的網際網路是兩個世界，資料並沒有直接互通。那我們要如何從智能合約取得外部資料呢？

我們可以建立一個後端應用程式，讓它替我們從網際網路取值，之後在建立一筆交易來把資料寫入區塊鏈中，那智能合約就可以讀得到值了。但你的後端應用程式，是架在中央式服務器，你有絕對控制權，要如何取得大家信任取值的過程沒有人為因素。

很難對吧，`Oraclize` 看到了這個需求的缺口，催生了這個服務，協助你在智能合約中取得外部 API 的資料。

**Oraclize 是什麼？**

Oraclize 是一個資料提供者，在區塊鏈上提供可信賴 (oracle) 的資料，服務不僅限於以太坊，它也可以使用在其他區塊鏈，例如 EOS、Rootstock、Fabric。

**Oraclize 的核心概念**

Oraclize 透過三個概念貫穿整個服務

1. 資料來源型態
2. 查詢 (query)
3. 真實性證明 (Authenticity Proof)

今天我們只會先提到第一個概念

## 資料來源

Oraclize 提供五種資料來源 (data source)，讓你取得外部環境的資料。

### 1. URL 資料來源

從 HTTP API 取得資料

**HTTP GET request**

* 假如 `oraclize_query` 函式只有一個 `arg` 傳入參數的時候，服務會用 HTTP GET 的方式來取得資料。

**語法**

```js
function oraclize_query(string datasource, string arg) 
    oraclizeAPI internal returns (bytes32 id)
```

**範例**

```js
oraclize_query(
    "URL",
    "https://www.therocktrading.com/api/ticker/ETHEUR"
    )
```

**HTTP POST request**

* 假如 `oraclize_query` 函式只有第二個 `arg` 傳入參數的時候，服務則會用 HTTP POST 的方式來取得資料。

**語法**

```js
function oraclize_query(string datasource, string arg1, string arg2) 
    oraclizeAPI internal returns (bytes32 id)
```

**範例**

```js
oraclize_query(
    "URL",
    "json(https://shapeshift.io/sendamount).success.deposit",
    '{
        "pair":"eth_btc",
        "amount":"1",
        "withdrawal":"1AAcCo21EUc1jbocjssSQDzLna9Vem2UN5"
    }'
)
```

**`Parsing Helper` 函式**

如果我們只需要一個值，可以搭配 `Parsing Helper` 函式，將資料先過濾過後，才送回我們的智能合約。

Parsing Helper 函式有四種 Parsing 類型：

* JSON Parsing
* XML Parsing
* HTML Parsing
* Binary Parsing

### 2. WolframAlpha 資料來源

WolframAlpha 是一個使用 AI 技術的線上自動問答系統，你只要傳入問題，它就會回傳答案給你。問題的範圍非常廣泛，從最基本的天氣、微積分、統計學，甚至連地球科學的問題，它都可以回應你。

```js
oraclize_query("WolframAlpha", "random number between 0 and 100");
```

> WolframAlpha 官網：<https://www.wolframalpha.com/>
> wiki：<https://zh.wikipedia.org/wiki/Wolfram_Alpha>

### 3. IPFS 資料來源

IPFS (InterPlanetary File System) 是一個 P2P 的分散式檔案系統。因為區塊鏈儲存資料非常昂貴，所以你可以上傳檔案到 IPFS 後，將 IPFS 給你的 hash 值存入區塊鏈中。

```js
oraclize_query("IPFS", "QmdEJwJG1T9rzHvBD8i69HHuJaRgXRKEQCP7Bh1BVttZbU");
```

> miaoski 的 IPFS 筆記和教學 (繁體中文)：<https://github.com/miaoski/ipfs-tutorial>
> wiki：<https://zh.wikipedia.org/wiki/%E6%98%9F%E9%99%85%E6%96%87%E4%BB%B6%E7%B3%BB%E7%BB%9F>

### 4. random 資料來源

可以從這個資料來源取得亂數值，使用的產生亂數演算法是 Oraclize 自創的，可以配合一些博易類智能合約使用。

### 5. computation 資料來源

`computation` 資料來源使用比較複雜，會用一個獨立的篇幅來說明。

### 延伸閱讀

* <https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol>