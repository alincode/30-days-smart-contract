# 可見度 (Visibility) 和自動生成 getter 函式

Solidity 有兩種呼叫函式的方式，一是呼叫內部函式，二是呼叫外部函式。函式和狀態變數則有四種可見度。

<!-- what meaning "do not create an actual EVM call?" -->

函式可以指定為 `external`、`public`、`internal` 或 `private`，如果沒有指定預設為 `public`。狀態變數不可指定為 `external`，預設是 `internal`。

* 外部 (external)：外部函式是合約介面的一部份，它可以被其他合約呼叫，但不能被內部呼叫，除非使用 `this` 語法。適合使用在接收大量資料 (large arrays of data) 的時候。
* 公開 (public)：可接受內部呼叫或外部呼叫，會自動生成公開狀態的 `getter` 函式。
* 內部 (internal)：指定為 `internal` 的函式和狀態變數，只能在內部被存取，而且不需要使用 `this` 語法。
* 私有 (private)：私有函式和私有狀態變數的可見度範圍，僅在於宣告時所在的合約。

> 重要：不管設定哪種可見度，狀態變數值在區塊鏈中都是公開可被看到的，只是設定可見度為 `private` 時，會阻止其他合約存取或修改狀態變數的值。

下面的範例中，D 合約可以呼叫 `c.getData()`，以取得 C 合約的 data 值，但無法呼叫 C 合約的 f 函式。E 合約繼承 C 合約，因此可以呼叫 `compute` 函式。

```js
// 這個例子會編譯失敗

pragma solidity ^0.4.0;

contract C {
    uint private data;

    function f(uint a) private returns(uint b) { return a + 1; }
    function setData(uint a) public { data = a; }
    function getData() public returns(uint) { return data; }
    function compute(uint a, uint b) internal returns (uint) { return a+b; }
}

contract D {
    function readData() public {
        C c = new C();
        // f 函式是合約 C 的私有函式，所以沒辦法呼叫。
        uint local = c.f(7);
        c.setData(3);
        local = c.getData();
        // compute 函式是合約 C 的內部函式，所以沒辦法呼叫。
        local = c.compute(3, 5);
    }
}

contract E is C {
    function g() public {
        C c = new C();
        uint val = compute(3, 5);
    }
}
```

### 自動生成 Getter 函式

狀態變數初始時，可以在宣告時指定。編譯器會自動為所有公開的狀態變數建立 getter 函式。

以下面的範例來說，編譯器會自動產生。

```js
pragma solidity ^0.4.0;
contract C {
    uint public data = 42;
    function data() public returns(uint){
        return data
    }
}
```

下面這個範例比較複雜一點

```js
pragma solidity ^0.4.0;

contract Complex {
    struct Data {
        uint a;
        bytes3 b;
        mapping (uint => uint) map;
    }
    mapping (uint => mapping(bool => Data[])) public data;
}
```

編譯器會自動產生這個函式

```js
function data(uint arg1, bool arg2, uint arg3) public returns (uint a, bytes3 b) {
    a = data[arg1][arg2][arg3].a;
    b = data[arg1][arg2][arg3].b;
}
```

> 注意：公開的 mapping 不會自動生成 getter 函式