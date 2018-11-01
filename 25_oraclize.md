# 介紹 Oraclize 

區塊鏈網路與我們一般所認知的網際網路是兩個世界，資料並沒有直接互通。那我們要如何從智能合約取得外部資料呢？

我們可以建立一個後端應用程式，讓它替我們從網際網路取值，之後在建立一筆交易來把資料寫入區塊鏈中，那智能合約就可以讀得到值了。但你的後端應用程式，是架在中央式服務器，你有絕對控制權，要如何取得大家信任取值的過程沒有人為因素。

很難對吧，`Oraclize` 看到了這個需求的缺口，催生了這個服務，協助你在智能合約中取得外部 API 的資料。

### Oraclize 是什麼？

Oraclize 是一個資料提供者，在區塊鏈上提供可信賴 (oracle) 的資料，服務不僅限於以太坊，它也可以使用在其他區塊鏈，例如 EOS、Rootstock、Fabric。

## Oraclize 的核心概念

Oraclize 透過這三個概念貫穿整個服務，我們將用兩個篇幅來詳細的解釋。

### 資料來源型態

Oraclize 提供五種資料型態，讓你取得外部環境的資料。

1. URL 資料型態：從 HTTP API 取得資料
1. [WolframAlpha](https://zh.wikipedia.org/wiki/Wolfram_Alpha) 資料型態：從 WolframAlpha 服務取得資料。
1. IPFS 資料型態：從 IPFS (InterPlanetary File System) 取得資料
1. random 資料型態：取得亂數，亂數是由 Oraclize 實作的特別演算法產生。
1. computation 資料型態

> WolframAlpha 是一個線上自動問答系統。

### oraclize_query

`oraclize_query` 是 Oraclize 智能合約 API 所提供的一個函示。我們用一個簡單完整的範例來解釋 oraclize_query 執行流程。

第一步：匯入 `oraclizeAPI`

```js
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
```

第二步：繼承 `usingOraclize` 合約

```
contract ExampleContract is usingOraclize
```

第三步：呼叫 `oraclize_query` 函示


**語法**

```js
function oraclize_query(string datasource, string arg) 
    oraclizeAPI internal returns (bytes32 id)
```

**一般範例**

```js
oraclize_query(
  "URL",
  "https://www.therocktrading.com/api/ticker/ETHEUR"
)
```

上面的 API 回傳值如下：

```json
{
  trade_id: 41500686,
  price: "196.76000000",
  size: "0.06832073",
  bid: "196.75",
  ask: "196.76",
  volume: "58484.42274641",
  time: "2018-11-01T13:20:29.383000Z"
}
```

你可能只需要一個值，這時你就可以使用 `Parsing Helper` 函示，將資料先過濾過，才送回我們的智能合約。

Parsing Helper 函示有四種

* JSON Parsing
* XML Parsing
* HTML Parsing
* Binary Parsing

**結合 Parsing Helper 的範例**

```js
oraclize_query(
  "URL", 
  "json(https://api.gdax.com/products/ETH-USD/ticker).price");
```

第四步：實作 `__callback` 函示

```js
function __callback(bytes32 myid, string result) {
  if (msg.sender != oraclize_cbAddress()) revert();
  // 略...
}
```

#### 完整範例

![](assets/oraclize/query_flow.png)

```js
pragma solidity ^0.4.25;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract ExampleContract is usingOraclize {

   string public ETHUSD;

   function updatePrice() payable {
       oraclize_query(
            "URL", 
            "json(https://api.gdax.com/products/ETH-USD/ticker).price");
   }
   
   function __callback(bytes32 myid, string result) {
       if (msg.sender != oraclize_cbAddress()) revert();
       ETHUSD = result;
   }
}
```

<!-- ### 真實性證明 -->