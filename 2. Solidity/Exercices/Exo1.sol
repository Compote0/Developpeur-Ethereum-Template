// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract Exo1 {
    address private storedAddress; // 

    // Function to define the stored address
    function setAddrr(address _address) public {
        storedAddress = _address;
    }

    // Function to retrieve stored address
    function getAddrr() public view returns (address) {
        return storedAddress;
    } 

    // Function to obtain address balance
    function getBalance(address _address) public view returns (uint256) {
        return _address.balance;
    }

    // Function to transfer Ether (ETH) to a specified address
    function transferEth(address _address) public payable {
        require(msg.value > 0, "Amount must be greater than 0");
        payable(_address).transfer(msg.value);
    }

    // Minimum balance required
    uint256 minimumBalance = 100 ether; 

    // Function to transfer from ETH to conditionally stored address
    function transferToStoredAddress(uint256 amount) public {
        require(address(this).balance >= minimumBalance, "Insufficient address balance");
        require(amount > 0, "Amount must be greater than 0");
        payable(storedAddress).transfer(amount);
    }

}