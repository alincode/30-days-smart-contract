# Oraclize - Ethereum

## Quick Start

The following section is dedicated to the Ethereum and Oraclize integration. To better profit from this section of the documentation, previous knowledge of Solidity and Ethereum is required.

這個章節將著重於 Ethereum 和 Oraclize 的整合。若要更好地理解這章的內容，需要一些 Solidity 和 Ethereum 的基礎知識。

The interaction between Oraclize and an Ethereum smart contract is asynchronous. Any request for data is composed of two steps:

Oraclize 與 Ethereum 的 Smart contract 的整合是非同步的，任何一個 request 都包含兩個步驟：

* Firstly, in the most common case, a transaction executing a function of a smart contract is broadcasted by a user. The function contains a special instruction which manifest to Oraclize, who is constantly monitoring the Ethereum blockchain for such instruction, a request for data.

第一，最常見的案例是使用者執行一個 Smart contract 的 函式(function)，這個函式裡面包含了呼叫 Oraclize 的命令，持續監控 Ethereum 區塊鏈來取得資料。


* Secondly, according to the parameters of such request, Oraclize will fetch or compute a result, build, sign and broadcast the transaction carrying the result. In the default configuration, such transaction will execute the __callback function which should be placed in the smart contract by its developer: for this reason, this transaction is referred in the documentation as the Oraclize callback transaction.

第二，根據 request 的參數，Oraclize 剛取得或計算一個結果，並發送攜帶 result 的 transaction。預設的情況，此 transaction 將會執行開發者實作 Smart Contract 中的 `__callback` 函式

As said in previous sections, one of the fundamental characteristics of Oraclize is the capability of returning data to a smart contract together with one or more proofs of authenticity of the data. The generation of an authenticity proof is optional and it is a contract-wide setting which must be configured by the smart contract developer before the request for data is initiated. Oraclize always recommends the use of authenticity proofs for production deployments.

如同前幾個章節所談到的，基本上 Oraclize 的責任就是傳送資料給 Smart Contract 或證明資料的真實性。authenticity proof 是選擇性的，Smart Contract 的開發者必須要在 Smart Contract 內做設置，並且要在發送 request 之前。

### Quick Start

The most simple way to introduce the Ethereum - Oraclize integration, it is by showing a working example, such as the smart contract on the right. This contract uses Oraclize to fetch the last ETH/USD from gdax.com APIs. The update process is initiated every time the function updatePrice() is called. The example shows two important components of using Oraclize:

介紹 Ethereum 與 Oraclize 整合最簡單的方式，就是展示一些可實際運作的範例，如下面這個程式碼。這個 Smart Contract 使用 Oraclize 從 gdax.com 的 API 取得最新的 ETH/USD 匯率資料。每次呼叫 `updatePrice` 函式都會更新匯率，這個範例使用了 Oraclize 的兩個重要元素。

```js
pragma solidity ^0.4.11;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract ExampleContract is usingOraclize {

   string public ETHUSD;
   event LogConstructorInitiated(string nextStep);
   event LogPriceUpdated(string price);
   event LogNewOraclizeQuery(string description);

   function ExampleContract() payable {
       LogConstructorInitiated("Constructor was initiated. Call 'updatePrice()' to send the Oraclize Query.");
   }

   function __callback(bytes32 myid, string result) {
       if (msg.sender != oraclize_cbAddress()) revert();
       ETHUSD = result;
       LogPriceUpdated(result);
   }

   function updatePrice() payable {
       if (oraclize_getPrice("URL") > this.balance) {
           LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
       } else {
           LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
           oraclize_query("URL", "json(https://api.gdax.com/products/ETH-USD/ticker).price");
       }
   }
}
```

* The contract should be a child of the contract usingOraclize

我們實作的合約需要繼承 `usingOraclize` 合約

* The contract usingOraclize is defined in the oraclizeAPI file, which can be fetched from the dedicated Oraclize Github repository.

`usingOraclize` 合約定義在 `oraclizeAPI` 檔案中，你可以從 Oraclize 的 Github repository 取得它。

The code in the example is working out of the box if Remix is used to compile and deploy it on any of the Ethereum networks: main-net and the Ropsten, Kovan and Rinkeby testnets. If, instead, another tool is used, it will be necessary to replace the import statement with a local import of the oraclizeAPI.sol file since direct import from Github may not be supported.

這個範例程式可以透過 Remix 進行編譯和發布在任何 Ethereum 的網路，例如：主網、Ropsten、Kovan、Rinkeby 測試網。如果你不是使用 Remix，你將需要替換 import 語法，不能直接從 github 位置 import。

To ease development, Oraclize doesn't charge a contract for its first request of data done using the default gas parameters. Successive requests will require the contract to pay the Oraclize fee and the ether necessary to pay for the callback transaction. Both are automatically taken from the contract balance. If the contract doesn't have enough funds in his balance, the request will fail and Oraclize won't return any data.

為了簡化開發，在使用預設 gas 參數的情況下，合約的第一個呼叫 Oraclize 的 request，將不會被收費。如果連續發送多筆 request，將會被收費來支付 callback transaction 的費用。將會自動從 contract 的帳戶中扣錢，若 contract 中沒有足夠的金錢，request 將會 fail 並且 Oraclize 不會回傳任何資料。

