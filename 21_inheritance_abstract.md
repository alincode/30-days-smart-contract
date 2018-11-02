# 繼承和抽象合約

## 繼承 (Inheritance)

https://solidity.readthedocs.io/en/v0.4.25/contracts.html#inheritance

Solidity 透過複製程式碼和多型 (polymorphism)，來支援多重繼承。

<!-- All function calls are virtual, which means that the most derived function is called, except when the contract name is explicitly given. -->

當一個合約繼承多個合約，實際上只會有一個合約被創建，合約會將所有繼承的合約的程式碼，複製到自己身上。

關於 Solidity 對於繼承的設計與 `Python` 非常相似，尤其多重繼承的部分。

下面的範例，有更詳細的解釋。

```js
pragma solidity ^0.4.22;

contract owned {
    constructor() { owner = msg.sender; }
    address owner;
}

// 使用 `is` 關鍵字來繼承另一個合約，這樣就可以不需要透過 `this`，也可以存取所有非私有的狀態變數和函式。
contract mortal is owned {
    function kill() {
        if (msg.sender == owner) selfdestruct(owner);
    }
}

// 抽象合約，僅定義函式，但沒有實作函式。如果合約沒有實作所有的函式，那就只能使用介面 (interface)。
contract Config {
    function lookup(uint id) public returns (address adr);
}

contract NameReg {
    function register(bytes32 name) public;
    function unregister() public;
 }

// 可以使用多重繼承。雖然 named 合約跟 mortal 合約都有繼承 owned 合約，但實際 named 合約只有一個 owned 合約的實例 (instance)，與 C++ 的虛擬繼承 (virtual inheritance) 原理一樣。
contract named is owned, mortal {
    constructor(bytes32 name) {
        Config config = Config(0xD5f9D8D94886E70b06E474c3fB14Fd43E2f23970);
        NameReg(config.lookup(1)).register(name);
    }

    // 函式可以被另一個相同名字且相同參數數量的函式覆蓋 (override)，如果 override 的函式有不同的回傳值型態會發生錯誤。
    function kill() public {
        if (msg.sender == owner) {
            Config config = Config(0xD5f9D8D94886E70b06E474c3fB14Fd43E2f23970);
            NameReg(config.lookup(1)).unregister();

            // 可以用這個方式呼叫特定的 overridden 函式
            mortal.kill();
        }
    }
}

// 如果建構子接受傳入參數，則須要在合約的最前頭指定參數的值。
contract PriceFeed is owned, mortal, named("GoldFeed") {
   function updateInfo(uint newInfo) public {
      if (msg.sender == owner) info = newInfo;
   }

   function get() public view returns(uint r) { return info; }

   uint info;
}
```


Note that above, we call mortal.kill() to “forward” the destruction request. The way this is done is problematic, as seen in the following example:

```js
pragma solidity ^0.4.22;

contract owned {
    constructor() public { owner = msg.sender; }
    address owner;
}

contract mortal is owned {
    function kill() public {
        if (msg.sender == owner) selfdestruct(owner);
    }
}

contract Base1 is mortal {
    function kill() public { /* do cleanup 1 */ mortal.kill(); }
}

contract Base2 is mortal {
    function kill() public { /* do cleanup 2 */ mortal.kill(); }
}

contract Final is Base1, Base2 {
}

```

A call to `Final.kill()` will call `Base2.kill` as the most derived override, but this function will bypass `Base1.kill`, basically because it does not even know about `Base1`. The way around this is to use `super`:

```js
pragma solidity ^0.4.22;

contract owned {
    constructor() public { owner = msg.sender; }
    address owner;
}

contract mortal is owned {
    function kill() public {
        if (msg.sender == owner) selfdestruct(owner);
    }
}

contract Base1 is mortal {
    function kill() public { /* do cleanup 1 */ super.kill(); }
}


contract Base2 is mortal {
    function kill() public { /* do cleanup 2 */ super.kill(); }
}

contract Final is Base1, Base2 {
}

```

If `Base2` calls a function of `super`, it does not simply call this function on one of its base contracts. Rather, it calls this function on the next base contract in the final inheritance graph, so it will call `Base1.kill()` (note that the final inheritance sequence is – starting with the most derived contract: Final, Base2, Base1, mortal, owned). The actual function that is called when using super is not known in the context of the class where it is used, although its type is known. This is similar for ordinary virtual method lookup.

### Constructors

