# ERC

**ERC-20**

* <https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md>
* 以太坊代幣（Token）的標準

```js
contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

```

> ERC 是 `Ethereum Request for Comments` 的縮寫，是以太坊開發者提案公開徵求意見，希望定義出統一的溝通介面，建立出一套可以遵循的標準。

**ERC-223**

* <https://github.com/ethereum/EIPs/issues/223>
* 為了改善 ERC-20 的缺點

**ERC-721**

* <https://eips.ethereum.org/EIPS/eip-721>
* 建立的是一種「不可替換代幣」標準（NFT：全名 Non Fungible Token）
* 使用的範例
  * CryptoKitty

**ERC-777**

* <https://eips.ethereum.org/EIPS/eip-777>
* 新的進階 Token 標準
* 為了改善 ERC-20 的缺點

```js
interface ERC777Token {
    function name() public view returns (string);
    function symbol() public view returns (string);
    function totalSupply() public view returns (uint256);
    function balanceOf(address owner) public view returns (uint256);
    function granularity() public view returns (uint256);

    function defaultOperators() public view returns (address[]);
    function authorizeOperator(address operator) public;
    function revokeOperator(address operator) public;
    function isOperatorFor(address operator, address tokenHolder) public view returns (bool);

    function send(address to, uint256 amount, bytes data) public;
    function operatorSend(address from, address to, uint256 amount, bytes data, bytes operatorData) public;

    function burn(uint256 amount, bytes data) public;
    function operatorBurn(address from, uint256 amount, bytes data, bytes operatorData) public;

    event Sent(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 amount,
        bytes data,
        bytes operatorData
    );
    event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
    event Burned(address indexed operator, address indexed from, uint256 amount, bytes operatorData);
    event AuthorizedOperator(address indexed operator, address indexed tokenHolder);
    event RevokedOperator(address indexed operator, address indexed tokenHolder);
}

```
> EIPs：全名 `Ethereum Improvement Proposal`，以太坊改進提案，

### 延伸閱讀

* ERC：<https://eips.ethereum.org/erc>