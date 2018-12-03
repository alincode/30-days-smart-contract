# 表達示與流程控制

 <!-- Expressions and Control Structures -->

### 輸入參數和輸出參數

**輸入參數**
```js
pragma solidity ^0.4.16;

contract Simple {
    function taker(uint _a, uint _b) public pure {
      // ...
    }
}
```

**輸出參數**

可以返回多個數值，這點跟其他程式語言非常不同。

```js
pragma solidity ^0.4.16;

contract Simple {
    function arithmetics(uint _a, uint _b)
        public
        pure
        returns (uint o_sum, uint o_product)
    {
        o_sum = _a + _b;
        o_product = _a * _b;
    }
}
```

```js
pragma solidity ^0.4.16;

contract Simple {
    function arithmetics(uint _a, uint _b)
        public
        pure
        returns (uint, uint)
    {
        o_sum = _a + _b;
        o_product = _a * _b;
        return (o_sum, o_product);
    }
}
```

### 流程控制

除了 `switch` 和 `goto` 之外，其他在 `Javascript` 語言可以用的流程控制，在 `Solidity` 都可以使用。

**if**

```
uint x = 10

if(x == 10) {

} else {

}
```

**for**

```js
for (uint x = 0; x < 10; x++) {

}
```

**while**

```
uint i = 0;

while (i < 10) {
  i++;
}
```

**不允許的用法**

這個在 Javascript 語言常使用的手法，在 Solidity 是不適用的。

```js
if (1) { 
  // ... 
}
```

### 函式呼叫 (Function Calls)

// TODO 添加一些解釋

**呼叫內部函式 (Internal Function Calls)**

呼叫同一個合約裡的函式

```js
contract Math {
  function f1(uint a) returns (uint) { return f(a); }
  function f2(uint a) returns (uint) { return a * a}
}
```

**呼叫外部函式 (External Function Calls)**

呼叫另一個合約的函式

```js
pragma solidity ^0.4.0;

contract InfoFeed {
  function info() returns (uint ret) { return 42; }
}
contract Consumer {
  InfoFeed feed;
  function setFeed(address addr) { feed = InfoFeed(addr); }

  // 在呼叫外部函式時，可以指定發送的貨幣數量跟 gas
  function callFeed() { feed.info.value(10).gas(800)(); }
}
```

**命名呼叫 (Named Calls)**

如果傳遞參數時，指定參數的名稱，就可以不用管參數的順序位置。

```js
pragma solidity ^0.4.0;

contract Example {
  function f(uint a, uint b, uint c) { 
    // ... 
  }
  function g() {
    f({c: 2, a: 3});
  }
}
```

<!-- TODO: Anonymous Function Parameters -->

<!-- TODO: Order of Evaluation of Expressions -->

### 錯誤處理 (Error handling)

**require**

使用針對外部傳入值驗證，可針對條件判斷，當發生 false 時，會傳回剩餘未使用的 gas，回復所有狀態，情境常用於前置條件檢查。

語法
```
require(condition,[message])
```

範例
```js
contract Example {
  function superPower() { 
    require(msg.sender == owner);
    // ...
  }
}
```

**revert**

終止執行，消耗所有 gas，回復所有狀態。

```
revert();
revert("Something bad happened");
```

完整範例

```js
contract Example {
  function superPower() { 
    if(msg.sender != owner) {
      revert();
    }
  }
}
```

**assert**

使用於內部狀態檢查，發生例外會傳回剩餘未使用的 gas，回復所有狀態，常用於驗證輸入值的邊界條件檢查。

**throw**

發生異常錯誤會消耗所有 gas，沒有例外資訊，會回復所有狀態。

> 從 0.4.13 開始 `throw` 已被棄用，未來將會被移除，可改用 `revert`。

#### 使用情境判斷

`require()` 應該是你去檢查條件的函式，`assert()` 只用在防止永遠不應該發生的情境。至於 `require()` 與 `revert()` 使用的差別，只在於你需不需要條件是判斷。


### 參考資料

* [Solidity Learning: Revert(), Assert(), and Require() in Solidity, and the New REVERT Opcode in the…](https://medium.com/blockchannel/the-use-of-revert-assert-and-require-in-solidity-and-the-new-revert-opcode-in-the-evm-1a3a7990e06e)