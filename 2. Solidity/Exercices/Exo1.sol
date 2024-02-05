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

    function transferEth(address _address) public payable {
        require(msg.value > 0, "Amount must be greater than 0");
        payable(_address).transfer(msg.value);
    }
}