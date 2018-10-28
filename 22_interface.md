# 介面

介面 (interface) 與抽象合約相似，但它不能實作任何功能，還有以下限制：

* 介面不能繼承其他合約或介面
* 介面不能定義建構子 (constructor)
* 介面不能定義變數 (variable)
* 介面不能定義結構型別 (struct)
* 介面不能定義列舉型別 (enum)

可以透過 `interface` 關鍵字來宣告介面，如下面範例所示：

```js
pragma solidity ^0.4.11;

interface Token {
    function transfer(address recipient, uint amount) public;
}
```

合約可以繼承介面 (interface)，也可以繼承其他合約。介面常用於定義標準，例如 `ERC-20` 是定義代幣 (Token) 標準。

> ERC 是 `Ethereum Request for Comments` 的縮寫，是以太坊開發者提案公開徵求意見，希望定義出統一的溝通介面，建立出一套可以遵循的標準。

只要實作下面定義的這些函示，就可以建立符合 `ERC-20` 標準自己專屬的代幣。

```js
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
interface ERC20Interface {
    
    // 取得所有的代幣供應量
    function totalSupply() public constant returns (uint);
    // 查詢餘額
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    // 取得 tokenOwner 批准給 spender 的代幣數量
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    // 轉移代幣至 to 位址
    function transfer(address to, uint tokens) public returns (bool success);
    // 批准
    function approve(address spender, uint tokens) public returns (bool success);
    // 將代幣從 from 位址轉移到 to 位址
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    // 轉移事件
    event Transfer(address indexed from, address indexed to, uint tokens);
    // 同意事件
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
```

> EIPs：全名 `Ethereum Improvement Proposal`，以太坊改進提案，