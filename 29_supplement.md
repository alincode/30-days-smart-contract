# 補充篇

### 工具函式庫

目前 Solidity 生態系中，還沒有套件管理工具，只能到處搜刮別人的作品，這邊列出幾個大家常用的工具函式庫。

#### Basic string utilities for Solidity

* <https://github.com/Arachnid/solidity-stringutils>

**使用方式**

```js
import "github.com/Arachnid/solidity-stringutils/strings.sol";

contract Contract {
    using strings for *;
}
```

```js
var s = "abc".toSlice().concat("def".toSlice()); 
// "abcdef"
```

#### Open Zeppelin solidity

提供標準化可重用 (reuse) 的智能合約框架，代碼經過社群審核和測試，可降低應用程式中的漏洞風險。

* Github：<https://github.com/OpenZeppelin/openzeppelin-solidity>
* 文件：<https://openzeppelin.org/api/docs/get-started.html>

```sh
npm install --save-exact openzeppelin-solidity
```

#### Modular Libraries

* Github：<https://github.com/modular-network/ethereum-libraries>

### Coding Style 檢查工具

* Solhint：<https://github.com/protofire/solhint>
* Solium：<https://github.com/duaraghav8/Solium>

### 術語中英對照

| 英文                  | 中文    |
|---------------------|-------|
| account             | 帳戶    |
| account private key | 私鑰    |
| account public key  | 公鑰    |
| address             | 位址    |
| block               | 區塊    |
| blockchain          | 區塊鏈   |
| compile             | 編譯    |
| distributed ledger  | 分散式賬本 |
| ether               | 以太幣   |
| event               | 事件    |
| enum                | 列舉    |
| ethereum            | 以太坊   |
| function            | 函示    |
| faucet              | 水管    |
| interface           | 介面    |
| mnemonic code       | 助記碼   |
| mainnet             | 主網路   |
| public ledger       | 公開帳本  |
| proof               | 證明    |
| overloading         | 重載函式  |
| transaction         | 交易    |
| genesis block       | 創世區塊  |
| smart contract      | 智能合約  |
| state variable      | 狀態變數  |
| struct              | 結構    |
| visibility          | 可見度   |
| library             | 函式庫   |
