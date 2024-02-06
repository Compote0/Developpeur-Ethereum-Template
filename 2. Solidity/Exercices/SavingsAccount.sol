/* Exercice
Créons un compte d’épargne sur la blockchain en utilisant Solidity ! Voici les étapes à suivre :

Transfert d’argent : Vous avez le droit de transférer de l’argent vers le compte quand vous le souhaitez.
Ajout d’un administrateur : Lors du déploiement du contrat, ajoutez un administrateur.
Condition de retrait : L’administrateur ne peut récupérer les fonds qu’après 3 mois à compter de la première transaction.
Dépôts réguliers : Créez une fonction pour ajouter de l’argent au contrat et gardez un historique des dépôts dans un mapping.
Retrait des ethers : Permettez le retrait des ethers placés sur le contrat intelligent.
*/







// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

contract SavingsAccounts {

    address public owner;
    mapping(uint256 => uint256) public deposits;
    uint256 public lastTransactionTimestamp;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    function tranferToAccount() external payable {
        // Allow anyone to transfer funds to the acc
        deposits[block.timestamp] += msg.value;
        lastTransactionTimestamp = block.timestamp;
    }

    function addAdmin(address newAdmin) external onlyOwner {
        //add a new admin during contract deployment, for this case only one admin is allowed
        owner = newAdmin;
    }

    function withdrawFunds() external onlyOwner {
        // admin can withdraw funds after 3 months from the first tx
        require(block.timestamp >= lastTransactionTimestamp + 90 days, "Withdrawal allowed only after 3 mounths.");
        payable(owner).transfer(address(this).balance);
    }
}




/*
Correction : 
// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

error NotTheOwner(); // Custom Error

abstract contract Owner {

    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if(msg.sender != owner) {
            revert NotTheOwner();
        }
        _;
    }

    function getOwner() external view returns(address) {
        return owner;
    }
}

contract Ok is Owner {
    mapping(uint256 => uint256) deposits;
    // 0 => 500 wei
    // 1 => 66666 wei
    // 2 => 77777777 wei
    // 3 => 1 wei

    uint256 depositId;
    uint256 time;

    function deposit() external payable onlyOwner {
        // Je vérifie si le montant transmis à la fonction n'est pas de 0
        require(msg.value > 0, "Not enough funds provided");
        // Dans le mapping, pour ce numéro de déposit, j'assigne le montant déposé
        deposits[depositId] = msg.value;
        // Je n'oublie pas de mettre à jour cette variable depositId (pour les prochains deposits)
        depositId++;

        if(time == 0) {
            time = block.timestamp + 90 days;
        }
    }

    function withdraw() external onlyOwner {
        require(block.timestamp >= time, "Wait 3 months etc...");
        (bool sent,) = msg.sender.call{value: address(this).balance}("");
        require(sent, "An error occured");
    }
}
*/