> Only the first query is free. Ensure that the contract has a sufficient ETH balance to pay the following queries. The contract gets automatically charged on the `oraclize_query` call but fails if the balance is insufficient.

> 只有第一個 query 是免費的。請確保 contract 中有足夠的 ETH 來支付 query 的費用。contract 在呼叫 `oraclize_query` 的時候會自動被收取，如果餘額不足則會失敗。

### Simple Query

A request for data is called query. The oraclize_query is a function, inhered from the parent usingOraclize contract, which expects at least two arguments:

發起一個 request 呼叫 query 取得 data。`oraclize_query` 是從 `usingOraclize` 合約繼承下來的函式，它預期至少有兩個參數：

* A data-source such as URL, WolframAlpha, IPFS, 'Swarm' and others listed here
* The argument for the given data-source. For examples:
    * the full URL, which may inclued the use of JSON or XML parsing helpers as it can be seen in the previous example
    * or a WolframAlpha formula
    * or an IPFS multihash

* 第一個參數是資料來源 (data-source)，例如 `URL`、`WolframAlpha`, `IPFS`, `Swarm`
* 第二個參數是給資料來源的值，例如：
    * 完整的 URL 網址，可能搭配著使用 JSON 或 XML 的解析 helper，如同下面範例所示。
    * 或一個 WolframAlpha formula
    * 或一個 IPFS multihash

```js
// This code example will ask Oraclize to send as soon as possible
// 呼叫 oraclize_query 之後，Oraclize 會盡快送出回應。
// a transaction with the primary result (as a string) of the given
// transaction 內包的 result 會是一個 string 值
// formula ("random number between 0 and 100") fetched from the
// data-source "WolframAlpha".
oraclize_query("WolframAlpha", "random number between 0 and 100");

oraclize_query("URL", "https://api.kraken.com/0/public/Ticker?pair=ETHXBT")

oraclize_query("URL",
  "json(https://www.therocktrading.com/api/ticker/BTCEUR).result.0.last")

oraclize_query("IPFS", "QmdEJwJG1T9rzHvBD8i69HHuJaRgXRKEQCP7Bh1BVttZbU")

// The URL data-source also supports a supplement argument, useful for creating HTTP POST requests.
// URL 資料來源，還支援補充參數 (supplement argument)，對於 HTTP POST 的 request 很有用。
// If that argument is a valid JSON string, it will be automatically sent as JSON.
// 如果參數是有效的 JSON 字串，它將會自動以 JSON 發送。
oraclize_query("URL", "json(https://shapeshift.io/sendamount).success.deposit",
  '{"pair":"eth_btc","amount":"1","withdrawal":"1AAcCo21EUc1jbocjssSQDzLna9Vem2UN5"}')
```

The number and type of supported arguments depends from the data-source in use. Beside, few more code example will be shown and commented. The data-source, as well as the authenticity proof chosen, determine the fee which the contract has to pay to Oraclize.

第二個參數值決定於 data-source 的型態。此外，還有更多的範例跟註解來示範。資料來源 (data-source) 和 authenticity proof 跟會決定合約需支付給 Oraclize 的費用。

### Schedule a Query in the Future

The execution of a query can be scheduled in a future date. The function oraclize_query accepts as a parameter the delay in seconds from the current time or the timestamp in the future as first argument. Please note that in order for the future timestamp to be accepted by Oraclize it must be within 60 days of the current UTC time in the case of the absolute timestamp choice, or in the case of a relative time elapse, the elapsed seconds must equate to no more than 60 days.

可以替 query 設定未來時間的排程，第一個參數為延遲的秒數值 (relative time) 或絕對時間 (absolute time)，請注意，不能超過 60 天。

```js
// Relative time: get the result from the given URL 60 seconds from now
oraclize_query(60, "URL",
  "json(https://api.kraken.com/0/public/Ticker?pair=ETHXBT).result.XETHXXBT.c.0")

// Absolute time: get the result from the given datasource at the specified UTC timestamp in the future
oraclize_query(scheduled_arrivaltime+3*3600,
  "WolframAlpha", strConcat("flight ", flight_number, " landed"));
```

### 遞迴查詢 (Recursive Queries)

Smart contracts using Oraclize can be effectively autonomous by implementing a new call to Oraclize into their __callback method. This can be useful for implementing periodic updates of some on-chain reference data, as with price feeds, or to periodically check for some off-chain conditions.

在 `__callback` 函式呼叫一個有包含 `oraclize_query` 的函式，將可以實現對 Oraclize 做遞迴查詢，這對定期檢查某些區塊鏈之外的資料非常有用。

This modified version of the previous example will update the ETH/USD exchange rate every 60 seconds until the contract has enough funds to pay for the Oraclize fee.

使用之前的範例來重新修改邏輯，實現了每 60 秒定期更新匯率，只要合約有足夠的錢可以支付 Oraclize，它會一直定期執行。

>  Use recursive queries cautiously. In general it is recommended to send queries purposefully.

> 請謹慎使用遞迴查詢，建議針對有目的性地使用 query。

