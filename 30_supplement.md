# 附錄

### Ganache

提供快速的開發測試環境，啟動時自動創建十組帳號，資料僅暫時在記憶體中，程式關掉後資料就會消失。

圖形化介面

<https://truffleframework.com/ganache>

![](https://truffleframework.com/img/ganache-window.png)

命令提示介面

```
// 安裝
npm install -g ganache-cli
// 執行
ganache-cli
```

### 工具函式庫

目前 Solidity 生態系中，還沒有官方的套件管理工具，只能到處搜刮別人的作品，這邊列出幾個大家常用的工具函式庫。

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

* 一些常用的工具型函式庫
* 測試涵蓋率達 98%
* 原始碼：<https://github.com/modular-network/ethereum-libraries>

```
.
├── ArrayUtilsLib
├── BasicMathLib
├── CrowdsaleLib
├── LinkedListLib
├── StringUtilsLib
├── TokenLib
├── VestingLib
├── WalletLib
```

### 語法變動

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

### 已棄用的語法 (Deprecations)

* 函式修飾標記 constant，用 view 來取代。
* year：時間單位
* throw 改用 revert
* `block.blockhash(block_number);` 被 `blockhash(block_number);` 取代
* msg.gas 被 gasleft() 取代
* suicide 被 selfdestruct(address) 取代
* keccak256(a, b)
* callcode

想要追蹤 Solidity 的最新動態，最好的方法當然就是查看官方的更動文件了。

<https://github.com/ethereum/solidity/blob/develop/Changelog.md>