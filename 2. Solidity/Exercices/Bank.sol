// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract Bank {
    address payable owner = payable(msg.sender);
    mapping(address => uint256) balances;

    function deposit() external payable {
        // ajouter des elements a notre balance
        balances[msg.sender] += msg.value;
    }

    function transfer(address recipient, uint256 amount) external payable {
        // permet de déplacer des éléments du caller à un destinataire
        require(recipient != address(0), "You can't burn your own tokens.");
        require(balances[msg.sender] >= amount, "insufficient balance");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
    }

    // définir un getter balanceOf
    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }

}

