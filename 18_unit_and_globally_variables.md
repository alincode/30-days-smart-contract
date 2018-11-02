# 單位和全域變數

<!-- <https://solidity.readthedocs.io/en/v0.4.25/units-and-global-variables.html> -->

### 貨幣單位 (Ether Units)

在數字的後面加上 `wei`、`finney`、`szabo` 或 `ether` 轉換為貨幣的單位，如果沒有指定，基礎單位就是 `wei`。

```js
2 ehter == 2000 finney
```

### 時間單位 (Time Units)

在數字的後面加上 `seconds`、`minutes`、`hours`、`days`、`weeks`、`years` 轉換為時間單位，如果沒有指定，基礎單位就是秒。

關於時間單位的比較：
* `1 == 1 seconds`
* `1 minutes == 60 seconds`
* `1 hours == 60 minutes`
* `1 days == 24 hours`
* `1 weeks == 7 days`
* `1 years == 365 days`

請小心的使用時間單位，因為有[閏秒](https://zh.wikipedia.org/wiki/%E9%97%B0%E7%A7%92) (leap seconds)，由於無法預測什麼時候發生閏秒，如果你需要使用精確的時間，需要透過外部函式庫來取得。

> 由於上述原因，`years` 被棄用了

**範例**

```js
function f(uint start, uint daysAfter) public {
    uint afterAt = start + daysAfter * 1 days; (正確的用法)
    uint afterAt = start + daysAfter days; (錯誤的用法)
}
```

### 特殊變數和函式

一些特別的變數和函式，提供有關區塊鏈的資訊和常用工具函式，存取範圍是全域的。

#### 區塊和 Transaction 屬性

* block.blockhash(uint blockNumber)：區塊的 hash 值，只能用在最近的 256 各區塊，0.4.22 版之後被 `blockhash(uint blockNumber)` 取代。
* block.coinbase (address): 目前的區塊礦工的位址
* block.difficulty (uint): 目前的區塊難度
* block.gaslimit (uint): 目前區塊的 gas limit
* block.number (uint): 目前區塊的編號
* block.timestamp (uint): 目前區塊的時間戳
* gasleft() returns (uint256): 剩餘 gas
* msg.data (bytes): 完整的 calldata
* msg.gas (uint): 剩餘的 gas，0.4.21 版後被廢棄，由 `gasleft()` 取代。
* msg.sender (address): 發送訊息給函式的位址
* msg.sig (bytes4): calldata 的前四個 bytes (例如 function identifier)
* msg.value (uint): 發送多少以太幣(單位是 wei)
* now (uint): `block.timestamp` 的暱稱
* tx.gasprice (uint): transaction 的 gas price
* tx.origin (address): transaction 的發送者
  
<!-- * tx.origin (address): sender of the transaction (full call chain) -->

<!-- > The values of all members of msg, including msg.sender and msg.value can change for every external function call. This includes calls to library functions. -->

> 不要倚賴 `block.timestamp`、`now` 或 `blockhash` 當作隨機亂數的來源，除非你知道你在做什麼。區塊的時間戳和 hash 都某種程度受到礦工的影響，如果你拿這兩個值作為博弈應用，可能會被社群中居心不良的礦工破解。

<!-- > The current block timestamp must be strictly larger than the timestamp of the last block, but the only guarantee is that it will be somewhere between the timestamps of two consecutive blocks in the canonical chain. -->

<!-- > The block hashes are not available for all blocks for scalability reasons. You can only access the hashes of the most recent 256 blocks, all other values will be zero. -->

#### ABI Encoding Functions

* abi.encode(...) returns (bytes): ABI-encodes the given arguments
* abi.encodePacked(...) returns (bytes): Performes packed encoding of the given arguments
* abi.encodeWithSelector(bytes4 selector, ...) returns (bytes): ABI-encodes the given arguments
* starting from the second and prepends the given four-byte selector
* abi.encodeWithSignature(string signature, ...) returns (bytes): Equivalent to abi.encodeWithSelector(bytes4(keccak256(signature), ...)

> These encoding functions can be used to craft data for function calls without actually calling a function. Furthermore, keccak256(abi.encodePacked(a, b)) is a more explicit way to compute keccak256(a, b), which will be deprecated in future versions.

See the documentation about the ABI and the tightly packed encoding for details about the encoding.

#### 錯誤處理 (Error Handling)

* `assert(bool condition)`：如果條件不滿足，transaction 會失敗，使用於內部錯誤。
* `require(bool condition)`：如果條件不符合，狀態會被還原，使用於輸入值得錯誤或外部元件。
* `require(bool condition, string message)`：同上，但可以自訂的錯誤訊息。
* `revert()`：執行會被終止，並回復到修改前的狀態。
* `revert(string reason)`：同上，但可以自訂錯誤訊息。

**範例**

```js
require(owner != msg.sender);
require(owner != msg.sender, "no permission");
revert();
revert("OMG");
```

#### 數學和加密函式

* `addmod(uint x, uint y, uint k) returns (uint)`：加法，支援的版本 0.5.0 開始。
* `mulmod(uint x, uint y, uint k) returns (uint)`：乘法，支援的版本 0.5.0 開始。
* `keccak256(...) returns (bytes32)`：計算傳入值的 Ethereum-SHA-3 (Keccak-256) hash，使用 tightly packed。
* `sha256(...) returns (bytes32)`：計算傳入值的 SHA-256 hash，使用 tightly packed。
* `sha3(...) returns (bytes32)`：keccak256 的別名
* `ripemd160(...) returns (bytes20)`：計算傳入值的 RIPEMD-160 hash，使用 tightly packed。
* `ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) returns (address)`

<!-- recover the address associated with the public key from elliptic curve signature or return zero on error (example usage) -->

> `tightly packed` 的意思是，計算時，會自動去掉空白 (padding)。

以下內容的值，完全相同。

```js
keccak256("ab", "c")
keccak256("abc")
keccak256(0x616263)
keccak256(6382179)
keccak256(97, 98, 99)
```

If padding is needed, explicit type conversions can be used: `keccak256("\x00\x12")` is the same as `keccak256(uint16(0x12))`.

Note that constants will be packed using the minimum number of bytes required to store them. This means that, for example, `keccak256(0) == keccak256(uint8(0))` and `keccak256(0x12345678) == keccak256(uint32(0x12345678))`.

It might be that you run into Out-of-Gas for `sha256`, `ripemd160` or `ecrecover` on a private blockchain. The reason for this is that those are implemented as so-called precompiled contracts and these contracts only really exist after they received the first message (although their contract code is hardcoded). Messages to non-existing contracts are more expensive and thus the execution runs into an Out-of-Gas error. A workaround for this problem is to first send e.g. 1 Wei to each of the contracts before you use them in your actual contracts. This is not an issue on the official or test net.

#### 位址相關

* `<address>.balance (uint256)`：餘額，值得單位是 `wei`。
* `<address>.transfer(uint256 amount)`：轉錢給指定位址，值的單位是 `wei`，如果失敗會拋出錯誤訊息，需花費 2300 gas，gas 的設定不能調整。
send given amount of Wei to Address, throws on failure, forwards 2300 gas stipend, not adjustable
* `<address>.send(uint256 amount) returns (bool)`:
send given amount of Wei to Address, returns false on failure, forwards 2300 gas stipend, not adjustable
* `<address>.call(...) returns (bool)`:
issue low-level CALL, returns false on failure, forwards all available gas, adjustable
* `<address>.callcode(...) returns (bool)`:
issue low-level CALLCODE, returns false on failure, forwards all available gas, adjustable
* `<address>.delegatecall(...) returns (bool)`:
issue low-level DELEGATECALL, returns false on failure, forwards all available gas, adjustable

For more information, see the section on Address.

> 警告：There are some dangers in using send: The transfer fails if the call stack depth is at 1024 (this can always be forced by the caller) and it also fails if the recipient runs out of gas. So in order to make safe Ether transfers, always check the return value of send, use transfer or even better: Use a pattern where the recipient withdraws the money.

> If storage variables are accessed via a low-level delegatecall, the storage layout of the two contracts must align in order for the called contract to correctly access the storage variables of the calling contract by name. This is of course not the case if storage pointers are passed as function arguments as in the case for the high-level libraries.

> 不建議使用 `callcode`，未來將會被廢棄。

#### 合約相關

* `this`：指當前的合約，可轉換為合約的地址。
* `selfdestruct(address recipient)`：銷毀目前合約，並把合約裡的錢轉到指定的位址。
* suicide(address recipient)：`selfdestruct` 的別名，已被廢棄不推薦使用。

**範例**

```js
address(this);
selfdestruct(0xa77451687Ee77cB3DFf16A24446C54DB76C80222);
```

<!-- Furthermore, all functions of the current contract are callable directly including the current function. -->｀