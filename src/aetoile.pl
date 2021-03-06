%*******************************************************************************
%                                    AETOILE
%*******************************************************************************

/*
Rappels sur l'algorithme
 
- structures de donnees principales = 2 ensembles : P (etat pendants) et Q (etats clos)
- P est dedouble en 2 arbres binaires de recherche equilibres (AVL) : Pf et Pu
 
   Pf est l'ensemble des etats pendants (pending states), ordonnes selon
   f croissante (h croissante en cas d'egalite de f). Il permet de trouver
   rapidement le prochain etat a developper (celui qui a f(U) minimum).
   
   Pu est le meme ensemble mais ordonne lexicographiquement (selon la donnee de
   l'etat). Il permet de retrouver facilement n'importe quel etat pendant

   On gere les 2 ensembles de fa�on synchronisee : chaque fois qu'on modifie
   (ajout ou retrait d'un etat dans Pf) on fait la meme chose dans Pu.

   Q est l'ensemble des etats deja developpes. Comme Pu, il permet de retrouver
   facilement un etat par la donnee de sa situation.
   Q est modelise par un seul arbre binaire de recherche equilibre.

Predicat principal de l'algorithme :

   aetoile(Pf,Pu,Q)

   - reussit si Pf est vide ou bien contient un etat minimum terminal
   - sinon on prend un etat minimum U, on genere chaque successeur S et les valeurs g(S) et h(S)
	 et pour chacun
		si S appartient a Q, on l'oublie
		si S appartient a Ps (etat deja rencontre), on compare
			g(S)+h(S) avec la valeur deja calculee pour f(S)
			si g(S)+h(S) < f(S) on reclasse S dans Pf avec les nouvelles valeurs
				g et f 
			sinon on ne touche pas a Pf
		si S est entierement nouveau on l'insere dans Pf et dans Ps
	- appelle recursivement etoile avec les nouvelles valeurs NewPF, NewPs, NewQs

*/

%*******************************************************************************

:- ['avl.pl'].       % predicats pour gerer des arbres bin. de recherche   
:- ['taquin.pl'].    % predicats definissant le systeme a etudier
:- ['debuggage.pl']. % predicats de debuggage du programme

%*******************************************************************************
/*
	main 

*/
main :-
	cleanFiles,
	% initialisations Pf, Pu et Q 
	initial_state(S0), % fixer la situation de départ S0
	% calculer les valeurs F0, H0, G0 pour cette situation
	G0 is 0, 
	heuristique(S0,H0),
	F0 is H0,
	% créer 3 AVL Pf, Pu et Q initialement vides
	empty(Pf),empty(Pu),empty(Q),
	% insérer un noeud [ [F0,H0,G0], S0 ]dans Pf  et un noeud[S0, [F0,H0,G0], nil, nil]dans Pu
	insert([[F0,H0,G0],S0],Pf,PfInit),
	insert([S0,[F0,H0,G0],nil,nil],Pu,PuInit),
	% lancement de Aetoile
	aetoile(PfInit,PuInit,Q,0).



%*******************************************************************************


loop_successors([],Pu,Pf,_,Pu,Pf,_).
loop_successors([S|Lsuite],Pu,Pf,Q,NewPu,NewPf,Num) :- 
	S=[U1,_,_,_],
	belongs([U1,_,_,_], Q) -> % si S est connu dans Q alors oublier cet état (S a déjà été développé)
		S=[_,_,_,_],
		Num1 is Num+1,
		loop_successors(Lsuite,Pu,Pf,Q,NewPu,NewPf,Num1)
	;
		S = [U,[F,_,_],_,_],
		% si S est connu dans Pu alors garder le terme associé à la meilleure évaluation (dans Pu et dans Pf)
		(belongs([U,[F2,H2,G2],Pere2,Action2],Pu) ->
		(
			(F2 =< F -> (
				loop_successors(Lsuite,Pu,Pf,Q,NewPu,NewPf,Num) )
			; (
				S = [U,[F,H,G],Pere,Action],
				suppress([U,[F2,H2,G2],Pere2,Action2],Pu,NewPu1),
				suppress([[F2,H2,G2],U],Pf,NewPf1),
				
				insert([U,[F,H,G],Pere,Action],NewPu1,NewPu2),
				insert([[F,H,G],U],NewPf1,NewPf2),
				loop_successors(Lsuite,NewPu2,NewPf2,Q,NewPu,NewPf,Num)
			)
			)
		)
		;
 		(	% sinon (S est une situation nouvelle) il faut créer un nouveau terme à insérer dans Pu (idem dans Pf)	
			S = [U,[F,H,G],Pere,Action],
			insert([U,[F,H,G],Pere,Action],Pu,NewPu1),
			insert([[F,H,G],U],Pf,NewPf1) ,
			loop_successors(Lsuite,NewPu1,NewPf1,Q,NewPu,NewPf,Num)
			)
		).



