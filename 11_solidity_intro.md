# 介紹 Solidity 語言

![](https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/Solidity_logo.svg/200px-Solidity_logo.svg.png)

`Solidity` 是一種合約式導向的程式語言，用來撰寫智能合約，它受到 C++、Python 和 Javascript 語言影響，語法設計參考了 `ECMAScript`，所以對於寫過 Javascript 的人，相對好上手。

Solidity 是靜態型語言，編譯後可以在 `EVM` 上執行。撰寫以太坊的智能合約，除了可以用 Solidity 語言，還有 [Vyper](https://github.com/ethereum/vyper) 語言可以選擇。

![](assets/11_contributors.png)

Solidity 語言處於持續開發階段，變動非常的頻繁，需要注意各個版本不同的語法差異。以下所有範例的語法都相容 `0.4.25` 版本。

> `EVM` (Ethereum Virtual Machine)：中文翻譯為「以太坊虛擬機」，是智能合約的運行環境。

#### 語法變動

新舊版之間比較明顯的語法變動，如下：

* 從 0.4.21 版開始，呼叫 `event` 要加 `emit`。
* 從 0.4.22 版開始，建構子宣告方式改用 `constructor`，避免跟合約名稱有相依關係。

**舊版**
```js
pragma solidity ^0.4.20;

contract Example {
  event Log(string message);

  function Example() public {
    Log("Hello");
  }
}
```

**新版**
```js
pragma solidity ^0.4.25;

contract Example {
  event Log(string message);

  constructor() public {
    emit Log("Hello");
  }
}
```

#### 一個最基本的智能合約

我們先從最基本的合約範例說起，合約程式碼的第一行一定是 `pragma` 開頭，它是用來告訴編譯器，如何編譯我們所撰寫的原始碼，`^0.4.0` 指的是，最低可接受用 0.4.0 版的 Solidity 來編譯。

`contract` 是保留字，用法類似於其他程式語言的 `class`。除了 `contract` 之外，還有 `view`、`payable`、`constant`、`pure` 等都是保留字，會在接下來的篇幅逐步介紹它們的用途。

```js
pragma solidity ^0.4.0;

contract SimpleStorage {
  uint storedData;

  function set(uint x) public {
      storedData = x;
  }

  // returns 是有加 s，並非筆誤。
  function get() public view returns (uint) {
      return storedData;
  }
}
```

#### 宣告合約

建構子的用途是初始化程式一開始的狀態，在合約發佈時會立刻執行。智能合約不一定要有建構子，當不需時可省略。

**無建構子**

```js
pragma solidity ^0.4.25;

contract Example {
}
```

**建構子無參數**

```js
pragma solidity ^0.4.25;

contract Example {
  constructor() public {}
}
```

**建構子帶參數**

```js
pragma solidity ^0.4.25;

contract Example {
  string name;
  constructor(string _name) public {
    name = _name;
  }
}
```

#### 參考來源

* Solidity - 維基百科：<https://zh.wikipedia.org/wiki/Solidity>
* Solidity 0.4.25 官方文件：<http://solidity.readthedocs.io/en/v0.4.25/>