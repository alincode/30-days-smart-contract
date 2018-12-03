# Solidity 代碼檢查工具 - Solium

目前最常見的工具是 Solium 和 Solhint，因為 Solium 的星星比較多，那我們就先來介紹 Solium。

Solium 的功能有：
* 檢查語法錯誤
* 修正語法錯誤
* 檢查自訂的 code style 規則
* 基本的合約安全檢查

**第一步：安裝**

```sh
npm install -g solium
```

**第二步：初始化設定檔**

```
solium --init
```

執行後你就會在資料夾發現多了 `.soliumignore` 和 `.soliumrc.json`。.soliumignore 的作用是，忽略不需要檢查的檔案或目錄。.soliumrc.json 的作用則是 solium 的設定檔。

.soliumignore

```sh
node_modules
contracts/Migrations.sol
```
.soliumrc.json
```json
{
  "extends": "solium:recommended",
  "plugins": [ "security" ],
  "rules": {
    "quotes": [ "error", "double" ],
    "indentation": [ "error", 4 ]
  }
}
```

**第三步：執行檢查**

你可以先把一個最簡單的合約放進去檢查看看，將下面的原始碼內容新增到一個 hello.sol 檔案裡面。

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

執行

```
solium -f hello.sol
```

這時候它會顯示

```
No issues found.
```

你可以故意把第六行的 public 拿掉，在執行一次，然後你就可以看到下面的提示。

![](https://raw.githubusercontent.com/alincode/30-days-smart-contract/master/assets/solium/fix.png)

如果你有多個檔案，可以把它放在一個資料夾裡，例如 contracts 資料夾，然後執行。

```sh
solium -d contracts/
```

**第四步：修正錯誤**

執行下面指令後，你會看到 `No issues found.` 代表它已經幫你修正了。

```
solium -f hello.sol --fix
```

**所有指令清單**

```
Usage: solium [options] <keyword>

Linter to find & fix style and security issues in Solidity smart contracts.

Options:
  -V, --version                    查看 solium 的版本
  -i, --init                       建立預設設定檔
  -f, --file [filepath::String]    指定要檢查的合約檔案
  -d, --dir [dirpath::String]      指定要檢查的合約資料夾
  -R, --reporter [name::String]    指定檢查的回報格式 pretty 或 gcc
  -c, --config [filepath::String]  指定要用哪一個路徑位址的設定檔
  -, --stdin                       從 stdin 中讀取輸入的檔案
  --fix                            修復檢查到的問題 (盡量，非保證能修復)
  --debug                          顯示 debug 資訊
  --watch                          即時監看檔案變更
  --no-soliumignore                忽略查找 .soliumignore 檔
  --no-soliumrc                    忽略查找 .soliumrc 黨
  --rule [rule]                    指定要執行的規則，或覆蓋掉原本設定檔中的 rule 設定。
  --plugin [plugin]                指定要執行的外掛，或覆蓋掉原本設定檔中的 plugin 設定。
```

* Solhint：<https://github.com/protofire/solhint>
* Solium：<https://github.com/duaraghav8/Solium>