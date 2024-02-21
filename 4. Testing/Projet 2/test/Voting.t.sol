// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Voting.sol";

contract VotingTest is Test {

    Voting voting;

    function setUp() public {
        voting = new Voting();
    }

    function test_InitialWorkflowStatusIsRegisteringVoters() public {
        Voting.WorkflowStatus initialStatus = voting.workflowStatus();
        assertEq(uint(initialStatus), uint(Voting.WorkflowStatus.RegisteringVoters), "Initial workflow status should be RegisteringVoters");
    }

}
