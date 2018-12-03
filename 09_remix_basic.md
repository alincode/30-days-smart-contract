# 線上版 IDE 之 Remix 基礎篇

我們現在來準備開發環境吧！為了免除一開始的進入障礙，以太坊非常佛心的提供了線上版的官方 IDE 叫 `Remix`。除了 Remix 之外，也可以使用你習慣的 IDE 來開發，例如 VS Code、ATOM 等等。

* [Solidity - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=JuanBlanco.solidity)
* [Etheratom](https://atom.io/packages/etheratom)：ATOM 的 Solidity Plugin
* Remix
    * 線上 IDE：<http://remix.ethereum.org>
    * 線上 IDE alpha 版本：<https://remix-alpha.ethereum.org>
    * Github：<https://github.com/ethereum/remix-ide>
    * 文件：<https://remix.readthedocs.io/en/latest/>

**區塊說明**

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/09/remix.png)

* 左側：檔案總管 (File Explorer)
    * 新增檔案
    * 開啟檔案
    * 發佈程式碼至 Github gist
    * 更新至 Github gist
    * 刪除檔案
* 中間：編輯區 (Editor)
* 右側：諸多功能之頁籤
    * 編譯 (Compile)
    * 執行 (Run)
    * 分析 (Analysis)
    * 測試 (Testing)
    * 除錯 (Debugger)
    * 設定 (Setting)
    * 支援 (Support)
* 下方：主控台 (Terminal)

### 編譯頁籤 (Compile)

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/09/remix_compile_tab.png)

1. 選擇編譯的版本
2. 自動編譯 (Auto compile)：如果你把這個選項打勾，每當程式碼有修改或其他條件會需要重新編譯的情況時，就會觸發自動編譯功能。建議使用本機版 Remix 時才勾起這個選項。
3. 隱藏警告訊息 (Hide warnings)：若出現黃色區塊的文字提示，代表是警告訊息，例如你使用未來會被 `deprecated` 的 Solidity 語法。
4. 手動編譯 (Start to compile)：若你沒勾選自動編譯功能，代表每次變動後都必須要手動按這個按鈕，才能確認編譯的結果。
5. `ABI` (Application Binary Interface)
   * ABI 裡記載了智能合約提供哪些函式，以及應該要傳入什麼樣的參數。
   * 當你要開發 DApp 時，需要兩個值，才能跟智能合約溝通，一個是合約位址，另一個就是一個是 ABI 了。
6. 選擇合約：你可能有兩個以上的合約，在這種情況下記得要選擇合約，複製出來的 ABI 或 `Bytecode` 才會是對的。

### 執行頁籤 (Run)

這個頁籤涵蓋「發佈合約」跟「執行合約」

1. Environment：執行環境
2. Account：帳戶
3. Gas limit：Gas 使用量最高限制
4. Value：轉入智能合約的以太幣金額，前面的欄位是值，後面的欄位是單位。
5. 選擇要發佈的合約
6. Deploy 按鈕
7. At Address 按鈕：載入已發布的合約。若是想載入之前已經發佈過的智能合約，透過 `Remix` 介面來跟智能合約做互動，則可以把合約位址複製到 `Load contract from Address` 欄位中，然後按下 `At Address` 藍色按鈕。結果會出現在 `Deployed Contracts` 區塊中。
8. Deployed Contracts

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/09/remix_run_tab.png)

#### Environment

* `JavaScript VM` 環境：資料只存在記憶體中，並沒有連接到任何一個節點，內建五個測試帳戶，每個帳戶中都有 100 Ether 供開發使用。
* `Injected Web3` 環境：與 MetaMask 連接或類似 MetaMask 的服務
* `Web3 Provider` 環境：指定要連結的節點位址，例如：本機的私網路 `http://localhost:8545`。

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/09/environment.png)

選擇 Web3 Provider 環境會跳出彈跳視窗，這裡可以指定 RPC 伺服器的位置。如下圖所示：

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/09/web3_provider.png)

#### Deploy (發佈合約)

選擇完要發佈的智能合約之後，就可以按下 `Deploy` 按鈕，就會建立一個智能合約的實例 (instance)。

練習題：試著把下面的內容複製到 `Remix`，並進行智能合約的編譯、發佈、執行，來驗證自己到底吸收了多少吧。


```js
pragma solidity ^0.4.17;

contract SimpleStorage {
    uint storedData;
    
    function set(uint x) public {
        storedData = x;
    }

    function get() public view returns (uint) {
        return storedData;
    }
}
```

#### Deployed Contracts 區塊

發佈前

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/09/deployed_contracts1.png)

成功發佈後

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/09/deployed_contracts2.png)

這時候你可以使用它來呼叫智能合約的函式了。

**呼叫 `set` 函式**

記得如果要傳入字串，需要使用雙引號包起來，例如 `"HelloWorld"` 。不過這裡的範例允許傳入的是數字，就不用特別用雙引號包起來了。

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/09/set.png)

**呼叫 `get` 函式**

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/09/get.png)

## 主控台

用指令載入合約

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/09/loadurl.png)

使用範例

```
remix.loadgist('1b87ded5087790b67b5c4cd90a68065f')

remix.loadurl("https://github.com/alincode/30-days-smart-contract/src/01.sol")
```

#### 參考資料

* ABI Spec 文件：<https://solidity.readthedocs.io/en/develop/abi-spec.html>