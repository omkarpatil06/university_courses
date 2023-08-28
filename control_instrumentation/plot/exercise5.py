import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

ultimate_gain = pd.read_csv('exercise5.csv')

time = ultimate_gain['Time(s)'].values
expected = np.array(ultimate_gain['Setpoint'].values).tolist()
sustained = np.array(ultimate_gain['SustainedOscillation'].values).tolist() 
pid_gain = np.array(ultimate_gain['ZNPID'].values).tolist()
optimised = np.array(ultimate_gain['Optimised'].values).tolist()

plt.xlabel(r'Time $[s]$')
plt.ylabel(r'Angular Position $[rads]$')
plt.title(r'Angular position vs Time with Z-N Ultimate Gain Method')
plt.plot(time, expected, color='red', label = r'Input $2\pi$rad step')
plt.plot(time, sustained, color='darkblue', alpha = 0.2, label = r'Sustained Oscillations')
plt.plot(time, pid_gain, color='darkblue', alpha = 0.6, label = r'Ultimate Gain')
plt.plot(time, optimised, color='darkblue', label = r'Optimised Controller')
plt.grid(True, color = 'lightgrey', linestyle = '--')
plt.legend()
plt.show()