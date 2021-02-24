from pyswip import Prolog
prolog = Prolog()
prolog.consult("./TP1/taquin.pl")

import random
import numpy as np
from typing import List
lettres = "abcdefgh"
class Matrix:
    reference = [["a", "b",  "c"],
               ["h","vide", "d"],
               ["g", "f",  "e"]]
    def __init__(self):
        self.m : List[str] = random.sample([l for l in lettres],len(lettres))
        self.m.insert(random.randint(0,len( self.m)-1),"vide")
        self.m = np.reshape(self.m,(3,3)).tolist()
        self.m_prolog : str = str(self.m).replace("'","")
    def get_python_matrix(self):
        return self.m
    def get_prolog_matrix(self):
        return self.m_prolog
    def compare_results(self):
        # Calcul de H ave python
        liste_diff = [[i!=j and i!="vide" for i,j in zip(l,lref)]\
                    for l,lref \
                    in zip(self.m,Matrix.reference)]
        h : int = sum(
                    sum(l) for l in liste_diff)
        # Calcul de H avec prolog
        h_prolog : int = list(prolog.query(f"heuristique1({self.get_prolog_matrix()},H)"))[0]["H"]
        # Comparaison des métriques
        return h == h_prolog,h,h_prolog,liste_diff


for i in range(500):
    m : Matrix = Matrix()
    comp,h,h_prolog,liste_diff = m.compare_results()
    if comp is False:
        print(f"Not same result for input \n{m.get_python_matrix()}\nref :\n{m.reference}\nwith {h_prolog} errors according to prolog and {h} for python")
        print("Differences according to python")
        print([list(map(lambda x:'T' if x is True else 'F',l)) for l in liste_diff])
        print(f"input to test heuristique1({m.get_prolog_matrix()},H).")
        break
    
    
    