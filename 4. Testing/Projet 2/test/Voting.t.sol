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

    function test_AddVoter() public {
        voting.addVoter(address(this));
        Voting.Voter memory voter = voting.getVoter(address(this));
        assertTrue(voter.isRegistered, "Voter should be registered");
    }

    function test_StartProposalsRegistering() public {
        voting.startProposalsRegistering();
        Voting.WorkflowStatus status = voting.workflowStatus();
        assertEq(uint(status), uint(Voting.WorkflowStatus.ProposalsRegistrationStarted), "Workflow status should be ProposalsRegistrationStarted");
    }


}
