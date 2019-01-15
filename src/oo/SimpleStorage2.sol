pragma solidity >=0.4.0 <0.6.0;

contract SimpleStorage2 {
    uint storedData;

    function set(uint x) public {
        storedData = x;
    }

    function get() public view returns (uint) {
        return storedData;
    }
}