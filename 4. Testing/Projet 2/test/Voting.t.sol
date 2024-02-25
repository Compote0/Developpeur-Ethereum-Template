// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/voting.sol";

contract VotingTest is Test {
    address addr1 = makeAddr("Voter1");
    address addr2 = makeAddr("Voter2");
    address owner = makeAddr('Owner');

    Voting voting;

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    struct Proposal {
        string description;
        uint voteCount;
    }

    enum  WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }

    WorkflowStatus public workflowStatus;
    Proposal[] public proposalsArray;
    mapping (address => Voter) voters;

    event VoterRegistered(address voterAddress); 
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
    event ProposalRegistered(uint proposalId);
    event Voted (address voter, uint proposalId);


    function setUp() public {
        vm.prank(owner);
        voting = new Voting();
    }

    function test_ContractDeployment() public {
        assertTrue(address(voting) != address(0), "Contract should be deployed");
    }


    function test_InitialWorkflowStatusIsRegisteringVoters() public {
        Voting.WorkflowStatus initialStatus = voting.workflowStatus();
        assertEq(uint(initialStatus), uint(Voting.WorkflowStatus.RegisteringVoters), "Initial workflow status should be RegisteringVoters");
    }




    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    /*                      REGISTERING VOTERS                    */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    

    function test_RevertWhen_AddVoterNotTheOwner() public {
        address nonOwner = makeAddr("NonOwner");
        vm.prank(nonOwner);
        try voting.addVoter(nonOwner) {
            revert("Should revert because caller is not the owner");
        } catch {
        }
    }

    function test_Successful_AddVoter() public {
        vm.startPrank(owner);
        voting.addVoter(addr1);
        emit VoterRegistered(addr1);
        vm.stopPrank();
        vm.startPrank(addr1);
        assertTrue(voting.getVoter(addr1).isRegistered);
    }



    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    /*                        ADD PROPOSAL                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    
    function test_AddProposal_SuccessfullyByRegisteredVoter() public {
        vm.startPrank(owner);
        voting.addVoter(addr1); 
        voting.startProposalsRegistering();
        vm.stopPrank();

        vm.startPrank(addr1);
        string memory proposalDescription = "Proposal1";

        vm.expectEmit(true, true, true, true);
        emit ProposalRegistered(1); // L'ID de proposition attendu est maintenant 1

        voting.addProposal(proposalDescription);

        Voting.Proposal memory proposal = voting.getOneProposal(1); 
        assertEq(proposal.description, proposalDescription, "Proposition doesn't match.");
        assertEq(proposal.voteCount, 0, "Number of votes should be 0");
        vm.stopPrank();
    }



    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    /*                 EXPECT EMIT WORKFLOW STATUS                */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/


    function test_ExpectEmit_WhenWorkflowStatusChange() public {
        vm.prank(owner);
        vm.expectEmit(true, false, false, true);
        emit WorkflowStatusChange(WorkflowStatus.RegisteringVoters, WorkflowStatus.ProposalsRegistrationStarted);

        voting.startProposalsRegistering();
        vm.prank(owner);
        vm.expectEmit(true, false, false, true);
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationStarted, WorkflowStatus.ProposalsRegistrationEnded);
        
        voting.endProposalsRegistering();
        vm.prank(owner);
        vm.expectEmit(true, false, false, true);
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationEnded, WorkflowStatus.VotingSessionStarted);
        
        voting.startVotingSession();
        vm.prank(owner);
        vm.expectEmit(true, false, false, true);
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionStarted, WorkflowStatus.VotingSessionEnded);
        
        voting.endVotingSession();
        vm.prank(owner);
        vm.expectEmit(true, false, false, true);
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionEnded, WorkflowStatus.VotesTallied);
        voting.tallyVotes();

    }


    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    /*               EXPECT EMIT HAS VOTED                        */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/


    function test_ExpectEmit_HasVotedSuccessfully() public {
        vm.startPrank(owner);
        voting.addVoter(addr1);
        voting.startProposalsRegistering();
        vm.stopPrank();

        vm.startPrank(addr1);
        voting.addProposal("Proposal 1");
        vm.stopPrank();

        vm.startPrank(owner);
        voting.endProposalsRegistering();
        voting.startVotingSession();
        vm.stopPrank();
        
        vm.startPrank(addr1);
        vm.expectEmit(true, false, false, true);
        emit Voted(addr1, 0);
        voting.setVote(0);
        vm.stopPrank();
    }
}