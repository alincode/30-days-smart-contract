# Solidity - 合約的結構

`contract` 這個語法類似於物件導向程式語言的 `class`，而且也可以使用繼承的觀念。

### 狀態變數 (State Variables)

狀態變數值會永久保存

```js
pragma solidity ^0.4.25;

contract Example {
    string message; // 狀態變數
}
```

### 函示 (Functions)

函示可以被執行

```js
pragma solidity ^0.4.25;

contract Example {
    function hello() public {}
}
```

### 修飾函示 (Function Modifiers)

常用於可重複使用的條件檢查

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

DApp 經常整合智能合約的事件，來進行非同步頁面更新。

```js
pragma solidity ^0.4.25;

contract Example {
    event Log(string message);

    function hello() public {
        emit Log('Hello World');
    }
}
```

### Struct 型別

Struct 可以將值結構化，類似 `View Model`。

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
    enum State { Start, Pending, End }
}
```