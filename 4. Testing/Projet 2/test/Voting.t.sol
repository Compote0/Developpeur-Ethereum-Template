// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "../src/votingPlus.sol";

contract VotingTest is Test {

 Voting voting;

    function setUp() public {
        voting = new Voting();
    }

}