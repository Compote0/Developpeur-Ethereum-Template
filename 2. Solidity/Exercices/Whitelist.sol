// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract Whitelist {
    mapping (address => bool) whitelist;

    event Authorized(address _address);
    event EthReceived(address _address, uint _value);

    constructor() {
        whitelist[msg.sender]== true;
    }



    modifier check() {
        // require(whitelist[_address], "Wallet is not whitelisted"); <- vérifier n'importe quelle adresse spécifiée par l'utilisateur
        require(whitelist[msg.sender]==true, "Wallet is not whitelisted"); // <- vérifier l'adresse de l'émetteur de la transaction
        _;
    }

    function authorize(address _address) public check {
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
    // function check(address _address) private view returns (bool) {
    //     return whitelist[_address];
    // }


}