```js
pragma solidity ^0.4.11;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract ExampleContract is usingOraclize {

    string public ETHUSD;
    event LogConstructorInitiated(string nextStep);
    event LogPriceUpdated(string price);
    event LogNewOraclizeQuery(string description);

    function ExampleContract() payable {
        LogConstructorInitiated("Constructor was initiated. Call 'updatePrice()' to send the Oraclize Query.");
    }

    function __callback(bytes32 myid, string result) {
        if (msg.sender != oraclize_cbAddress()) revert();
        ETHUSD = result;
        LogPriceUpdated(result);
        updatePrice();
    }

    function updatePrice() payable {
        if (oraclize_getPrice("URL") > this.balance) {
            LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
            oraclize_query(60, "URL", "json(https://api.gdax.com/products/ETH-USD/ticker).price");
        }
    }
}
```

### The Query ID

Every time the function oraclize_query is called, it returns a unique ID, hereby referred to as queryId, which depends from the number of previous requests and the address of smart contract. The queryId identifies a specific query done to Oraclize and it is returned to the contract as a parameter of the callback transaction.

每一次呼叫 `oraclize_query` 函式的時候，會回傳一個讀一讀二的 queryId，它取決於先前的 request 數量和合約的 address。當 query 完成時，callback transaction 會附有 queryId 資訊。

Oraclize recommends smart contract developers to verify if the queryId sends by the callback transaction was generated by a valid call to the oracize_query function, as shown in the example accompanying this paragraph. This ensures that each query response is processed only once and helps avoid misuse of the smart contract logic. Moreover, it protects the smart contract during blockchain reorganizations, as explained in the dedicated paragraph of this section.

Oraclize 建議 Smart Contract 的開發者驗證 callback 裡的 queryId 是否正確，如下面範例所示。以確保每個 response 只被處理一次，有助於 Smart Contract 被濫用，此外還可以提升 Smart Contract 的安全。

The queryId can be used as well to implement different behaviors into the __callback function, in particular when there is more than one pending call from Oraclize.

`queryId` 也可以使用於在 `__callback` 函式中實現不同邏輯的行為，特別是當有多筆來自 Oraclize 的 pending 呼叫。

```js
pragma solidity ^0.4.11;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract ExampleContract is usingOraclize {

    string public ETHUSD;
    mapping(bytes32=>bool) validIds;
    event LogConstructorInitiated(string nextStep);
    event LogPriceUpdated(string price);
    event LogNewOraclizeQuery(string description);

    function ExampleContract() payable {
        LogConstructorInitiated("Constructor was initiated. Call 'updatePrice()' to send the Oraclize Query.");
    }

    function __callback(bytes32 myid, string result) {
        if (!validIds[myid]) revert();
        if (msg.sender != oraclize_cbAddress()) revert();
        ETHUSD = result;
        LogPriceUpdated(result);
        delete validIds[myid];
        updatePrice();
    }

    function updatePrice() payable {
        if (oraclize_getPrice("URL") > this.balance) {
            LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
            bytes32 queryId =
                oraclize_query(60, "URL", "json(https://api.gdax.com/products/ETH-USD/ticker).price");
            validIds[queryId] = true;
        }
    }
}
```

### Custom Gas Limit and Gas Price

The transaction originating from Oraclize to the __callback function pays a fee to the miner which include the transaction in a block, just like any other transaction. The miner fee is paid in Ether and it is calculated by taking the amount of gas which covers the execution costs of the transaction multiplied by the selected gas/ether price. Oraclize will set those parameters accordingly to the parameters specified in the smart contract, for contract-wide settings, and in the oraclize_query function, for query-specific settings. The miner fee for the callback transaction is taken from the contract balance when the query transaction is executed.

從 Oraclize 來自的 transaction，就像其他 transaction 一樣，是需要付費給礦工的。礦工費是以 Ether 做支付，費用計算方式為 gas 數量乘與所指定的 gas 價格。Oraclize 將根據 Smart Contract 及 `oraclize_query` 函式內設置的指定參數。當執行 callback transaction 時的費用，取自於合約帳戶的錢。

If no settings are specified, Oraclize will use the default values of 200,000 gas and 20 GWei. This last value is on the higher-end of the pricing spectrum right now, but it helps having faster confirmation times during network-wide congestions.

如果在未指定的情況下，Oraclize 將會使用預設值 200,000 gas 和 20 GWei，20 Gwei 價格是訂的比較高一點，但它有助於在網路蠻忙時，更快取得結果。

A different value for the Oraclize callback gas can be passed as the argument `_gasLimit` to the `oraclize_query` function as shown in the following examples.

如果合約內要設定不同的 gas 值，可以透過傳遞 `_gasLimit` 參數給 `oraclize_query` 函式，如同下面的範例。

The gas price of the callback transaction can be set by calling the oraclize_setCustomGasPrice function, either in the constructor, which is executed once at deployment of the smart contract, or in a separate function. The following is the ExampleContract modified to specify a custom gas price of 4 Gwei and a custom gas limit for the callback transaction.

callback transaction 的 gas 價格，可以透過呼叫 `oraclize_setCustomGasPrice` 函式來設置，可以在建構子或單獨的函式中執行。以下範例是修改 ExampleContract 合約。將自訂 gas price 為 4 Gwei 和替 callback transaction 設定自訂的 gas limit。

Smart contract developers should estimate correctly and minimize the cost of their `__callback` method, as any unspent gas will be returned to Oraclize and no refund is available.

Smart Contract 的開發者應該要正確的估算，並最大限度地降低他們的 `__callback` 函式成本，因為任何未使用的天然氣，將返回給 Oraclize 且並不會退款。

