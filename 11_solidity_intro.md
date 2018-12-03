# 介紹 Solidity 語言

![](https://upload.wikimedia.org/wikipedia/commons/thumb/9/98/Solidity_logo.svg/200px-Solidity_logo.svg.png)

`Solidity` 是一種合約式導向的程式語言，用來撰寫智能合約，它受到 C++、Python 和 Javascript 語言影響，語法設計參考了 `ECMAScript`，所以對於寫過 Javascript 的人，相對好上手。

Solidity 是靜態型語言，編譯後可以在 `EVM` 上執行。撰寫以太坊的智能合約，除了可以用 Solidity 語言，還有 [Vyper](https://github.com/ethereum/vyper) 語言可以選擇。

> `EVM` (Ethereum Virtual Machine)：中文翻譯為「以太坊虛擬機」，是智能合約的運行環境。

Solidity 語言仍處於持續開發階段，變動非常的頻繁，需要注意各個版本不同的語法差異。目前 `0.5.0` 版已發佈，但是目前網路上的資料大部分還是 `0.4.x` 版的，所以我們使用的使用範例的語法，還是採取與`0.4.25` 版本相容為主。

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/11_contributors.png)

#### 最基本的完整智能合約

我們先從最基本的合約範例說起，合約程式碼的第一行一定是 `pragma` 開頭，它是用來告訴編譯器，如何編譯我們所撰寫的原始碼，`^0.4.0` 指的是最低可接受用 0.4.0 版來編譯。

`contract` 是保留字，用法類似於其他程式語言的 `class`。除此之外，還有 `view`、`payable`、`constant`、`pure` 等都是保留字，將在接下來的篇幅逐一介紹它們的用途。

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

**建構子沒有帶參數**

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

#### 合約的更多應用範例

```js
// 建立合約實例
Example example = new Example("alincode");
// 將合約實例轉換成位址
address(this);
// 毀掉合約，並把合約裡面的所有錢轉給指定的人。
selfdestruct(ownerAddress);
```

#### 參考來源

* Solidity - 維基百科：<https://zh.wikipedia.org/wiki/Solidity>
* Solidity 0.4.25 官方文件：<http://solidity.readthedocs.io/en/v0.4.25/>
* Solidity 語法速查表 by TOPMONKS：<https://topmonks.github.io/solidity_quick_ref/>