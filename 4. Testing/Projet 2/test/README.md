## PROJET 2

## Voici ma submission pour le projet 2 :

Dans le cadre de la suite de tests pour le contrat intelligent Voting, j'ai créé une série de tests pour chacune des fonctions : c'est ce qui a été ma première priorité. 

J'ai commencé par les getters et la fonction setup(),puis j'ai écris des tests de fonctions basiques pour tseter que le contrat a été déployé avec succès, et une pour vérifier que le status du workflow au depart est bien "Registering Voters".

Ensuite, en suivant les exemples de Ben sur foundry, j'ai fait des test RevertWhen : 
- une qui, comme il le dit, revert quand le caller qui add le voter n'est pas owner.
- une autre qui revert quand le voteur submit son vote avant que le status du workflow ne soit sur "startProposalsRegistering"
- et un test qui revert quand le voteur submit deux fois un vote
- et pour finir un test qui revert quand le voteur submit un vote vide

Puis, deux fonction ExpectEmit : l'une pour tester que les evenements de changement de workflow status fonctionnent bien, et l'autre pour tester si l'evenement fonctionne bien quand quelquun vote avec succès.

Enfin, j'essaie de faire une fonction qui va tester si le proposal id gagnant est le bon. Je veux essayer de tester la line 139 pour faire 100% de test.


Pour les détails des commandes, j'ai utilisé forge test -vvvv, forge coverage et forge coverage --report lcov pour avoir le fichier de coverage, et savoir les branches qui n'ont pas été testées.


Les branches restantes que je n'ai pas réussi à tester sont dans le fichier lcov de ce dossier.
Résultat des tests : 


| File                                                    | % Lines         | % Statements    | % Branches     | % Funcs         |
|---------------------------------------------------------|-----------------|-----------------|----------------|-----------------|
| node_modules/@openzeppelin/contracts/access/Ownable.sol | 30.00% (3/10)   | 38.46% (5/13)   | 50.00% (2/4)   | 20.00% (1/5)    |
| node_modules/@openzeppelin/contracts/utils/Context.sol  | 33.33% (1/3)    | 33.33% (1/3)    | 100.00% (0/0)  | 33.33% (1/3)    |
| src/voting.sol                                          | 100.00% (42/42) | 100.00% (44/44) | 69.23% (18/26) | 100.00% (10/10) |
| Total                                                   | 83.64% (46/55)  | 83.33% (50/60)  | 66.67% (20/30) | 66.67% (12/18)  |