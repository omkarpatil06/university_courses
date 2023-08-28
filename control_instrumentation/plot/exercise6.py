import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

reaction_curve = pd.read_csv('exercise6.csv')
time = reaction_curve['Time(s)'].values
expected = np.array(reaction_curve['Expected'].values).tolist()
open_loop = np.array(reaction_curve['OpenLoop'].values).tolist()
closed_loop = np.array(reaction_curve['ClosedLoop'].values).tolist()
closed_loop_optimised = np.array(reaction_curve['Optimised'].values).tolist()

plt.xlabel(r'Time $[s]$')
plt.ylabel(r'Angular Velocity $[rads^{-1}]$')
plt.title(r'Angular velocity vs Time with Z-N Reaction Curve Method')
plt.plot(time, expected, color='red', label = r'Input 100$rads^{-1}$ step')
plt.plot(time, open_loop, color='darkblue', label = r'Open-loop response')
plt.plot(time, closed_loop, color='darkblue', alpha = 0.6, label = r'Original Closed-loop')
plt.plot(time, closed_loop_optimised, color='darkblue', alpha = 0.4, label = r'Optimised Closed-loop')
plt.grid(True, color = 'lightgrey', linestyle = '--')
plt.legend()
plt.show()