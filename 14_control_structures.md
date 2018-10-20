# 表達示與流程控制 (Expressions and Control Structures)

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

除了 `switch` 和 `goto` 之外，其他在 `Javascript` 可用的流程控制在 `Solidity` 都可以使用。

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

```js
if (1) { 
  // ... 
}
```

### 函示呼叫 (Function Calls)

**呼叫內部函式 (Internal Function Calls)**

```js
contract Math {
  function f1(uint a) returns (uint) { return f(a); }
  function f2(uint a) returns (uint) { return a * a}
}
```

**呼叫外部函示 (External Function Calls)**

```js
pragma solidity ^0.4.0;

contract InfoFeed {
  function info() returns (uint ret) { return 42; }
}
contract Consumer {
  InfoFeed feed;
  function setFeed(address addr) { feed = InfoFeed(addr); }
  // 在呼叫外部函示時，可以指定發送的貨幣數量跟 gas
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

發生例外會傳回剩餘未使用的 gas，回復所有狀態，常用於檢查前置條件。

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

**assert**

發生例外會傳回剩餘未使用的 gas，回復所有狀態，常用於驗證輸入值的邊界條件檢查。

**throw**

發生異常錯誤會消耗所有 gas，沒有例外資訊，會回復所有狀態。

> 從 0.4.13 開始 `throw` 已被棄用，未來將會被移除，可改用 `revert`。