A constructor is an optional function declared with the constructor keyword which is executed upon contract creation. Constructor functions can be either public or internal. If there is no constructor, the contract will assume the default constructor: contructor() public {}.

```js
pragma solidity ^0.4.22;

contract A {
    uint public a;

    constructor(uint _a) internal {
        a = _a;
    }
}

contract B is A(1) {
    constructor() public {}
}
```

A constructor set as `internal` causes the contract to be marked as [abstract](https://solidity.readthedocs.io/en/v0.4.25/contracts.html#abstract-contract).

> Prior to version 0.4.22, constructors were defined as functions with the same name as the contract. This syntax is now deprecated.

```js
pragma solidity ^0.4.11;

contract A {
    uint public a;

    function A(uint _a) internal {
        a = _a;
    }
}

contract B is A(1) {
    function B() public {}
}
```

### Arguments for Base Constructors

The constructors of all the base contracts will be called following the linearization rules explained below. If the base constructors have arguments, derived contracts need to specify all of them. This can be done in two ways:

```js
pragma solidity ^0.4.22;

contract Base {
    uint x;
    constructor(uint _x) public { x = _x; }
}

contract Derived1 is Base(7) {
    constructor(uint _y) public {}
}

contract Derived2 is Base {
    constructor(uint _y) Base(_y * _y) public {}
}
```

One way is directly in the inheritance list (`is Base(7)`). The other is in the way a modifier would be invoked as part of the header of the derived constructor (`Base(_y * _y)`). The first way to do it is more convenient if the constructor argument is a constant and defines the behaviour of the contract or describes it. The second way has to be used if the constructor arguments of the base depend on those of the derived contract. Arguments have to be given either in the inheritance list or in modifier-style in the derived constuctor. Specifying arguments in both places is an error.

If a derived contract doesn’t specify the arguments to all of its base contracts’ constructors, it will be abstract.

### Multiple Inheritance and Linearization

Languages that allow multiple inheritance have to deal with several problems. One is the `Diamond Problem`. Solidity is similar to Python in that it uses “`C3 Linearization`” to force a specific order in the DAG of base classes. This results in the desirable property of monotonicity but disallows some inheritance graphs. Especially, the order in which the base classes are given in the `is` directive is important: You have to list the direct base contracts in the order from “most base-like” to “most derived”. Note that this order is different from the one used in Python. In the following code, Solidity will give the error “Linearization of inheritance graph impossible”.

```js
// This will not compile

pragma solidity ^0.4.0;

contract X {}
contract A is X {}
contract C is A, X {}
```

The reason for this is that `C` requests `X` to override `A` (by specifying `A`, `X` in this order), but `A` itself requests to override `X`, which is a contradiction that cannot be resolved.

### Inheriting Different Kinds of Members of the Same Name

When the inheritance results in a contract with a function and a modifier of the same name, it is considered as an error. This error is produced also by an event and a modifier of the same name, and a function and an event of the same name. As an exception, a state variable getter can override a public function.

## 抽象合約 (Abstract Contracts)

<!-- https://solidity.readthedocs.io/en/v0.4.25/contracts.html#abstract-contracts -->

當合約被標註為抽象合約時，代表的是至少有一個函式為實現，下面範例無法編譯：

```js
pragma solidity ^0.4.0;

contract Feline {
    function utterance() public returns (bytes32);
}
```

修正後，如下所示：

```js
pragma solidity ^0.4.0;

contract Feline {
    function utterance() public returns (bytes32);
}

contract Cat is Feline {
    function utterance() public returns (bytes32) { return "miaow"; }
}
```

如果合約繼承抽象合約後，並沒有實現所有未實現的函式，那麼自己也會是一個抽象合約。

> 注意：沒有實現的函式與 [Function Type](https://solidity.readthedocs.io/en/v0.4.25/types.html#function-types) 不同，即使它們的語法看起來很相似。

沒有實現的函式範例 (a function declaration)：

```js
function foo(address) external returns (address);
```

函式類型 (Function Type) 的範例：

Example of a Function Type (a variable declaration, where the variable is of type function):

```js
function(address) external returns (address) foo;
```

抽象合約將合約定義和合約的實現解耦 (decouple)，提供更好的擴充性、自我描述 (self-documentation) 或像 [Template method]((https://en.wikipedia.org/wiki/Template_method_pattern)) 模式一樣，或減少重複的程式碼。

抽象合約和介面在定義方法的時候非常好用，這樣的設計就像是告訴所有繼承它的子合約，它應該要實作哪些方法 (method)。
