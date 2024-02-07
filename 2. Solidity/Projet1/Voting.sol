/* 
- L’administrateur qui déploie le smart contract est celui qui gère le processus de vote.

- Import “Ownable” d’OpenZeppelin pour gérer les droits d’administration.

- Définir les structures de données suivantes :
Voter : Contient des informations sur chaque électeur (inscrit, a voté, ID de la proposition votée).
Proposal : Contient la description d’une proposition et le nombre de votes reçus.

- Utiliser une énumération (WorkflowStatus) pour gérer les différents états du vote :
Enregistrement des électeurs.
Début de l’enregistrement des propositions.
Fin de l’enregistrement des propositions.
Début de la session de vote.
Fin de la session de vote.
Votes comptabilisés.

- Définir un uint winningProposalId pour représenter l’ID de la proposition gagnante.
/ créer une func getWinner qui retourne l’ID du gagnant.

- Déclarer les événements suivants :
VoterRegistered : Pour signaler l’inscription d’un électeur.
WorkflowStatusChange : Pour indiquer le changement d’état du vote.
ProposalRegistered : Pour enregistrer une nouvelle proposition.
Voted : Pour enregistrer un vote.

- L’administrateur peut ajouter des électeurs à la liste blanche avec une fonction registerVoter.
- L’administrateur peut démarrer et terminer la session d’enregistrement des propositions.
- Les électeurs inscrits peuvent soumettre des propositions avec la fonction registerProposal.
- Ils peuvent ensuite voter pour leur proposition préférée avec la fonction vote.
- L’administrateur met fin à la session de vote avec la fonction endVotingSession, qui détermine la proposition gagnante.
- La fonction getWinner permet de récupérer l’ID

*/


// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract Voting is Ownable {
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
}

