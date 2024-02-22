// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/voting.sol";

contract VotingTest is Test {
    address _addr = makeAddr("Voting");
    address _owner = address(this); 

    Voting voting;

    function setUp() public {
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
    

    function test_AddVoter() public {
        voting.addVoter(address(this));
        Voting.Voter memory voter = voting.getVoter(address(this));
        assertTrue(voter.isRegistered, "Voter should be registered");
    }

    function test_AddVoterAlreadyRegistered() public {
        // Ajouter le votant une première fois
        voting.addVoter(address(this));
        assertTrue(voting.getVoter(address(this)).isRegistered, "Voter should be registered");

        // Essayer d'ajouter le même votant à nouveau et vérifier que cela échoue
        try voting.addVoter(address(this)) {
            // Si l'ajout réussit, échouer le test
            revert("Already registered");
        } catch Error(string memory reason) {
            // Si l'ajout échoue avec le message d'erreur attendu, le test réussit
            assertEq(reason, "Already registered", "Error message should be 'Already registered'");
        }
    }


    function test_AddVoterNotOwner() public {
        // Enregistrer l'adresse actuelle en tant qu'électeur
        voting.addVoter(msg.sender);

        // Essayer d'ajouter un électeur en tant que non propriétaire
        (bool success,) = address(voting).call(abi.encodeWithSignature("addVoter(address)", msg.sender));

        // Vérifier que l'appel a échoué comme prévu
        assertFalse(success, "Adding voter by non-owner should fail");
    }



    function test_AddVoterWhenWorkflowStatusIsNotRegisteringVoters() public {
        // Changer l'état du workflow
        voting.startProposalsRegistering();
        assertEq(uint(voting.workflowStatus()), uint(Voting.WorkflowStatus.ProposalsRegistrationStarted), "Workflow status should be ProposalsRegistrationStarted");

        // Essayer d'ajouter un électeur alors que l'état du workflow n'est pas RegisteringVoters
        (bool success,) = address(voting).call(abi.encodeWithSignature("addVoter(address)", address(this)));
        bool addVoterFailed = !success;

        // Vérifier que l'ajout d'électeur a échoué car l'état du workflow n'est pas RegisteringVoters
        assertTrue(addVoterFailed, "Adding voter should fail when workflow status is not RegisteringVoters");
    }


    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    /*                      START PROPOSALS                       */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    

    function test_StartProposalsRegistering() public {
        // Appeler la fonction startProposalsRegistering pour commencer l'enregistrement des propositions
        voting.startProposalsRegistering();

        // Obtenir le statut actuel du workflow après l'appel de la fonction startProposalsRegistering
        Voting.WorkflowStatus status = voting.workflowStatus();

        // Vérifier que le statut du workflow est bien ProposalsRegistrationStarted après l'appel de la fonction
        assertEq(uint(status), uint(Voting.WorkflowStatus.ProposalsRegistrationStarted), "Workflow status should be ProposalsRegistrationStarted");
    }


}