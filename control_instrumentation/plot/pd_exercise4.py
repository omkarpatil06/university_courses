import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

response = pd.read_csv('exercise4.csv')
time = response['Time(s)'].values
initial = np.array(response['ResponseKp1_Tiinf_Td0'].values).tolist()
third = np.array(response['ResponseKp6_Tiinf_Td0.25'].values).tolist()

peak_theta_inital = max(initial)
index_peak_theta_initial = initial.index(peak_theta_inital)
peak_time_initial = time[index_peak_theta_initial]
peak_theta = max(third)
index_peak_theta = third.index(peak_theta)
peak_time = time[index_peak_theta]
print(peak_theta_inital)
print(peak_theta)
print(peak_time_initial)
print(peak_time)

steady_state_initial = initial[len(initial)-1]
timeconstant_initial = steady_state_initial*0.632
closest_timeconstant_initial = min(initial, key = lambda x: abs(x - timeconstant_initial))
index_initial = initial.index(closest_timeconstant_initial)
time_timeconstant_initial = time[index_initial]
stead_state = third[len(third)-1]
timeconstant = 0.632*stead_state
closest_timeconstant= min(third, key = lambda x: abs(x - timeconstant))
index = third.index(closest_timeconstant)
time_timeconstant = time[index]
print(steady_state_initial)
print(stead_state)
print(closest_timeconstant)
print(time_timeconstant_initial)
print(time_timeconstant)

plt.plot(time, initial, color='red', label = r'$K_p=1,T_i=inf,T_d=0$')
plt.axvline(x = 1.222, color='red', alpha=0.5, linestyle = '--')
plt.text(1.4, 8.5, r'$\theta_{max} = 8.57$', color='red', alpha=0.5)
plt.text(1.4, 8.15, r'$t_{max} = 1.22$', color='red', alpha=0.5)
plt.axhline(y = 6.366, color='red', alpha=0.5, linestyle = '--')
plt.text(6, 6.5, r'$\theta_{ss} = 6.37$', color='red', alpha=0.5)
plt.axhline(y = 4.05584, color='red', alpha=0.5, linestyle = '--')
plt.text(-0.1, 4.2, r'$t_{\tau} = 1.096$', color='red', alpha=0.5)

plt.plot(time, third, color='darkblue', label = r'$K_p=6,T_i=inf,T_d=0.25$')
plt.axvline(x = 1.118, color='darkblue', alpha=0.5, linestyle = '--')
plt.text(-0.2, 6.9, r'$\theta_{max} = 6.58$', color='darkblue', alpha=0.5)
plt.text(-0.2, 6.55, r'$t_{max} = 1.12$', color='darkblue', alpha=0.5)
plt.axhline(y = 6.295, color='darkblue', alpha=0.5, linestyle = '--')
plt.text(6, 5.9, r'$\theta_{ss} = 6.30$', color='darkblue', alpha=0.5)
plt.axhline(y = 6.366, color='red', alpha=0.5, linestyle = '--')
plt.axhline(y = 3.97914, color='darkblue', alpha=0.5, linestyle = '--')
plt.text(-0.1, 3.6, r'$t_{\tau} = 1.068$', color='darkblue', alpha=0.5)

plt.xlabel(r'Time $[s]$')
plt.ylabel(r'Angular Position $[rad]$')
plt.title(r'Angular position vs Time with Step Input [2$\pi$ V]')
plt.grid(True, color = 'lightgrey', linestyle = '--')
plt.legend()
plt.show()