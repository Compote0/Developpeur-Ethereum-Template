// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract Exo1 {
    address private storedAddress;

    function setAddrr(address _address) public {
        storedAddress = _address;
    }

    function getAddrr() public view returns (address) {
        return storedAddress;
    } 

    function getBalance(address _address) public view returns (uint256) {
        return _address.balance;
    }
}

