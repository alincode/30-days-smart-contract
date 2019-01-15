pragma solidity >=0.4.0 <0.6.0;
import "./oo/SimpleStorage2";

contract SimpleStorage {
    uint storedData;

    function set(uint x) public {
        storedData = x;
    }

    function get() public view returns (uint) {
        return storedData;
    }
}