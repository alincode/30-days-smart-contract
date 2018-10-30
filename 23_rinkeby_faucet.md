# 實戰練習：Rinkeby Faucet

目前 Rinkeby 測試網的水管，只有 <https://faucet.rinkeby.io/> 水管，每次需要拿測試幣，都要在社群平台貼文夾帶自己的位址 (address)，對於非常重隱私的人，對這個服務非常感冒，所以讓我們來自己打照一個新的 `Rinkeby` 水管。

由於每次寫入狀態變數都必須要 gas，一般水管服務網站，需要結合一個後端 api，前置處理申請者的資料，然後透過後端 (node / python / go 等等) 來建立 `transaction`，並 sign `transaction` 後送出，才能達到申請者完全沒 gas 的情況下取得測試幣。

為了維持範例的單純化，所以這個範例邏輯，即使是操作提領，你帳戶也得先有少量的 gas 才能提領。

### 邏輯

1. 使用於 `Rinkeby` 測試網
1. 可以讓使用者捐獻測試幣
1. 每個帳戶一天可以提領 0.5 Ether 測試幣，領過之後要 24 小時才能在提領。
1. Owner 可以管理黑名單
1. Owner 可以修改最高提領金額的規則，例如：提高為一天可提領 2 Ether。
1. 捐獻者歷史紀錄
1. 如果直接將錢轉給智能合約帳戶，也要能接收到捐獻者的錢。
1. 捐 10 Ether 可以自動漂白 (從黑名單移除)

### 構思

**角色**

* `donor`：捐獻者
* `donee`：受贈者
* `owner`：管理者

**行為**

* 捐獻者
  * `donate`：每次捐 ? Ether
* 受贈者
  * `withdrawal`：每個帳戶一天可以提領 0.5 Ether 測試幣，領過之後要 24 小時才能在提領。
* 管理者
  * `addBlacklist`：將帳戶加入黑名單
  * `removeBlacklist`：將帳戶移出黑名單
  * `setWithdrawalAmount`：可以調整每次提領金額
  * `remove`：合約自毀機制

**View**

* 顯示帳戶餘額
* 捐獻按鈕
* 申請提領按鈕

**事件**

* `UserDonate`：捐獻成功通知
* `UserWithdrawal`：提領成功通知

**Model**

```js
struct User {
  address addr;
  uint donate;  // 捐獻金額
  uint donateAt;  // 捐獻時間
  uint withdrawal;  // 提領金額累計
  uint withdrawalAt; // 最近一次的提領時間
  bool blacklist;  // 被列為黑名單
}
```

**狀態變數**

* `owner`：管理者
* `withdrawalAmount`：每次提領金額

### 完整的程式碼

```js
// faucet.sol
pragma solidity ^0.4.5;
pragma experimental ABIEncoderV2;

contract Faucet {
    
    struct User {
      address addr;
      uint donate;  // 捐獻金額
      uint donateAt;  // 捐獻時間
      uint withdrawal;  // 提領金額累計
      uint withdrawalAt; // 最近一次的提領時間
      bool blacklist;  // 被列為黑名單
    }
    
    // 每次提領金額
    uint public withdrawalAmount = 0.5 ether;
    address owner;
    
    // 黑名單清單
    mapping (address => bool) public blacklist;
    // user 清單
    mapping (address => User) public users;
    
    // 事件
    event UserDonate(address indexed addr, User user, uint balance);
    event UserWithdrawal(address indexed addr, User user, uint balance);
    
    modifier onlyOwner() { require(msg.sender == owner); _; }
    
    // 提領前置檢查
    modifier available() {
        require(!blacklist[msg.sender], "you are blacked.");
        if(!isNewUser(msg.sender)) {
            require(now > users[msg.sender].withdrawalAt + 1 days, "you need to waiting for a few hours.");
        }
        _;
    }
    
    // 建構子
    constructor() {
        owner = msg.sender;
    }
    
    function isNewUser(address addr) private returns (bool) {
        return users[addr].donate == 0 && users[addr].withdrawal == 0;
    }
    
    // 捐獻
    function donate() public payable {
        if(isNewUser(msg.sender)) {
            users[msg.sender] = User(msg.sender, msg.value, now, 0, 0, false);
        } else {
            users[msg.sender].donate += msg.value;
            users[msg.sender].donateAt = now;
            if(msg.value >= 10 ether) blacklist[msg.sender] = false;
        }
        emit UserDonate(msg.sender, users[msg.sender], this.balance);
    }
    
    // 提領
    function withdrawal() public available payable {
        if(isNewUser(msg.sender)) {
            users[msg.sender] = User(msg.sender, 0, 0, withdrawalAmount, now, false);
        } else {
            if(now > users[msg.sender].withdrawalAt + 1 days)
            users[msg.sender].withdrawal += withdrawalAmount;
            users[msg.sender].withdrawalAt = now;
        }
        msg.sender.transfer(withdrawalAmount);
        emit UserWithdrawal(msg.sender, users[msg.sender], this.balance);
    }
    
    // 加入至黑名單
    function addBlacklist(address addr) onlyOwner public {
        blacklist[addr] = true;
    }
    
    // 從黑名單中移除
    function removeBlacklist(address addr) onlyOwner public {
        blacklist[addr] = false;
    }
    
    // 更改每次提領金額
    function setWithdrawalAmount(uint amount) onlyOwner public {
        withdrawalAmount = amount;
    }
    
    // 接收非透過智能合約轉入的捐獻
    function() payable {
        donate();
    }
    
    // 查詢餘額
    function getBalance() public view returns (uint) {
        return this.balance;
    }
    
    function remove() onlyOwner public {
        selfdestruct(owner);
    }
}
```