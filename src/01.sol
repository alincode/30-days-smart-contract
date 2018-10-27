pragma solidity ^0.4.17;

contract SimpleStorage {
  uint storedData;

  // constructor() public {}

  function set(uint x) public {
    storedData = x;
  }

  function get() public view returns (uint) {
    return storedData;
  }
}