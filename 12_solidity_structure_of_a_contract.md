# Solidity - 合約的結構

`contract` 語法類似於物件導向程式語言的 `class`，而且也可以使用一般繼承跟多重繼承。

### 狀態變數 (State Variables)

狀態變數是用來在區塊鏈上保存值

```js
pragma solidity ^0.4.25;

contract Example {
    string message; // 狀態變數
}
```

### 函式 (Functions)

函式可以被執行

```js
pragma solidity ^0.4.25;

contract Example {
    function hello() public {}
}
```

### 修飾函式 (Function Modifiers)

使用情境：

* 重複性的前置條件檢查
* 切割多個 require

語法
```
modifier name([argument, ...]) { ... _; ... }
```

範例一
```js
// 宣告
modifier onlyOwner {
  require(msg.sender == owner);
  _; // 標示哪裡會呼叫函式
}

// 使用
function giveMeMomey() public onlyOwner {}
```

範例二
```js
// 宣告
modifier onlyOwner(address addr) {
  require(address == owner);
  _;
}

// 使用
function giveMeMomey() public onlyOwner(msg.sender) {}
```

完整範例

```js
pragma solidity ^0.4.25;

contract Example {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function giveMeMomey() public onlyOwner {
    }
}
```

### 事件 (Events)

DApp 經常聆聽智能合約的事件，來進行非同步頁面更新。

語法
```
// 宣告
event name([argument, ...]) [anonymous]; 

// 呼叫
emit name([argument, ...]);
```

範例
```js
// 宣告
event FundTransfer(address indexed to, uint value); 

// 呼叫
emit FundTransfer(someAddress, 100);
```

參數宣告若添加 `indexed` 則代表之後這個值，可以被使用來 filter，反之則無法被使用來 filter。

**完整範例**

```js
pragma solidity ^0.4.25;

contract Example {
    event Log(string message);

    function hello() public {
        emit Log('Hello World');
    }
}
```

### 結構型別 (Struct)

結構 (Struct) 可以將自訂的不同資料型態綁一起，使值更加結構化。C 語言也有一樣的語法。

```js
pragma solidity ^0.4.25;

contract Example {
    struct User {
        string name;
        uint age;
        uint height;
        uint weight;
    }
}
```

### 列舉型別 (Enum)

```js
pragma solidity ^0.4.25;

contract Contest {
    State state = State.Start;
    enum State { Start, Pending, End }

    function getState() view returns (uint) {
        return uint(state);
    }
}
```