import plotly.graph_objects as go
import re
from pathlib import Path
from typing import List

import numpy as np
import plotly.graph_objects as go

"""
Manuel : 
Exécuter au préalable le programme aetoile de prolog
Pour afficher chaque situation du taquin, comme on ne sait pas forcément quelle branche développe prolog avec le backtrack 
on affichera en parallèle la matrice avant l'action et après l'action
(Les taquins s'ouvrent tout seuls (et sont également stockée sous forme html dans le dossier out) 
et on peut avancer dans les états avec le slider
"""
out_path = str(Path(__file__).parent.parent.parent / "out")
with open(out_path+"/logsTaquinTransition.txt", "r") as f:
    file = f.read().split("\n")

Ldata = []
def format_array_str(array_str: str) -> np.ndarray:
    # Ajouter les guillemets pour permettre l'évaluation python en liste
    formatted_array_str: str = re.sub(r"([^\[,\]]+)",r"'\1'",array_str)
    array: List[List[str]] = eval(formatted_array_str)
    # Tourner les arrays de telle sorte à ce qu'elles soient dans le même sens que brutes
    # (ss la forme [[...],[.... ... ) lors de la visualisation :
    array: np.ndarray =     np.array(array).T.tolist()
    return array
for step, line in enumerate(file):
    if line == "":
        continue
    print(line)
    [arrayPere,action,array] = line.split(";")
    array =     format_array_str(array)
    arrayPere = format_array_str(arrayPere)
    Ldata.append([step,array,action,arrayPere])

# Add traces, one for each slider step
for mode in ["pere","fils"]:
    # Create figure
    fig = go.Figure()
    for [step,array,action,arrayPere] in Ldata:
        fig.add_trace(
            go.Table(cells=dict(values=array if mode == "fils" else arrayPere,
                                fill_color='white',
                                line_color='black',
                                align='center',
                                font=dict(color='black', family="Lato", size=15),height=100
                                ),
                                header=dict(values=list(mode+"De"+action for _ in range(3)),
                                font=dict(color='black', family="Lato", size=15),)))

    fig.data[0].visible = True
    print(len(fig.data))

    # Create and add slider
    steps = []
    for i, liste in enumerate(Ldata):
        step = dict(
            method="update",
            args=[{"visible": [False] * len(Ldata)},
                  {"title": "Slider switched to step: " + str(i)}],  # layout attribute
        )
        step["args"][0]["visible"][i] = True  # Toggle i'th trace to "visible"
        steps.append(step)
    sliders = [dict(
        active=10,
        currentvalue={"prefix": "Frequency: "},
        pad={"t": 50},
        steps=steps
    )]

    fig.update_layout(
        sliders=sliders,
        width=750, height=750
    )

    fig.show()
    fig.write_html(out_path+"/debugMode"+mode+".html")