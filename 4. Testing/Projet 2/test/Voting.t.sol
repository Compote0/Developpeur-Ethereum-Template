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
    

    function test_RevertWhen_AddVoterNotTheOwner() public {
        address nonOwner = makeAddr("NonOwner");
        vm.prank(nonOwner);

        // Tentative d'ajouter un votant en tant que non-propriétaire, attendez-vous à ce que cela échoue
        try voting.addVoter(nonOwner) {
            revert("Should revert because caller is not the owner");
        } catch {
            // Test réussi si une exception est attrapée, indiquant que la fonction a bien réverti
        }
    }


    function test_RevertWhen_AddVoterAlreadyRegistered() public {
        // Ajouter le votant une première fois
        voting.addVoter(address(this));
        assertTrue(voting.getVoter(address(this)).isRegistered, "Voter should be registered");

        // Essayer d'ajouter le même votant à nouveau et vérifier que l'opération échoue avec une réversion attendue
        try voting.addVoter(address(this)) {
            // Si l'ajout réussit, cela signifie que le test a échoué car une réversion était attendue
            revert("Should not allow adding an already registered voter");
        } catch Error(string memory reason) {
            // Vérifier que la réversion se produit pour la raison attendue, indiquant que le votant est déjà enregistré
            assertEq(reason, "Already registered", "Should revert with 'Already registered' error message");
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


    function test_RevertWhen_AddVoterWhenWorkflowStatusIsNotRegisteringVoters() public {
        // Changer l'état du workflow pour ne plus être en RegisteringVoters
        voting.startProposalsRegistering();
        assertEq(uint(voting.workflowStatus()), uint(Voting.WorkflowStatus.ProposalsRegistrationStarted), "Workflow status should be ProposalsRegistrationStarted");

        // Essayer d'ajouter un électeur et s'attendre à une réversion car l'état du workflow ne permet pas l'ajout
        try voting.addVoter(address(this)) {
            // Si l'appel ne révert pas, le test échoue
            revert("Adding voter should revert when workflow status is not RegisteringVoters");
        } catch Error(string memory reason) {
            // Confirmer que la réversion est pour la raison attendue
            assertEq(reason, "Voters registration is not open yet", "Revert reason should be 'Voters registration is not open yet'");
        }
    }


    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
    /*                     NOT OWNER                              */
    /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/


    function test_RevertWhen_StartProposalsRegisteringNotOwner() public {
        address nonOwner = makeAddr("NonOwner");
        bytes4 selector = bytes4(keccak256("OwnableUnauthorizedAccount(address)"));
        vm.expectRevert(abi.encodeWithSelector(selector, nonOwner));

        vm.prank(nonOwner);
        
        voting.startProposalsRegistering();
    }


    function test_RevertWhen_EndProposalsRegisteringNotOwner() public {
        address nonOwner = makeAddr("NonOwner");
        bytes4 selector = bytes4(keccak256("OwnableUnauthorizedAccount(address)"));
        vm.expectRevert(abi.encodeWithSelector(selector, nonOwner));

        vm.prank(nonOwner);
        
        voting.endProposalsRegistering();
    }

    function test_RevertWhen_StartVotingSessionNotOwner() public {
        address nonOwner = makeAddr("NonOwner");
        bytes4 selector = bytes4(keccak256("OwnableUnauthorizedAccount(address)"));
        vm.expectRevert(abi.encodeWithSelector(selector, nonOwner));

        vm.prank(nonOwner);
        
        voting.startVotingSession();
    }

    function test_RevertWhen_EndVotingSessionNotOwner() public {
        address nonOwner = makeAddr("NonOwner");
        bytes4 selector = bytes4(keccak256("OwnableUnauthorizedAccount(address)"));
        vm.expectRevert(abi.encodeWithSelector(selector, nonOwner));

        vm.prank(nonOwner);
        
        voting.endVotingSession();
    }

    function test_RevertWhen_TallyVotesNotOwner() public {
        address nonOwner = makeAddr("NonOwner");
        bytes4 selector = bytes4(keccak256("OwnableUnauthorizedAccount(address)"));
        vm.expectRevert(abi.encodeWithSelector(selector, nonOwner));

        vm.prank(nonOwner);
        voting.tallyVotes();
    }

}