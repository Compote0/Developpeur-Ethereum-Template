
// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.24;

contract SimpleStorage {
    uint256 private _value;

    function setValue(uint256 newValue) public {
        _value = newValue;
    }

    function getValue() public view returns (uint256) {
        return _value;
    }

    function getCurrentTime() public view returns (uint256) {
        return block.timestamp;
    }
}


/*
@Hardhat native Exercice

error NumberOutOfRange();

contract SimpleStorage {
    event NumberChanged(address indexed by, uint256 number);

    mapping(address => uint) private addressToNumber;

    function setNumber(uint256 _number) external {
        if(_number >= 10) {
            revert NumberOutOfRange();
        }
        addressToNumber[msg.sender] = _number;
        emit NumberChanged(msg.sender, _number);
    }

    function getNumber() external view returns(uint) {
        return addressToNumber[msg.sender];
    }
}

*/
