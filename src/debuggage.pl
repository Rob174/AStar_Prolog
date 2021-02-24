cheminPu("../out/logsPu.txt").
cheminPf("../out/logsPf.txt").
cheminQ("../out/logsQ.txt").
cheminTaquinTransition("../out/logsTaquinTransition.txt").

writeToFileTree(nil,FileName,_) :- 
	open(FileName,append,Out),
	write(Out,"nothing\n"),
    close(Out)
.
writeToFileTree(avl(G,R,D,_H),FileName,Num):-
	writeToFileTree(G,FileName,Num),
    open(FileName,append,Out),
	write(Out,Num),write(Out, ","), write(Out, R), 	write(Out,"\n"),
    close(Out),  
	writeToFileTree(D,FileName,Num).

writeToFileTaquinTransition(MPere,Action,MFille) :- 
    cheminTaquinTransition(FileName),open(FileName,append,Out),
    write(Out,MPere),write(Out,";"),
    write(Out,Action),write(Out,";"),
    write(Out,MFille),
    write(Out,"\n"),
    close(Out)
.
cleanFiles():-
    cheminTaquinTransition(FileName),open(FileName,write,Out),
    close(Out),
    cheminPu(FileNamePu),open(FileNamePu,write,OutPu),
    close(OutPu),
    cheminPf(FileNamePf),open(FileNamePf,write,OutPf),
    close(OutPf)
.

print_list([[A,B,C],[D,E,F],[G,H,I]]) :- writef("[['%t','%t','%t'],['%t','%t','%t'],['%t','%t','%t']]",[A,B,C,D,E,F,G,H,I]).