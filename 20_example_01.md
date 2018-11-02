# 實戰練習：簡易版 King of the Ether (2/2)

**使用ABIEncoderV2**

```js
pragma solidity ^0.4.25;
// 開啟 ABI V2 編碼器
pragma experimental ABIEncoderV2;

contract UserDirectory {

    struct Contact {
        string email;
        string phone;
    }
    struct User {
        string name;
        address addr;
        Contact contact;
    }

    address owner;
    mapping (address => User) _users;
    
    // 支援在事件中使用 User struct 參數
    event UserAdded(address indexed addr, User user);
    
    constructor() {
        owner = msg.sender;
    }
    
    // 支援在函式中，使用 User struct 參數。
    function addUser(User user) public {
        require(msg.sender == owner);
        _users[user.addr] = user;
        emit UserAdded(user.addr, user);
    }
    
    // 支援在函式中使用 User struct 當回傳值
    function user(address addr) public view returns (User user) {
        return _users[addr];
    }
}
```

### 完整範例

```js
pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

contract KingOfEther {

  // 出價最高的金額
  uint public amount;

  // 活動開始與結束時間
  uint public startAt;
  uint public endAt;

  // 管理者
  address owner;
  // 現任國王
  address currentKing;

  // 狀態
  State private state;
  enum State { Started, Ended }

  address[] kingIndexs;
  mapping (address => King) public kings;

  // 通知有新任國王上任
  event NoticeNewKing(address addr, uint amount, string name);

  struct King {
    address addr;
    uint amount;
    string name;
    uint createdAt;
    uint withdrawalAmount;
  }

  // 前置條件檢查
  modifier onlyOwner() { require(msg.sender == owner); _; }
  modifier onlyTimeout() { require(now > endAt); _; }
  modifier overMinimumPrice() { require(msg.value != 0 && msg.value >= 0.1 ether); _; }
  modifier candidate(uint sendAmount) { require(available(sendAmount)); _; }

  // 初始化狀態變數
  constructor(uint afterFewDay) {
    owner = msg.sender;
    state = State.Started;
    startAt = now;
    endAt = now + afterFewDay * 60 * 60 * 24;
  }

  // 檢查目前狀態能不能篡位
  function available(uint sendAmount) private view returns (bool) {
    if(state == State.Ended) return false;
    if(now > endAt) return false;
    if(kingIndexs.length == 0) return true;
    if(currentKing == msg.sender) return false;
    if(sendAmount + 0.1 ether > kings[currentKing].amount) return true;
    return false;
  }

  // 篡位
  function replaceKing(string _name) payable overMinimumPrice candidate(msg.value) public {
    if(kingIndexs.length > 0) {
      kings[currentKing].withdrawalAmount += msg.value - 0.05 ether;
    }
    kingIndexs.push(msg.sender);
    kings[msg.sender] = King(msg.sender, msg.value, _name, now, 0);
    currentKing = msg.sender;
    emit NoticeNewKing(msg.sender, msg.value, _name);
  }

  // 取得國王資訊
  function kingInfo() public view returns (King) {
    return kings[currentKing];
  }

  // 提領管理費
  function ownerWithdrawal() payable onlyOwner onlyTimeout public {
    owner.transfer(this.balance);
    state = State.Ended;
  }

  // 被篡位的人，可以拿走篡位的人的錢，但要先扣除管理費。
  function playerWithdrawal() payable public {
    require(kings[msg.sender].withdrawalAmount > 0);
    uint amount = kings[msg.sender].withdrawalAmount;
    kings[msg.sender].withdrawalAmount = 0;
    msg.sender.transfer(amount);
  }
}
```