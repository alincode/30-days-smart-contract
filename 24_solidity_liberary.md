# 函式庫

`library` 語法的使用方式類似 `contract` 語法，沒有自己的合約帳戶，所以在 library 不能使用 `payable`，也沒有 `fallback` 函示。

函式庫不需要實例化，所以你可以從下面的例子看到，我們是直接用 `Utils.myAddress()` 語法來呼叫函式庫的函示。
<!-- 函式庫的呼叫透過 DELEGATECALL 實現，即不切換上下文。 -->

```js
pragma solidity ^0.4.25;

library Utils {
  function myAddress() returns (address) {
    return this;
  }
}

contract MyContract {
  function test() returns () {
    require(address(this) == Utils.myAddress());
  }
}
```

### Using For

**語法**

```js
using lib for type;
```

**範例**

將 A 函式庫內定義的所有函示附著到 B 類型上，函式庫 A 中的函示，第一個參數會預設是 B 實例。

原始碼來源：<https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol>

```js
pragma solidity ^0.4.25;

contract MyContract {
  using SafeMath for uint256;    
  uint256 result;

  function SafeAdd(uint256 a, uint256 b) {
    result = 0;
    result = a.add(b);
  }
}

library SafeMath {

  /**
  * @dev Multiplies two numbers, reverts on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b);

    return c;
  }

  /**
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b > 0); // Solidity only automatically asserts when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b <= a);
    uint256 c = a - b;

    return c;
  }

  /**
  * @dev Adds two numbers, reverts on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a);

    return c;
  }

  /**
  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
  * reverts when dividing by zero.
  */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    require(b != 0);
    return a % b;
  }
}
```