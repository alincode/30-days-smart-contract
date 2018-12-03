# 型別

#### 布林 (Boolean)

```js
bool valid = true;
bool valid = false;
```

#### 整數 (Integer)

從 8 開始，以 8 遞增，例如 8, 16, 24, ... , 256。

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
* 值的範圍是 0 ~ 2 的 n 次方，以 uint8 來說 2^8-1。

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

#### 位址 (Address)

語法

```
address [public] addr;
```

範例

```js
address addr;
address addr = 0xa77451687Ee77cB3DFf16A24446C54DB76C80222;
addr.balance

// 轉帳，交易發生錯誤時拋出 error
addr.transfer(100);
// 轉帳，交易發生回傳 bool 值
addr.send(100);
```

#### 位元組 (Bytes)

bytes1, bytes2, bytes3...bytes32

語法

```
bytes [storage|memory] [public] name;
```

範例

```js
// 宣告
bytes public myBytes;
// 取得長度
myBytes.length;
// 添加內容
myBytes.push(hex"ff");
```

> `byte` 是 `bytes1` 的別名

#### 字串 (String)

以 `UTF8` 編碼，動態分配大小。

**語法**

```
string [storage|memory] [public] nickName;
```

**範例**

```js
// 宣告
string nickName = "alincode";

// 刪除值
delete nickName;
```

**比對字串**

Solidity 無法直接進行字串比對，可以用 `sha3` 來比對。

```js
if (sha3(name1) == sha3(name2))
```

#### 列舉 (Enum)

```js
enum State { Start, Pending, End }
State state = State.Start;

function getState() view returns (uint) {
  return uint(state);
}
```

#### Arrays

語法

```
type[size] [memory|storage] [public] name;
```

宣告範例

```js
// 固定陣列
int[5] myArray;
// 動態陣列
int[] anotherArray; - dynamic array
// 宣告為記憶體陣列
uint[] memory myArray = new uint[](5);
```

使用範例

```js
// 刪除陣列內容
delete myArray;
// 取得陣列長度
myArray.length;
// 新增一個元素至陣列
myArray.push(1);
// 取得指定位址元素的值
myArray[3];
// 設定指定位址元素的值
myArray[3] = 8;
```

實際應用範例

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

語法

```
struct name { [member; ... ] }; 
```

範例

```js
// 宣告
struct Person {
  string name;
  int height;
}

// 實例化
Person customer; 

// 設定值
customer = Person({ name: 'alincode', age: 160 }); 
customer2 = Person('alincode', 160);
customer.name; 
customer.height = 160; 
```

實際範例

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

> payable 是一種函式的修飾標記，會在函式的篇幅在做說明。

### 值型別 (Value Type)

* 布林
* 整數
* 位址 (address)
* bytes
* 字串
* enum

**函式型別 (Function Type)**

```
function (<parameter types>) {internal|external} [pure|constant|view|payable] [returns (<return types>)]
```

### 傳參照型別 (Reference Types)

* Array
* Struct