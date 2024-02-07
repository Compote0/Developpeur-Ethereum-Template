/* 
Rajout de fonctionnalités au contrat Voting : délégation de vote
*/


// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract VotingPlus is Ownable {
    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }

    struct Proposal {
        string description;
        uint voteCount;
    }

    // Nouvelle structure de données pour stocker les délégations de vote
    struct Delegation {
        bool hasDelegated;
        address delegate;
    }

    // Nouveau mapping pour les délégations de vote
    mapping(address => Delegation) public voteDelegations;


    WorkflowStatus public currentStatus;
    uint public winningProposalId;

    mapping(address => Voter) public voters;
    Proposal[] public proposals;

    event VoterRegistered(address voterAddress);
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
    event ProposalRegistered(uint proposalId);
    event Voted(address voter, uint proposalId);


    constructor(address initialOwner) Ownable(initialOwner) {
        currentStatus = WorkflowStatus.RegisteringVoters;
    }

    modifier onlyInStatus(WorkflowStatus _status) {
        require(currentStatus == _status, "Invalid workflow status");
        _;
    }

    function registerVoter(address voterAddress) external onlyInStatus(WorkflowStatus.RegisteringVoters) {
        require(!voters[voterAddress].isRegistered, "Voter already registered");
        voters[voterAddress].isRegistered = true;
        emit VoterRegistered(voterAddress);
    }

    function registerProposal(string memory _description) external onlyInStatus(WorkflowStatus.ProposalsRegistrationStarted) {
        proposals.push(Proposal(_description, 0));
        emit ProposalRegistered(proposals.length - 1);
    }

    function startProposalRegistration() external onlyOwner onlyInStatus(WorkflowStatus.RegisteringVoters) {
        require(currentStatus == WorkflowStatus.RegisteringVoters, "Invalid workflow status");
        currentStatus = WorkflowStatus.ProposalsRegistrationStarted;
        emit WorkflowStatusChange(WorkflowStatus.RegisteringVoters, WorkflowStatus.ProposalsRegistrationStarted);
    }

    function endProposalRegistration() external onlyOwner onlyInStatus(WorkflowStatus.ProposalsRegistrationStarted) {
        require(currentStatus == WorkflowStatus.ProposalsRegistrationStarted, "Invalid workflow status");
        currentStatus = WorkflowStatus.ProposalsRegistrationEnded;
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationStarted, WorkflowStatus.ProposalsRegistrationEnded);
    }

    function startVotingSession() external onlyOwner onlyInStatus(WorkflowStatus.ProposalsRegistrationEnded) {
        require(currentStatus == WorkflowStatus.ProposalsRegistrationEnded, "Invalid workflow status");
        currentStatus = WorkflowStatus.VotingSessionStarted;
        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationEnded, WorkflowStatus.VotingSessionStarted);
    }
    
    function endVotingSession() external onlyOwner onlyInStatus(WorkflowStatus.VotingSessionStarted) {
        require(currentStatus == WorkflowStatus.VotingSessionStarted, "Invalid workflow status");
        currentStatus = WorkflowStatus.VotingSessionEnded;
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionStarted, WorkflowStatus.VotingSessionEnded);  
    }

    // Fonction pour permettre aux électeurs inscrits de déléguer leur vote
    function delegateVote(address _delegate) external {
        require(voters[msg.sender].isRegistered, "Voter not registered");
        require(_delegate != msg.sender, "Cannot delegate to yourself");
        require(!voteDelegations[msg.sender].hasDelegated, "Vote already delegated");

        voteDelegations[msg.sender] = Delegation(true, _delegate);
    }

    // Modifier la fonction de vote pour prendre en compte les votes délégués
    function vote(uint256 _proposalId) external onlyInStatus(WorkflowStatus.VotingSessionStarted) {
        address _voterAddress = msg.sender;

        if (voteDelegations[_voterAddress].hasDelegated) {
            _voterAddress = voteDelegations[_voterAddress].delegate;
        }

        require(!voters[_voterAddress].hasVoted, "Voter already voted");
        require(proposals[_proposalId].voteCount < 10, "Proposal already voted");

        voters[_voterAddress].hasVoted = true;
        voters[_voterAddress].votedProposalId = _proposalId;
        proposals[_proposalId].voteCount++;
        emit Voted(_voterAddress, _proposalId);
    }

    function tallyVotes() external onlyOwner onlyInStatus(WorkflowStatus.VotingSessionEnded){
        uint maxVotes = 0;
        uint winningProposalId = 0;
        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > maxVotes) {
                maxVotes = proposals[i].voteCount;
                winningProposalId = i;
            }
        }
        currentStatus = WorkflowStatus.VotesTallied;
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionEnded, currentStatus);
    }

    function getWinner() external view returns (uint) {
        require(currentStatus == WorkflowStatus.VotesTallied, "Invalid workflow status");
        return winningProposalId;
    }
}
