# 型別

#### 布林 (Boolean)

```js
bool valid = true;
bool valid = false;
```

#### 整數 (Integer)

* 從 8 開始，以 8 遞增，例如 8, 16, 24, ... , 256。

**int**

有符號整數型別

```js
int8 amount = 100; // -127 ~ 127
int256 amount = 100;
int amount = 100; // 是 int256 的別名
```

**uint**

* 無符號整數型別
* 常用來表示貨幣數量和時間戳 (timestamp)

```js
uint8 amount = 100; // 0 ~ 255
uint256 amount = 100;
uint amount = 100; // 是 uint256 的別名
```

> Solidity 沒有 double 和 float

**注意：整數上溢**

```js
function case1() returns (uint) {
  uint8 x = 255;
  uint8 y = 1;
  return a + b
}

Assert.equal(case1(), 0);
```

**注意：整數下溢**

```js
function case2() returns (uint) {
  uint8 x = 0;
  uint8 y = 1;
  return a - b
}

Assert.equal(case2(), 255);
```

#### 地址 (Address)

20 byte

```
address addr = 0xa77451687Ee77cB3DFf16A24446C54DB76C80222;
```

#### Bytes

```
bytes1
bytes2
bytes3
bytes32

byte 是 bytes1 的別名
```

#### 字串 (String)

以 `UTF8` 編碼，動態分配大小。

```js
string nickName = "alincode";
```

**比對字串**

Solidity 無法直接進行字串比對，可以用 sha3 來比對。

```js
if (sha3(name1) == sha3(name2))
```

#### 列舉 (Enum)

```js
enum State { Start, Pending, End }
State state = State.Start;

function getState() returns (uint) {
  return uint(state);
}
```

#### Arrays

* length
* push

```js
address[] funderIndexs;

function getFunders() public view returns (string[], uint[]) {
    string[] memory names = new string[](funderIndexs.length);
    uint[] memory amounts = new uint[](funderIndexs.length);
    // 略...
    return (names, amounts);
}

function addFunder() public {
  funderIndexs.push(msg.sender);
}
```

#### 結構 (Struct)

```js
mapping (address => Funder) funders;

struct Funder {
    address addr;
    uint amount;
    uint createdAt;
    string name;
}

function fund(string _name) public payable {
  funders[msg.sender] = Funder(msg.sender, msg.value, now, _name);
}
```

### 值型別 (Value Type)

* 布林
* 整數
* 地址 (address)
* bytes
* 字串
* enum

**函示型別 (Function Type)**

```
function (<parameter types>) {internal|external} [pure|constant|view|payable] [returns (<return types>)]
```

### 傳參照型別 (Reference Types)

* Array
* Struct