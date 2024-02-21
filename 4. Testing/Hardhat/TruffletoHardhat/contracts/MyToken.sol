// SPDX-License-Identifier: MIT 
pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor(uint initialSupply) ERC20("Alyra", "ALY") {
        _mint(msg.sender, initialSupply);
    }

}