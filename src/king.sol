pragma solidity ^0.4.0;
pragma experimental ABIEncoderV2;

contract KingOfEther {

  uint public amount;
  uint public startAt;
  uint public endAt;
  address owner;
  address currentKing;
  State private state;
  enum State { Started, Ended }
  address[] kingIndexs;
  mapping (address => King) public kings;
  event NoticeNewKing(address addr, uint amount, string name);

  struct King {
    address addr;
    uint amount;
    string name;
    uint createdAt;
    uint withdrawalAmount;
  }
  
  modifier onlyOwner() { require(msg.sender == owner); _; }
  modifier onlyTimeout() { require(now > endAt); _; }
  modifier overMinimumPrice() { require(msg.value != 0 && msg.value >= 0.1 ether); _; }
  modifier candidate() { require(available()); _; }
  
  constructor(uint afterFewDay) {
      owner = msg.sender;
      state = State.Started;
      startAt = now;
      endAt = now + afterFewDay * 60 * 60 * 24;
  }
  
  function available() view returns (bool) {
      if(state == State.Ended) return false;
      if(now > endAt) return false;
      if(kingIndexs.length == 0) return true;
      if(currentKing == msg.sender) return false;
      if(msg.value + 0.1 ether > kings[currentKing].amount) return true;
      return false;
  }

  function replaceKing(string _name) payable overMinimumPrice candidate public {
    if(kingIndexs.length > 0) {
        kings[currentKing].withdrawalAmount += msg.value - 0.05 ether;
    }
    kingIndexs.push(msg.sender);
    kings[msg.sender] = King(msg.sender, msg.value, _name, now, 0);
    currentKing = msg.sender;
    emit NoticeNewKing(msg.sender, msg.value, _name);
  }
  
  function kingInfo() public view returns (King) {
      return kings[currentKing];
  }

  function ownerWithdrawal() payable onlyOwner onlyTimeout public {
    owner.transfer(this.balance);
    state = State.Ended;
  }
  
  function playerWithdrawal() payable public {
      require(kings[msg.sender].withdrawalAmount > 0);
      uint amount = kings[msg.sender].withdrawalAmount;
      kings[msg.sender].withdrawalAmount = 0;
      msg.sender.transfer(amount);
  }
}