> When calling `oraclize_setCustomGasPrice` the parameter type is uint and represents the amount of wei. However, there is no need to put `wei` keyword in the parameter.

> 當呼叫 `oraclize_setCustomGasPrice` 時，接受參數型態為 uint 表示 wei 的數量。但不用再參數中加入 `wei` 關鍵字。

```js
pragma solidity ^0.4.11;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract ExampleContract is usingOraclize {

    string public ETHUSD;
    mapping(bytes32=>bool) validIds;
    event LogConstructorInitiated(string nextStep);
    event LogPriceUpdated(string price);
    event LogNewOraclizeQuery(string description);

    // This example requires funds to be send along with the contract deployment
    // transaction
    function ExampleContract() payable {
        oraclize_setCustomGasPrice(4000000000);
        LogConstructorInitiated("Constructor was initiated. Call 'updatePrice()' to send the Oraclize Query.");
    }

    function __callback(bytes32 myid, string result) {
        if (!validIds[myid]) revert();
        if (msg.sender != oraclize_cbAddress()) revert();
        ETHUSD = result;
        LogPriceUpdated(result);
        delete validIds[myid];
        updatePrice();
    }

    function updatePrice() payable {
        if (oraclize_getPrice("URL") > this.balance) {
            LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
            bytes32 queryId =
                oraclize_query(60, "URL", "json(https://api.gdax.com/products/ETH-USD/ticker).price", 500000);
            validIds[queryId] = true;
        }
    }
}
```

```js
// If the callback transaction requires little gas, the value can be lowered:
oraclize_query("URL", "json(https://api.gdax.com/products/ETH-USD/ticker).price", 100000);

// Callback methods may be expensive. The example requires the JSON parsing
// a string in the smart contract. If that's the case, the gas should be increased:
oraclize_query("URL", "https://api.gdax.com/products/ETH-USD/ticker", 500000);
```

### 真實性證明 (Authenticity Proofs)

Authenticity proofs are at the core of Oraclize's oracle model. Smart contracts can request authenticity proofs together with their data by calling the oraclize_setProof function available in the usingOraclize. The authenticity proof can be either deliver directly to the smart contract or it can be saved, upload and stored on [IPFS](http://ipfs.io/).