/**
	expand(+U, +G, -ListNoeudsSuccDirect)
*/
expand(U, G, ListNoeudsSuccDirect):-
	% Trouver tous les S, successeurs directs de l’état U (donc en 1 coup)
	findall(
		[S, [Fs, Hs, Gs], U, A], 
		(rule(A,1, U, S), heuristique(S,Hs),Gs is G+1,Fs is Gs+Hs), 
		ListNoeudsSuccDirect
		)
	.
affiche_solution(_, nil) :- write("ok\n").
% E: état duquel on va afficher les actions pour y parvenir en remontant récursivement
affiche_solution(Q, E) :-
	% Extraire le noeud correspondant à l’état E
	belongs([E, [_,_,_], Pere, _], Q),
	suppress([E,_,Pere,A],Q,NewQ),
	% Extraire les différents éléments de la structure du noeud
	% Afficher l’action correspondante à l’état actuel
	write(A),write(" ; "),write(E),write("\n"),
	% Vérifier que Pere n’est pas nul (nul quand on arrive à la racine)
	% Appliquer le prédicat sur le père de l’état actuel
	affiche_solution(NewQ, Pere).
longueurChaine(_,nil,Li,Li).
longueurChaine(Q,U,Li,Lo) :-
	% Extraire le noeud correspondant à l’état E
	belongs([U, [_,_,_], Pere, _], Q),
	suppress([U,_,Pere,_],Q,NewQ),
	Liact is Li+1,
	% Appliquer le prédicat sur le père de l’état actuel
	longueurChaine(NewQ, Pere,Liact,Lo)
.


%si Pf et Pu sont vides, il n’y a aucun état pouvant être développé donc pas de solution au problème. 
% Dans ce cas il faut afficher un message clair : « PAS de SOLUTION : L’ETAT FINAL N’EST PAS ATTEIGNABLE ! »
aetoile([], [], _,_) :- write("PAS de SOLUTION : L’ETAT FINAL N’EST PAS ATTEIGNABLE !"). 
aetoile(Pf,Pu,Qs,Num) :- 
	suppress_min([[_,_,_],U1],Pf,_),
	final_state(U1)  -> % si le nœud de valeur F minimum de Pf correspond à la situation terminale, alors on a trouvé une solution et on peut l’afficher (prédicat affiche_solution)
		suppress([U1,[F,H,G],Pere,A],Pu,_PuFin),
		insert([U1,[F,H,G],Pere,A],Qs,NewQs),
		/*cheminPu(CheminPu),cheminPf(CheminPf),cheminQ(CheminQ),
		writeToFileTree(PuFin,CheminPu,Num),
		writeToFileTree(Pf,CheminPf,Num),
		writeToFileTree(NewQs,CheminQ,Num),
		writeToFileTaquinTransition(Pere,A,U),*/
		write("SUCCES !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n"),
		affiche_solution(NewQs,U1),longueurChaine(NewQs,U1,0,Lo), Locorrected is Lo-1,writef("Longueur : %t\n",[Locorrected])
					; % (cas général) sinon
		% on enlève le nœud de Pf correspondant à l’état U à développer (celui de valeur F minimale) et on enlève aussi  le nœud frère associé dans Pu
		suppress_min([[F,H,G],U],Pf,NewPf),
		suppress([U,[F,H,G],Pere1,A],Pu,NewPu),
		% développement de U
		% déterminer tous  les  nœuds  contenant  un  état successeur  S de  la  situation  U  et  calculer  leur  évaluation  [Fs,  Hs,  Gs]  (prédicat expand) connaissant Gu et le coût pour passer de U à S
		/*cheminPu(CheminPu),cheminPf(CheminPf),cheminQ(CheminQ),
		writeToFileTree(Pu,CheminPu,Num),
		writeToFileTree(Pf,CheminPf,Num),
		writeToFileTree(Qs,CheminQ,Num),
		writeToFileTaquinTransition(Pere1,A,U),*/
		expand(U,G,Lsuccesseurs),
		writeToFileExpandResult(Lsuccesseurs),
		% traiter chaque nœud successeur  (prédicat loop_successors) :
        loop_successors(Lsuccesseurs, NewPu, NewPf, Qs, Pu_new, Pf_new,Num),
		insert([U,[F,H,G],Pere1,A],Qs,NewQs),Num1 is Num+1,
		aetoile(Pf_new, Pu_new, NewQs,Num1)
	.

   