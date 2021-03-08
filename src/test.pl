:- [taquin].
:- [aetoile].
:- [avl].

testHeuristique1Fin :-
    final_state(F),
    heuristique1(F,H),H = 0
.
testHeuristique2Fin :-
    final_state(F),
    heuristique2(F,H),H = 0
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
    put_flat_liste(PuEnd,Liste1),
    put_flat_liste(PuEnd,Liste2)
.