真實性證明 (Authenticity Proofs) 是 Oraclize 的 oracle 核心 model。Smart Contract 可以透過呼叫 `usingOraclize` 合約提供的 `oraclize_setProof` 函式來請求真實性證明。真實性證明可以直接發送給 Smart Contract，也可以上傳並保存在 [IPFS](http://ipfs.io/)。

When a smart contract requests for an authenticity proof, it must define a different callback function with the following arguments: `function __callback(bytes32 queryId, string result, bytes proof)`

當 Smart Contract 請求「真實性證明」，他必須要定義不同的 callback 函式，像這樣 `function __callback(bytes32 queryId, string result, bytes proof)`。

The `oraclize_setProof` function expects the following format: `oraclize_setProof(proofType_ | proofStorage_ )`

`oraclize_setProof` 函式期待的格式是 `oraclize_setProof(proofType_ | proofStorage_ )`

Both `proofType` and `proofStorage` are byte constants defined in `usingOraclize`:

`proofType` 和 `proofStorage` 是 `usingOraclize` 合約裡定義的常數：

Available parameters for `proofTypes` are:

`proofTypes` 可用的參數有：

* `proofType_NONE`: the default value of any smart contracts
* `proofType_TLSNotary`
* `proofType_Android`
* `proofType_Native`
* `proofType_Ledger`

While for proofStorage:

`proofStorage` 可用的參數有：

* `proofStorage_IPFS`

For example, `oraclize_setProof(proofType_TLSNotary)` will return the full TLSNotary Proof bytes as the proof argument in the callback transaction. If instead `oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS)` is used, then Oraclize will return only the base58-decoded IPFS multihash as the proof argument. To obtain the IPFS multihash, the bytes must be encoded to base58. The method `oraclize_setProof` can be executed in the constructor, becoming a contract-wide lasting setting, or it can be set directly before a specific query is to be made. Authenticity proofs can be disabled by calling `oraclize_setProof(proofType_NONE)`. Smart contract developer should be aware that the helper method `oraclize_setProof` is an internal function of `usingOraclize`, and therefore it must be included specifically in their smart contract at compile time, before deployment. The following builds on our previous example:

例如 `oraclize_setProof(proofType_TLSNotary)` 將返回完整的 TLSNotary Proof bytes 作為 callback transaction 的 `proof` 參數值。如果使用 `oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS)` 則 Oraclize 只會回傳 base58-decoded IPFS multihash 當作 `proof` 參數值。要取得 IPFS multihash 的話，bytes 需要做 base58 的 encoded。`oraclize_setProof` 函式可以在建構子中執行，成為合約的預設值，或著可以在進行特定查詢之前才設置。可以通過呼叫 `oraclize_setProof(proofType_NONE)` 函式來停用真實性認證。智能合約的開發者應該要知道 `oraclize_setProof` 是 `usingOraclize` 合約的輔助性內部函式，因此在發布合約前，編譯時就包含在他們所編寫的智能合約中。

以下是根據我們之前的範例所改寫：

```js
pragma solidity ^0.4.11;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract ExampleContract is usingOraclize {

    string public ETHUSD;
    mapping(bytes32=>bool) validIds;
    event LogConstructorInitiated(string nextStep);
    event LogPriceUpdated(string price);
    event LogNewOraclizeQuery(string description);


    // This example requires funds to be send along with the contract deployment
    // transaction
    function ExampleContract() payable {
        oraclize_setCustomGasPrice(4000000000);
        oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
        LogConstructorInitiated("Constructor was initiated. Call 'updatePrice()' to send the Oraclize Query.");
    }

    function __callback(bytes32 myid, string result, bytes proof) {
        if (!validIds[myid]) revert();
        if (msg.sender != oraclize_cbAddress()) revert();
        ETHUSD = result;
        LogPriceUpdated(result);
        delete validIds[myid];
        updatePrice();
    }

    function updatePrice() payable {
        if (oraclize_getPrice("URL") > this.balance) {
            LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
            bytes32 queryId =
                oraclize_query(60, "URL", "json(https://api.gdax.com/products/ETH-USD/ticker).price", 500000);
            validIds[queryId] = true;
        }
    }
}
```

### 驗證 (Verifiability)

Supported proofs can be verified. The following tools can be used: [Verification Tools](http://docs.oraclize.it/#development-tools-network-monitor)

透過以下[驗證工具](http://docs.oraclize.it/#development-tools-network-monitor)，Proof 可以被驗證。

## Best Practices

### Precalculating the Query Price

You have to consider that your account will be debited for most of your Oraclize calls. If your contract is not covered with enough ETH, the query will fail. Depending on your contract logic you may want to check the price for your next query before it gets send. You can do this by calling `oraclize_getPrice` and check if it is higher than your current contract balance. If that's the case the `oraclize_query` will fail and you may want to handle it gracefully. You can also add a `gaslimit` parameter to the `oraclize_getPrice` function: `oraclize_getPrice(string datasource, uint gaslimit)`. Make sure that the custom gaslimit for `oraclize_getPrice` matches with the one you will use for `oraclize_query`.

你必須要考慮到 Oraclize 的呼叫會從你的合約帳戶中扣款。如果你的合約未包含足夠的 ETH，查詢將會失敗。根據這樣的邏輯，你可能會希望在發送 Oraclize query 之前，檢查一下 query 的價格。你可以透過呼叫 `oraclize_getPrice` 函式，來檢查它是否高於你當前的合約餘額。如果是的話，`oraclize_query` 函式將會失敗，你可以事前處理掉這樣的情況。你還可以在呼叫 `oraclize_getPrice` 函式時，傳入 `gaslimit` 參數，格式像這樣 `oraclize_getPrice(string datasource, uint gaslimit)`。需確保傳入 `oraclize_getPrice` 函式 `gaslimit` 參數值要跟 `oraclize_query` 函式裡的 `gaslimit` 參數值一致。

```js
pragma solidity ^0.4.0;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract KrakenPriceTicker is usingOraclize {

    string public ETHXBT;
    uint constant CUSTOM_GASLIMIT = 150000;

    event LogConstructorInitiated(string nextStep);
    event newOraclizeQuery(string description);
    event newKrakenPriceTicker(string price);


    function KrakenPriceTicker() {
        oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
        LogConstructorInitiated("Constructor was initiated. Call 'update()' to send the Oraclize Query.");
    }

    function __callback(bytes32 myid, string result, bytes proof) {
        if (msg.sender != oraclize_cbAddress()) revert();
        ETHXBT = result;
        newKrakenPriceTicker(ETHXBT);
    }

    function update() payable {
        if (oraclize_getPrice("URL", CUSTOM_GASLIMIT) > this.balance) {
            newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
            oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHXBT).result.XETHXXBT.c.0", CUSTOM_GASLIMIT);
        }
    }
}

```

### Mapping Query Ids

It might occur that a callback function of a sent query gets called more than once. Therefore it might be helpful to initiate a mapping that manages the query ids and their states. When the callback function of a query gets called, the require statement checks if the current query id needs to be processed. After one successful iteration the id gets deleted to prevent further callbacks for that particular id.

可能會發生多次呼叫 callback 函式的情況，因此，在 callback 函式的最前面檢查 queryIds 的 mapping 會有幫助。

當呼叫 query 觸發 callback 函式時，要用 `require` 語法檢查是否要處理當前的 queryId。在成功的處理完後，把 queryId 從 `pendingQueries` mapping 中刪除，以防止重複的被觸發。

```js
pragma solidity ^0.4.11;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract ExampleContract is usingOraclize {

    string public ETHUSD;
    event LogConstructorInitiated(string nextStep);
    event LogPriceUpdated(string price);
    event LogNewOraclizeQuery(string description);

    mapping (bytes32 => bool) public pendingQueries;

    function ExampleContract() payable {
        LogConstructorInitiated("Constructor was initiated. Call 'updatePrice()' to send the Oraclize Query.");
    }

    function __callback(bytes32 myid, string result) {
        if (msg.sender != oraclize_cbAddress()) revert();
        require (pendingQueries[myid] == true);
        ETHUSD = result;
        LogPriceUpdated(result);
        delete pendingQueries[myid]; 
        // This effectively marks the query id as processed.
    }

    function updatePrice() payable {
        if (oraclize_getPrice("URL") > this.balance) {
            LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
            bytes32 queryId = oraclize_query("URL", "json(https://api.gdax.com/products/ETH-USD/ticker).price");
            pendingQueries[queryId] = true;
        }
    }
}
```

## 進階主題 (Advanced Topics)

### 加密查詢 (Encrypted Queries)

Certain contexts, such as smart contracts on public blockchains, might require a level of privacy to protect data from public scrutiny. Developers can make encrypted Oraclize queries by encrypting a part (or all) of a query with the Oraclize public key. The encrypted queries feature may be of interested to developers who want to deploy their blockchain applications of public networks. For example, if an application leverages data from an authenticated API, it would be dangerous to disclose the API key to anyway who is monitoring the public chain.

在某些情況下，例如智能合約發佈在公開鏈上，可能需要一定程度的加密來保護數據的公共安全。開發人員可以透過加密 Oraclize 的公鑰來加密 queries 的部分或全部內容。開發者若需要將智能合約發佈在公開網路上應該會感興趣。例如，如果應用程式在公開網路上洩漏通過身份認證所取得的 API key，那將是危險的。

Oraclize therefore offers the possibility of encrypting the parameters contained in a query to Oraclize's public key:

因此，Oraclize 提供了公鑰讓 query 的參數可以被加密：

```
044992e9473b7d90ca54d2886c7addd14a61109af202f1c95e218b0c99eb060c7134c4ae46345d0383ac996185762f04997d6fd6c393c86e4325c469741e64eca9
```

Only Oraclize will then be able to decrypt the request using its paired private key.

只有 Oraclize 可以使用相配對的私鑰將 reqeust 的內容做解密。


To encrypt the query, Oraclize provides a CLI tool, which can be found [here](https://github.com/oraclize/encrypted-queries). Alternatively,
The CLI command to encrypt an arbitrary string of text is then:

為了加密 query，Oraclize 提供了一個 CLI 工具，你可以在[這裡](https://github.com/oraclize/encrypted-queries)找到，可以用下面的指令執行。

```sh
python encrypted_queries_tools.py -e -p 044992e9473b7d90ca54d2886c7addd14a61109af202f1c95e218b0c99eb060c7134c4ae46345d0383ac996185762f04997d6fd6c393c86e4325c469741e64eca9 "YOUR QUERY"
```

This will encrypt the query with the default Oraclize public key. The encrypted string can then be used as an argument for an Oraclize query.

使用 Oraclize 預設的公鑰加密過後的內容，可以作為 Oraclize query 的參數值。

>  You could also encrypt only 1 parameter of oraclize_query(), leaving the other ones in cleartext.

> 你可以只加密 `oraclize_query` 的一個參數，其他參數保持明文(非加密狀態)。

```js
// In this example, the entire first argument of an oraclize_query has been encrypted.
// The actual string encrypted is:  json(https://poloniex.com/public?command=returnTicker).BTC_ETH.last
oraclize_query("URL","AzK149Vj4z65WphbBPiuWQ2PStTINeVp5sS9PSwqZi8NsjQy6jJLH765qQu3U/bZPNeEB/bYZJYBivwmmREXTGjmKJk/62ikcO6mIMQfB5jBVVUOqzzZ/A8ecWR2nOLv0CKkkkFzBYp2sW1H31GI+SQzWV9q64WdqZsAa4gXqHb6jmLkVFjOGI0JvrA/Zh6T5lyeLPSmaslI");
```

```js
// This is the query that we want to encrypt
oraclize_query("URL","json(https://api.postcodes.io/postcodes).status",
  '{"postcodes" : ["OX49 5NU", "M32 0JG", "NE30 1DP"]}')
```


The encryption method is also available for POST requests: you can encrypt both the URL and the POST data field as in the following example:

範例一：加密也可被用於 POST request：你可以加密 URL 和 POST 的資料，如下面範例所示：


Encrypt the datasource (URL in this case):
```sh
python encrypted_queries_tools.py -e -p 044992e94... "URL"
```

Returns: 
```
BEIGVzv6fJcFiYQNZF8ArHnvNMAsAWBz8Zwl0YCsy4K/RJTN8ERHfBWtSfYHt+uegdD1wtXTkP30sTW+3xR3w/un1i3caSO0Rfa+wmIMmNHt4aOS
```


Encrypt the argument(in this case we are using the JSON parsing helper to retrieve the "status" ):

範例二：加密參數 (這個案例包含了使用 JSON parsing helper 取 status 值)

```sh
python encrypted_queries_tools.py -e -p 044992e94... "json(https://api.postcodes.io/postcodes).status"
```

Returns:
```
BNKdFtmfmazLLR/bfey4mP8v/R5zCIUK7obcUrF2d6CWUMvKKUorQqYZNu1YfRZsGlp/F96CAQhSGomJC7oJa3PktwoW5J1Oti/y2v4+b5+vN8yLIj1trS7p1l341Jf66AjaxnoFPplwLqE=
```


Encrypt the JSON (third argument, the data to POST):

範例三：加密 JSON (第三個參數是 HTTP POST 的資料)


```sh
python encrypted_queries_tools.py -e -p 044992e94... '{"postcodes" : ["OX49 5NU", "M32 0JG", "NE30 1DP"]}'
```

Returns:
```
BF5u1td9ugoacDabyfVzoTxPBxGNtmXuGV7AFcO1GLmXkXIKlBcAcelvaTKIbmaA6lXwZCJCSeWDHJOirHiEl1LtR8lCt+1ISttWuvpJ6sPx3Y/QxTajYzxZfQb6nCGkv+8cczX0PrqKKwOn/Elf9kpQQCXeMglunT09H2B4HfRs7uuI 
```

You can also do this with a request to another datasource like WolframAlpha, the Bitcoin blockchain, or IPFS. Our encryption system also permits users to encrypt any of the supported datasource options.

你可以使用其他資料來源 (data-source) 像是 WolframAlpha、Bitcoin blockchain 或 IPFS 來執行加密的動作。我們的加密系統支援用戶加密任何我們提供的 data source options 型態。

```js
// Finally we add all the encrypted text
// to the oraclize_query (in the right order)
oraclize_query("BEIGVzv6fJcFiYQNZF8ArHnvNMAsAWBz8Zwl0YCsy4K/RJTN8ERHfBWtSfYHt+uegdD1wtXTkP30sTW+3xR3w/un1i3caSO0Rfa+wmIMmNHt4aOS","BNKdFtmfmazLLR/bfey4mP8v/R5zCIUK7obcUrF2d6CWUMvKKUorQqYZNu1YfRZsGlp/F96CAQhSGomJC7oJa3PktwoW5J1Oti/y2v4+b5+vN8yLIj1trS7p1l341Jf66AjaxnoFPplwLqE=", "BF5u1td9ugoacDabyfVzoTxPBxGNtmXuGV7AFcO1GLmXkXIKlBcAcelvaTKIbmaA6lXwZCJCSeWDHJOirHiEl1LtR8lCt+1ISttWuvpJ6sPx3Y/QxTajYzxZfQb6nCGkv+8cczX0PrqKKwOn/Elf9kpQQCXeMglunT09H2B4HfRs7uuI");
```

>  In order to prevent other users from using your exact encrypted query ("replay attacks"), the first contract querying Oraclize with a given encrypted query becomes its rightful "owner". Any other contract using that exact same string will receive an empty result. As a consequence, remember to always generate a new encrypted string when re-deploying contracts using encrypted queries.

> 為了防止其他用戶使用你加密後的內容值做回放攻擊，第一個使用這個加密資料的人，將成為法和的 owner，其他使用完全相同加密字串做 query 的人，會收到空值。因此，請記住在使用加密查詢重新部署合約時，永遠要產生新的加密字串。

>  The security guarantee mentioned above is only valid on the mainnet, not on the testnet. For more information get in touch with info@oraclize.it.

> 上面所描述的安全機制，只在主網有效，測試網無效。若要取得更多的訊息，請與 info@oraclize.it 連繫。

To protect the plaintext queries, an Elliptic Curve Integrated Encryption Scheme was chosen. The steps performed for the encryption are the following ones:

為了保護明文查詢，選擇 Elliptic Curve Integrated Encryption Scheme，執行步驟如下：

* An Elliptic Curve Diffie-Hellman Key Exchange (ECDH), which uses secp256k1 as curve and ANSI X9.63 with SHA256 as Key Derivation Function. This algorithm is used to derive a shared secret from the Oraclize public key and ad-hoc, randomly generated developer private key.

ECDH 使用 secp256k1 作為曲線，ANSI X9.63 使用 SHA256 作為密鑰導出函式。此算法用於 Oraclize 公鑰和 ad-hoc 和隨機產生亂數的開發人員私鑰。

* The shared secret is used by an AES-256 in Galois Counter Mode (GCM), an authenticated symmetric cipher, to encrypt the query string. The authentication tag is 16-bytes of length and the IV is chosen to be '000000000000' (96 bits of length). The IV can be set to the zero byte-array because each shared secret is thrown-away and use only once. Every time the encryption function is called a new developer private key is re-generated. The final ciphertext is the concatenation of the encoded point (i.e the public key of the developer), the authentication tag and the encrypted text.

// TODO 暫時先跳過

### 計算資料來源 (Computation Data Source)

#### Passing Arguments to the Package

Arguments can be passed to the package by adding parameters to the query array. They will be accessible from within the Docker instances as environmental parameters.

可以透過 array 將資料傳給函式。它將成為 Docker instances 的環境變數參數。

Currenty the API supports up to 5 inline arguments, including the IPFS Hash:

包含 IPFS Hash 在內，目前 API 最多可以支持 5 個參數：

```js
oraclize_query("computation",["QmZRjkL4U72XFXTY8MVcchpZciHAwnTem51AApSj6Z2byR", _firstOperand, _secondOperand, _thirdOperand, _fourthOperand]);
```

#### 傳遞超過 5 以上的參數 (Passing more than 5 Arguments)

In case you need to pass more arguments, you will need to send a manually set dynamic string/bytes array, for example:

如果你需要傳遞超過 5 個參數，你需要手動宣告 string 或 bytes 型態的動態陣列，如下面的範例所示：

```js
string[] memory myArgs = new string[](6);
myArgs[0] = "MYIPFSHASH";
// ...
myArgs[5] = "LAST ARG";
```

The query would then look like this: `oraclize_query("computation", myArgs)`

#### Passing Encrypted Arguments

Encrypted arguments can be passed using the nested and the decrypt meta data sources, as shown in the example at the right.

你可以使用 nested 和 the decrypt meta data sources 來傳遞加密參數，如下面範例所示：

```js
pragma solidity ^0.4.18;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract Calculation is usingOraclize {

    string NUMBER_1 = "33";
    string NUMBER_2 = "9";
    string MULTIPLIER = "5";
    string DIVISOR = "2";

    event LogNewOraclizeQuery(string description);
    event calculationResult(uint _result);

    // General Calculation: ((NUMBER_1 + NUMBER_2) * MULTIPLIER) / DIVISOR

    function Calculation() {
        oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS); 
    }

    function __callback(bytes32 myid, string result, bytes proof) {
        require (msg.sender == oraclize_cbAddress());
        calculationResult(parseInt(result));
    }

    function testCalculation() payable {
        sendCalculationQuery(NUMBER_1, NUMBER_2, MULTIPLIER, DIVISOR); // = 105
    }

    function sendCalculationQuery(string _NUMBER1, string _NUMBER2, string _MULTIPLIER, string _DIVISOR) payable {
        if (oraclize.getPrice("computation") > this.balance) {
            LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
        } else {
            LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
            oraclize_query("computation",["QmZRjkL4U72XFXTY8MVcchpZciHAwnTem51AApSj6Z2byR", 
            _NUMBER1, 
            _NUMBER2, 
            _MULTIPLIER, 
            _DIVISOR]);
        }
    }
}
```

**Content of the Dockerfile**

```yaml
# Content of the Dockerfile

FROM frolvlad/alpine-python3
MAINTAINER Oraclize "info@oraclize.it"

COPY calculation.py /

RUN pip3 install requests
CMD python ./calculation.py
# Content of the Python File

import os
import random

result = ((int(os.environ['ARG0']) + int(os.environ['ARG1'])) * int(os.environ['ARG2'])) / int(os.environ['ARG3'])

print(result)
```


```js
pragma solidity ^0.4.18;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract Calculation is usingOraclize {

  event calculationResult(uint _result);
  event LogNewOraclizeQuery(string description);

  function Calculation() payable {
    oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);

    testCalculation("QmeSVrmYimykzzHq9gChwafjQj7DQTyqvkf6Sk92eY3pN3",
    "33", "9", "5", "2", "12", "2");
  }

  // (((NUMBER_1 + NUMBER_2) * MULTIPLIER) / DIVISOR) + NUMBER_3 - NUMBER_4 = 115

  function __callback(bytes32 myid, string result, bytes proof) {
    require (msg.sender == oraclize_cbAddress());
    calculationResult(parseInt(result));
  }

  function testCalculation(
    string _hash,
    string _number1,
    string _number2,
    string _multiplier,
    string _divisor,
    string _number3,
    string _number4) public payable {

    string[] memory numbers = new string[](7);
    numbers[0] = _hash;
    numbers[1] = _number1;
    numbers[2] = _number2;
    numbers[3] = _multiplier;
    numbers[4] = _divisor;
    numbers[5] = _number3;
    numbers[6] = _number4;

    sendCalculationQuery(numbers);
  }

  function sendCalculationQuery(string[] array) internal {
    if (oraclize.getPrice("computation") > this.balance) {
        LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
    } else {
        LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
        oraclize_query("computation", array);
    }
  }
}
```

```js
pragma solidity ^0.4.11;
import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";

contract ComputationTest is usingOraclize {

    event LogConstructorInitiated(string nextStep);
    event LogNewOraclizeQuery(string description);
    event LogNewResult(string result);

    function ComputationTest() payable {
        LogConstructorInitiated("Constructor was initiated. Call 'update()' to send the Oraclize Query.");
    }

    function __callback(bytes32 myid, string result) {
        if (msg.sender != oraclize_cbAddress()) revert();
        LogNewResult(result);

    }

    function update() payable {
        LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
        oraclize_query("nested", "[computation] ['QmaqMYPnmSHEgoWRMP3WSrUYsPWKjT85C81PgJa2SXBs8u', \
'Example of decrypted string', '${[decrypt] BOYnQstP700X10I+WWNUVVNZEmal+rZ0GD1CgcW5P5wUSFKr2QoIwHLvkHfQR5e4Bfakq0CIviJnjkfKFD+ZJzzxcaFUQITDZJxsRLtKuxvAuh6IccUJ+jDF/znTH+8x8EE1Tt9SY7RvqtVao2vxm4CxIWq1vk4=}', 'Hello there!']");
    }

}
```

### Random Data Source

In the contract usingOraclize, which smart contracts should use to interface with Oraclize, some specific functions related to the Oraclize Random Data Source have been added. In particular:



* `oraclize_newRandomDSQuery`: helper to perform an Oraclize random DS query correctly
    * `oraclize_randomDS_setCommitment`: set in the smart contract storage the commitment for the current request
    * `oraclize_randomDS_getSessionPubKeyHash`: recovers the hash of a session pub key presents in the connector

* `oraclize_randomDS_proofVerify_main`: performs the verification of the proof returned with the callback transaction
    * `oraclize_randomDS_sessionKeyValidity`: verify that the session key chain of trust is valid and its root is a Ledger Root Key
    * `matchBytes32Prefix`: verify that the result returned is the sha256 of the session key signature over the request data payload

For advance usage of Random Data Source, it is recommended to read the following section.

> The random datasource is currently available on the Ethereum mainnet and on all Ethereum public testnets only (Rinkeby, Kovan, Ropsten-revival) - it is not integrated yet with private blockchains/testrpc/browser-solidity-vmmode.