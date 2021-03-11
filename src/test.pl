:- [taquin].
:- [aetoile].
:- [avl].

testHeuristique1 :-
    final_state(F),
    heuristique1(F,H),H = 0,
    heuristique1([[a,vide,c],
                [d,b,f],
                [g,h,e]],4),
    heuristique1([[a,b,c],
                [d,h,f],
                [g,vide,e]],3),
    heuristique1([[a,b,c],
                [vide,d,f],
                [g,h,e]],3),
    heuristique1([[a,b,c],
                [d,f,vide],
                [g,h,e]],3)
.
testHeuristique2 :-
    final_state(F),
    heuristique2(F,H),H = 0,
    heuristique2([[a,vide,c],% b (échanger avec vide), d (échanger avec b puis f), f (échanger avec e puis h ou b puis h), h (échanger avec g puis d ou b puis d) mal placées = 1 + 2 + 2 + 2 = 7
                [d,b,f],
                [g,h,e]],7),
    heuristique2([[a,b,c],
                [d,h,f],
                [g,vide,e]],5),
    heuristique2([[a,b,c],
                [vide,d,f],
                [g,h,e]],5),
    heuristique2([[a,b,c],
                [d,f,vide],
                [g,h,e]],5)
.
testExpand :-
    % test 1
    Minit = [[a,b,c],
                [d,vide,f],
                [g,h,e]],
    expand(    Minit , 0, Liste),
    Liste = [
                [[[a,vide,c],
                [d,b,f],
                [g,h,e]],_,Minit,up],

                [[[a,b,c],
                [d,h,f],
                [g,vide,e]],_,Minit,down],

                [[[a,b,c],
                [vide,d,f],
                [g,h,e]],_,Minit,left],

                [[[a,b,c],
                [d,f,vide],
                [g,h,e]],_,Minit,right]
            ],
    Minit1 = [[a,b,c],
                [d,e,f],
                [g,h,vide]],
    expand(    Minit1 , 0, Liste1),
    Liste1 = [
                [[[a,b,c],
                [d,e,vide],
                [g,h,f]],_,Minit1,up],

                [[[a,b,c],
                [d,e,f],
                [g,vide,h]],_,Minit1,left]
            ]
.

testLoop_successors :-
    % test avec un état possible
    S0 = [[a,b,c],
        [d,vide,f],
        [g,h,e]],
    /* Pensez à changer l'heuristique utilisée dans taquin.pl  (heuristique 1 ici)
    G0 is 0, 
	heuristique1(S0,H0),
	F0 is H0,
	% créer 3 AVL Pf, Pu et Q initialement vides
	empty(Pf),empty(Pu),empty(Q),
	% insérer un noeud [ [F0,H0,G0], S0 ]dans Pf  et un noeud[S0, [F0,H0,G0], nil, nil]dans Pu
	insert([[F0,H0,G0],S0],Pf,Pf1),
	insert([S0,[F0,H0,G0],nil,nil],Pu,Pu1),
    suppress_min([[F,H,G],U],Pf1,NewPf),
    suppress([U,[F,H,G],_Pere,_A],Pu1,NewPu),
    expand(U,0,Lsuccesseurs),
    loop_successors(Lsuccesseurs,NewPu,NewPf,Q,PuEnd,PfEnd,0),
    put_flat_liste(PuEnd,_),
    put_flat_liste(PfEnd,Liste2),
    
    Liste2 = [

                [[4,3,1],[[a,b,c],
                [vide,d,f],
                [g,h,e]]],% d, f, h mal placées

                [[4,3,1],[[a,b,c],
                [d,h,f],
                [g,vide,e]]],% d, f, h mal placées


                [[4,3,1],[[a,b,c],
                [d,f,vide],
                [g,h,e]]], % d, f, h mal placées

                [[5,4,1],[[a,vide,c],
                [d,b,f],
                [g,h,e]]] % b, d, f, h mal placées
            ],!*/
    % /* Penser à changer l'heuristique utilisée (heuristique 2 ici)
    G2 is 0, 
    heuristique2(S0,H2),
	F2 is H2,
    % créer 3 AVL Pf, Pu et Q initialement vides
	empty(Pf_2),empty(Pu_2),empty(Q_2),
	% insérer un noeud [ [F0,H0,G0], S0 ]dans Pf  et un noeud[S0, [F0,H0,G0], nil, nil]dans Pu
	insert([[F2,H2,G2],S0],Pf_2,Pf1_2),
	insert([S0,[F2,H2,G2],nil,nil],Pu_2,Pu1_2),
    suppress_min([[F2,H2,G2],U_2],Pf1_2,NewPf_2),
    suppress([U_2,[F2,H2,G2],_Pere2,_A2],Pu1_2,NewPu_2),
    expand(U_2,0,Lsuccesseurs_2),
    write("fin EXPAND ?\n"),
    loop_successors(Lsuccesseurs_2,NewPu_2,NewPf_2,Q_2,_,PfEnd_2,0),
    put_flat_liste(PfEnd_2,Liste2_2),
    writef("PuEnd_2 : %t\n",[Liste2_2]),
    S0 = [[a,b,c],
        [d,vide,f],
        [g,h,e]],
    Liste2_2 = [
                % entre parenthèse les actions à réaliser pour déplacer la pièce sur la bonne position
                [[6,5,1],[[a,b,c],
                [vide,d,f],
                [g,h,e]]],% d (à échanger avec f), f (à échanger avec d puis h ou e puis h), h (échanger avec g puis vide ou d puis vide) mal placées = 1 + 2 + 2 = 5

                [[6,5,1],[[a,b,c],
                [d,h,f],
                [g,vide,e]]],% d (échanger avec h puis f), f (échanger avec h puis vide ou e puis vide), h (échanger avec d) mal placées = 2 + 2 + 1 = 5


                [[6,5,1],[[a,b,c],
                [d,f,vide],
                [g,h,e]]], % d (échanger avec f puis vide), f (échanger avec h), h (échanger avec g puis d ou b puis d) mal placées = 2 + 1 + 2 = 5

                [[8,7,1],[[a,vide,c],
                [d,b,f],
                [g,h,e]]] % b (échanger avec vide), d (échanger avec b puis f), f (échanger avec e puis h ou b puis h), h (échanger avec g puis d ou b puis d) mal placées = 1 + 2 + 2 + 2
            ],! %*/
.
