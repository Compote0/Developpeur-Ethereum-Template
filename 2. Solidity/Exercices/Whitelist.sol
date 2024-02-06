// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract Whitelist {
    mapping (address => bool) whitelist;

    event Authorized(address _address);
    event EthReceived(address _address, uint _value);


    function authorize(address _address) public {
        require(check(_address), "Wallet is not whitelisted");
        whitelist[_address] = true;
        emit Authorized(_address);
    }

/* Exemple avec receive et fallback 
    receive() external payable {
        emit EthReceived(msg.sender, msg.value);
    }

     fallback() external payable {
        emit EthReceived(msg.sender, msg.value);
    }
*/
    function check(address _address) private view returns (bool) {
        return whitelist[_address];
    }
}