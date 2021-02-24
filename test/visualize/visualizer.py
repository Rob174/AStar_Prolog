from os import name
import plotly.graph_objects as go
import plotly.figure_factory as ff
import numpy as np
import re
import numpy as np
MODE = 1
with open("/mnt/c/Users/robin/Documents/drive/TP IA Prolog/TP1/test.txt", "r") as f:
    file = f.read().split("\n")
    file = list(filter(lambda x: x[0] == "[", file))


# Create figure
fig = go.Figure()
L = []
# Add traces, one for each slider step
for step, line in enumerate(file):
    print(line)
    if MODE == 0:
        array, action,_ = eval(line)
    else:
        _, action,array = eval(line)

    array = np.flipud(np.fliplr(np.array(array).T.tolist()))
    print(array)
    L.append((array,action))
    fig.add_trace(
        go.Table(cells=dict(values=array,
                            fill_color='white',
                            line_color='black',
                            align='center',
                            font=dict(color='black', family="Lato", size=15),height=100
                            ),
                            header=dict(values=list("pereDe"+action if MODE == 1 else action for _ in range(3)),
                            font=dict(color='black', family="Lato", size=15),)))

# Make 10th trace visible
fig.data[0].visible = True

# Create and add slider
steps = []
for i, liste in enumerate(L):
    step = dict(
        method="update",
        args=[{"visible": [False] * len(L)},
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
fig.write_html("debug.html" if MODE == 0 else "debugPere.html")
