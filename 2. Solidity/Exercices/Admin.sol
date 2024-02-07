// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol"; 

contract Admin is Ownable {
    mapping(address => bool) private _whitelist;
    mapping(address => bool) private _blacklist;

    event Whitelisted(address _address);
    event Blacklisted(address _address);

     constructor(address initialOwner) Ownable(initialOwner) {
    }

    function addToWhitelist(address _address) external onlyOwner {
        _whitelist[_address] = true;
        emit Whitelisted(_address);
    }

    function addToBlacklist(address _address) external onlyOwner {
        _blacklist[_address] = true;
        emit Blacklisted(_address);
    }

    function isWhitelisted(address _addr) external view returns (bool) {
        return _whitelist[_addr];
    }

    function isBlacklisted(address _addr) external view returns (bool) {
        return _blacklist[_addr];
    }
}
