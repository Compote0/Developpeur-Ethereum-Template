// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract Random {
    function random() public view returns (uint) {
        uint randomNumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 101;
        return randomNumber;
    }

    function useHash(bytes32 param1, bytes32 param2) public pure returns (uint) {
        return uint(keccak256(abi.encodePacked(param1, param2)));
    }
}