# 函式與修飾標記 (function)

函式是一個最小可被呼叫的元素

語法
```
function name([argument, ...]) [visibility] [view|pure] 
    [payable] [modifier, ...] [returns([argument, ...])]; 
```

可見度 (visibility) 有四種 public, private, internal, external，細節會在可見度的篇幅做進一步解釋。

範例
```js
function setName(string name) public { ... };
function getName() view public returns(string name) { ... };
function compute() private returns(int num1, int num2) { ... };
```

<!-- 修飾標記 view、pure、fallback 及重載函式 -->

## 函式的修飾標記

### view

當函式不修改任何狀態時，可以在函式宣告時標記 `view` 關鍵字。

以下的情境會修改狀態：

* 寫入或更改狀態變數的值
* 觸發事件
* 創建其他智能合約 (Creating other contracts.)
* 呼叫 `selfdestruct`
* 透過呼叫函式來發送 Ether
* 呼叫其他不是 `view` 或 `pure` 的函式
* 使用 low-level 的呼叫
<!-- * Using inline assembly that contains certain opcodes. -->

```js
pragma solidity ^0.4.16;

contract C {
    function f(uint a, uint b) public view returns (uint) {
        return a * (b + 42) + now;
    }
}
```

> `constant` 是 `view` 的別名

### pure

當函式不讀取或不修改狀態時，可以在函式宣告時標記 `pure` 關鍵字。

除了上面列表的情況之外，還要考慮以下情況：

* 讀取狀態變數
* 存取 `this.balance` 或 `<address>.balance.`
* 存取任何 `block`, `tx`, `msg` 物件裡的屬性 (除了 `msg.sig` 和 `msg.data` 是例外)
* 呼叫任何沒有標記 `pure` 的函式
<!-- * Using inline assembly that contains certain opcodes. -->

```js
pragma solidity ^0.4.16;

contract C {
    function f(uint a, uint b) public pure returns (uint) {
        return a * (b + 42);
    }
}
```

### payable

讓函式可以接收以太幣

```js
function fund(string _name) public payable {
    // ...
}
```

## fallback

合約可以有唯一個沒有函式名稱的函式，此函式不沒有參數，也不能返回值。如果在呼叫合約時，呼叫的函式名稱沒有比對到任何具名函式，這個函式就會被觸發。

除此之外，如果有人對於`合約地址`進行一般的轉帳作業，也會執行此函式。但為了要接收 Ether，函式必須要標記 `payable`，否則會無法接收 Ether。

<!-- Note that the gas required by a transaction (as opposed to an internal call) that invokes the fallback function is much higher, because each transaction charges an additional amount of 21000 gas or more for things like signature checking. -->

通常呼叫 `fallback` 函式，只會消耗掉少量的 gas (例如 2300 gas)，所以要盡量降低呼叫 `fallback` 函式的費用是非常重要的。

特別是以下操作，將消耗更多的 gas：

* 寫入值
* 建立一個合約 (Creating a contract)
* 呼叫會消耗大量 gas 的外部函式
* 發送 Ether

在部署你的合約之前，請測試你的 `fallback` 函式，確保它執行費用低於 `2300` gas。

> 雖然 `fallback` 函式規定不能有參數，但是你還是可以透過 `msg.data` 來取得資料。
> 如果你沒有宣告 `fallback` 函式，當有 `EOA` 帳戶轉錢給智能合約地址時，會直接直接拋出異常，並退回 Ether。

**情境一**

這個合約會自動收下所有 Ether 不會返回

```js
contract Sink {
    function() public payable { }
}
```

**情境二**

因為 `Test` 合約的 `fallback` 函式沒有標記 `payable`，所以合約會直接拋出異常，並退回 Ether。

```js
pragma solidity ^0.4.0;

contract Test {
    function() public { x = 1; }
    uint x;
}

contract Caller {
    function callTest(Test test) public {
        test.call(0xabcdef01);
    }
}
```

**情境三**

這個情境編譯會失敗，即使 `Caller` 合約送 Ether 到 `Test` 合約，因為 `Test` 合約沒有 `payable`，所以交易會失敗。

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/15_payable_error.png)

```js
pragma solidity ^0.4.0;

contract Test {
    function() public { x = 1; }
    uint x;
}

contract Caller {
    function callTest(Test test) public {
        test.send(2 ether);
    }
}
```

## 重載函式 (overloading)

只要參數數量不同，合約可以有多個同名函式。

**情境一**

```js
pragma solidity ^0.4.16;

contract A {
    function f(uint _in) public pure returns (uint out) {
        out = 1;
    }

    function f(uint _in, bytes32 _key) public pure returns (uint out) {
        out = 2;
    }
}
```

**情境二**

下面的範例，即使參數的型別不同，但參數的數量相同，還是無法編譯。

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/15_type_error.png)

```js
pragma solidity ^0.4.16;

contract A {
    function f(B _in) public pure returns (B out) {
        out = _in;
    }

    function f(address _in) public pure returns (address out) {
        out = _in;
    }
}

contract B {}
```
