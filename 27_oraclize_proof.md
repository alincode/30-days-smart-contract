# Oraclize 真實性證明服務

真實性證明 (Authenticity Proof)

**Authenticity Proof Types​**

* TLSNotary Proof
* Android Proof
* Ledger Proof

**Storage and Delivery**

The authenticity proofs may be relatively large files.
the proof is uploaded and saved to IPFS, a decentralized and distributed storage system. 
IPFS, by itself, doesn't provide any long-term guarantees of persistency, however as part of Oraclize's infrastructures it runs the IPFS persistence consortium. 

```js
contract proofShieldExample is usingOraclize {

    event LogNewAuthenticatedResult(string);
    mapping (bytes32 => bool) public pendingQueries;

    function proofShieldExample() payable {
        oraclize_setProof(proofType_Android_v2 | proofShield_Ledger);
    }

    function __callback(bytes32 queryId, string result, bytes proof) {
        if (msg.sender != oraclize_cbAddress()) revert();

        if (oraclize_proofShield_proofVerify__returnCode(queryId, result, proof) != 0) {
            // the proof verification has failed
        } else {
            // the proof verification has passed
            require(pendingQueries[queryId] == true);
            delete pendingQueries[queryId];
            LogNewAuthenticatedResult(result);
        }
    }

    function sendQuery() payable {
        string memory query = "json(https://www.bitstamp.net/api/v2/ticker/ethusd/).last";
        bytes32 queryId = oraclize_query("URL", query);
        pendingQueries[queryId] = true;
    }

}
```

# Custom gas and price

![](assets/oraclize/price.png)

```js
oraclize_setCustomGasPrice(4000000000);

uint constant CUSTOM_GASLIMIT = 150000;

if (oraclize_getPrice("URL", CUSTOM_GASLIMIT) > this.balance)

oraclize_query(
    "URL", 
    "json(https://api.kraken.com/0/public/Ticker?pair=ETHXBT).result.XETHXXBT.c.0", 
    CUSTOM_GASLIMIT);
```
