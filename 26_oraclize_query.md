## oraclize_query 函式

基本上 Oraclize 的責任就是傳送資料給智能合約或提供資料的可靠證明 (可靠證明會留到下一篇說明)。Oraclize 與以太坊的智能合約整合是非同步的，任何一個 request 都包含兩個步驟。

第一，使用者執行一個智能合約的函示，這個函示裡面又呼叫了 `oraclize_query` 函示 (`oraclize_query` 函式，是從 `oraclizeAPI` 合約繼承而來)，Oraclize 服務會持續監控 `oraclize_query` 所觸發的事件。

第二，Oraclize 會持續監控 request，然後根據 request 的參數從外部環境取得或計算一個結果，然後建立一筆攜帶結果到開發者實作的智能合約 `__callback` 函示中。

![](assets/oraclize/query_flow.png)

### 實作 oraclize_query 函式

`oraclize_query` 是 Oraclize 智能合約 API 所提供的一個函式。我們用一個簡單完整的範例來解釋 oraclize_query 執行流程。

#### 第一步：匯入 `oraclizeAPI`

```js
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
```

只有在 remix 可以直接使用 URL 的方式 import，如果你是用本機端自行編譯智能合約，請直接下載 `oraclizeAPI.sol` 至本機，然後指定合約的相對路徑位置。

#### 第二步：繼承 `usingOraclize` 合約

```
contract ExampleContract is usingOraclize
```

#### 第三步：呼叫 `oraclize_query` 函式

在使用預設 `gas` 參數的情況下，合約的第一個呼叫 Oraclize 的 request，將不會被收費。如果連續發送多筆 request，將會被收費來支付 callback transaction 的費用。將會自動從 contract 的帳戶中扣錢，若 contract 中沒有足夠的金錢，request 將會 fail 並且 Oraclize 不會回傳任何資料。

<https://www.therocktrading.com/api/ticker/ETHEUR> API 回傳值如下：

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

**結合 Parsing Helper**

把 url 用 () 包住，然後在指定用哪種 parser helper，這裡使用的是 `json` 格式。

```js
oraclize_query(
  "URL", 
  "json(https://api.gdax.com/products/ETH-USD/ticker).price");
```

#### 第四步：實作 `__callback` 函式

`__callback` 函式名稱是固定的，不能取別的名字，在函式內的第一行需要先驗證，呼叫此函式的來源真的是從 oraclize 主機，不接受來路不明丟過來的值。`result` 就是從外部取得的值，

```js
function __callback(bytes32 queryId, string result) {
  if (msg.sender != oraclize_cbAddress()) revert();
  // 略
}
```

### 完整範例

```js
pragma solidity ^0.4.25;
// Step 1: 匯入 API
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

// Step 2: 繼承 usingOraclize 合約
contract ExampleContract is usingOraclize {

  string public ETHUSD;

  function updatePrice() payable {
    // Step 3: 呼叫 oraclize_query 函式
    oraclize_query(
      "URL", 
      "json(https://api.gdax.com/products/ETH-USD/ticker).price"
    );
  }
  
  // Step 4: 實作 `__callback` 函式
  function __callback(bytes32 myid, string result) {
    if (msg.sender != oraclize_cbAddress()) revert();
    ETHUSD = result;
  }
}
```

### 補充：Oraclize 外掛

首先你先要把 Oraclize 的外掛打開，它位在 Remix (<http://remix.ethereum.org/>) 的 setting 頁籤，裡面有一個 Oraclize 按鈕。

![](assets/oraclize/remix_setting_tab.png)

你可以試著上面那段程式碼複製到 Remix IDE 執行看看，這個外掛可以讓你很方便看到回應的結果。

![](assets/oraclize/plugin.png)