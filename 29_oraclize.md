
### Getting Started


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

伺服器端與區塊鏈的溝通方式

Oracle可以透過監聽特定Event來接收合約所發出的Query，處理完成之後，再由Oracle主動呼叫合約的 callback function將資料回傳即可。

* [Oraclize-based Ðapps](http://dapps.oraclize.it/)

｀
user bet callback (555176 gas)

https://rinkeby.etherscan.io/tx/0x4b85865921dd077a2a9cde9821b8a2e3f2dc43123deba09b8beffabd558b9390

fetch step (60951 gas)

https://rinkeby.etherscan.io/tx/0x359af9c70e93294db0def5b15d49bf96b4dd2002587adc98c199907fbe6caaeb

fund (186113 gas)

https://rinkeby.etherscan.io/tx/0xf41240cf25d8c59018bf32b05e59168cb92e805de442e740fd733e4b3e3ff1a7


<https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol>
<https://github.com/oraclize/ethereum-api/issues/20>

<http://app.oraclize.it/home/test_query>

---


```js
// datasource = "computation"
// string[] = [ _query, _method, _url, _encryptHeader ];
function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
    uint price = oraclize.getPrice(datasource, gaslimit);
    if (price > 1 ether + tx.gasprice * gaslimit) return 0; // unexpectedly high price
    bytes memory args = stra2cbor(argN);
    return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
}
```