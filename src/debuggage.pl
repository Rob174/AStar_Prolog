cheminPu("../out/logsPu.txt").
cheminPf("../out/logsPf.txt").
cheminQ("../out/logsQ.txt").
cheminTaquinTransition("../out/logsTaquinTransition.txt").
cheminExpandResult("../out/logsExpandResult.txt").

writeToFileTree(nil,FileName,Num) :- 
	open(FileName,append,Out),write(Out,Num),
	write(Out,",nothing\n"),
    close(Out)
.
writeToFileTree(avl(G,R,D,_H),FileName,Num):-
	writeToFileTree(G,FileName,Num),
    open(FileName,append,Out),
	write(Out,Num),write(Out, ","), write(Out, R), 	write(Out,"\n"),
    close(Out),  
	writeToFileTree(D,FileName,Num).

writeToFileTaquinTransition(MPere,Action,MFille) :- 
    (MPere = nil -> cheminTaquinTransition(FileName),open(FileName,append,Out),
    write(Out,[[vide,vide,vide],[vide,vide,vide],[vide,vide,vide]]),write(Out,";"),
    write(Out,none),write(Out,";"),
    write(Out,MFille),
    write(Out,"\n"),
    close(Out)
    
    ;

    cheminTaquinTransition(FileName),open(FileName,append,Out),
    write(Out,MPere),write(Out,";"),
    write(Out,Action),write(Out,";"),
    write(Out,MFille),
    write(Out,"\n"),
    close(Out))
.

writeToFileExpandResult(Result) :-
    cheminExpandResult(Chemin),open(Chemin,append,Out),
    write(Out,Result),
    write(Out,"\n"),
    close(Out)
.
cleanFiles():-
    cheminTaquinTransition(FileName),open(FileName,write,Out),
    write(Out,""),
    close(Out),
    cheminExpandResult(FileName1),open(FileName1,write,Out1),
    close(Out1),
    cheminPu(FileNamePu),open(FileNamePu,write,OutPu),
    close(OutPu),
    cheminPf(FileNamePf),open(FileNamePf,write,OutPf),
    close(OutPf),
    cheminQ(FileNameQ),open(FileNameQ,write,OutQ),
    close(OutQ)

.

print_list([[A,B,C],[D,E,F],[G,H,I]]) :- writef("[['%t','%t','%t'],['%t','%t','%t'],['%t','%t','%t']]",[A,B,C,D,E,F,G,H,I]).