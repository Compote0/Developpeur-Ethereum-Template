## PROJET 2

## Voici ma submission pour le projet 2 :

Dans le cadre de la suite de tests pour le contrat intelligent Voting, j'ai créé une série de tests pour chacune des fonctions : c'est ce qui a été ma première priorité. 

J'ai commencé par les getters et la fonction setup(),puis j'ai écris des tests de fonctions basiques pour tseter que le contrat a été déployé avec succès, et une pour vérifier que le status du workflow au depart est bien "Registering Voters".

Ensuite, en suivant les exemples de Ben sur foundry, j'ai fait des test RevertWhen : 
```test_RevertWhen_AddVoterNotTheOwner ``` : qui, comme il le dit, revert quand le caller qui add le voter n'est pas owner.
```test_RevertWhen_AttemptToVoteTooEarly ``` : test qui revert quand le voteur submit son vote avant que le status du workflow ne soit sur "startProposalsRegistering"
```test_RevertWhen_VoteTwiceNotAllowed ``` : test qui revert quand le voteur submit deux fois un vote

Puis, pour finir, deux fonction ExpectEmit : l'une pour tester que les evenements de changement de workflow status fonctionnent bien, et l'autre pour tester si l'evenement fonctionne bien quand quelquun vote avec succès.


Pour les détails des commandes, j'ai utilisé forge test -vvvv, forge coverage et forge coverage --report lcov pour avoir le fichier de coverage, et savoir les branches qui n'ont pas été testées.