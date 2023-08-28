import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

response = pd.read_csv('exercise4.csv')
time = response['Time(s)'].values
initial = response['ResponseKp1_Tiinf_Td0'].values
first = response['ResponseKp6_TiinfTd0'].values
second = response['ResponseKp6_Tiinf_Td1'].values
third = response['ResponseKp6_Tiinf_Td0.25'].values

plt.plot(time, initial, color='darkblue', label = r'K_p=1,T_i=inf,T_d=0')
plt.plot(time, first, color='darkblue', alpha = 0.7, label = r'K_p=6,T_i=inf,T_d=0')
plt.plot(time, second, color='darkblue', alpha = 0.5, label = r'K_p=6,T_i=inf,T_d=1')
plt.plot(time, third, color='darkblue', alpha = 0.3, label = r'K_p=6,T_i=inf,T_d=0.25')
plt.xlabel(r'Time $[s]$')
plt.ylabel(r'Angular Position $[rad]$')
plt.title(r'Angular position vs Time with Step Input [2$\pi$ V]')
plt.grid(True, color = 'lightgrey', linestyle = '--')
plt.legend()
plt.show()