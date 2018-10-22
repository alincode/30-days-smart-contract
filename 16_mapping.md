# mapping 型別

你可以把 mapping 型別看做類似是一個 [hash tables](https://en.wikipedia.org/wiki/Hash_table)，它會虛擬初始化每一個 key 的值都預設為 0。但實際上 mapping 型別，並不是存 key 和 value 的真正的內容，而是 key 的 和 value 的 `keccak256` hash。

![](assets/16_hash_table.png)

因此 mapping 型別的 key 跟 value 在設定時，沒有長度的概念，並且 mapping 型別只允許使用在狀態變數。

**宣告 mapping**

語法
```
mapping(_KeyType => _ValueType)
```

mapping 是一個動態大小的陣列，`_KeyType` 除了 `enum` 和 `struct` 型別能使用之外，其他的型別都支援。`_ValueType` 支援所有的型別，包含 `mapping` 型別。

範例
```
mapping(address => uint) public balances;
```

**mapping 型別裡面包含 mapping 型別**
```
mapping(uint => mapping(uint => s)) data;
```

**設定 mapping 值**
```
balances[msg.sender] = newBalance;
```

**取得 mapping 值**
```
uint balance = balances[msg.sender]
```

**mapping 型別不支援 iterable，但可以自己實作它。**


```js
pragma solidity ^0.4.0;

contract MappingExample {

  address[] funderIndexs;
  mapping (address => Funder) public funders;

  struct Funder {
    address addr;
    uint amount;
    uint createdAt;
    string name;
  }

  function add(uint _amount, string _name) public {
    funderIndexs.push(msg.sender);
    funders[msg.sender] = Funder(msg.sender, _amount, now, _name);
  }

  function iterable() public {
    for (uint i = 0; i < funderIndexs.length; i++) {
      Funder storage funder = funders[funderIndexs[i]];
      // ...  
    }
  }
}
```

### 完整範例

```js
pragma solidity ^0.4.0;

contract MappingExample {
    mapping(address => uint) public balances;

    function update(uint newBalance) public {
        balances[msg.sender] = newBalance;
    }
}

contract MappingUser {
    function f() public returns (uint) {
        MappingExample m = new MappingExample();
        m.update(100);
        return m.balances(this);
    }
}
```