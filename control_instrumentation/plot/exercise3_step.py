import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

dc_motor_large = pd.read_csv('large_exercise3.csv')
dc_motor_small = pd.read_csv('small_exercise3.csv')

input_ang_large = dc_motor_large['Input Angular Position C1 (rad)'].values
output_ang_large = np.array(dc_motor_large['Output Angular Position C1 (rad)'].values).tolist()
output_ang_disturbance_large = dc_motor_large['Output Angular Position C1 disturbance (rad)'].values
input_ang_small = dc_motor_small['Input Angular Position C1 (rad)'].values
output_ang_small = np.array(dc_motor_small['Output Angular Position C1 (rad)'].values).tolist()
time = np.array(dc_motor_large['Input time stamp C1 (s)'].values).tolist()

peak_theta = max(output_ang_large)
index_peak_theta = output_ang_large.index(peak_theta)
peak_time = time[index_peak_theta]
input_steady_state = sum(input_ang_large[(len(input_ang_large) - 100):len(input_ang_large)])/len(input_ang_large[(len(input_ang_large) - 100):len(input_ang_large)])

fig, axs = plt.subplots(1, 2, figsize = (12, 5))
axs[0].plot(time, input_ang_large, color='red', label=r'Input $\theta$')
axs[0].plot(time, output_ang_large, color='darkblue', label=r'Output $\theta$')
axs[0].plot(time, output_ang_disturbance_large, color='darkblue', alpha = 0.5, label=r'Disturbed $\theta$')
axs[0].axhline(y = peak_theta, color='black', linestyle='dashed')
axs[0].text(1.6, 9.4, r'$\theta_{max}}$ = 9.983', color = 'black')
axs[0].axvline(x = peak_time, color='black', linestyle='dashed')
axs[0].text(1.5, 1.75, r'$t_{max}}$ = 1.414', color = 'black')
axs[0].axhline(y = input_steady_state, color='black', linestyle='dashed')
axs[0].text(-0.075, 6.4, r'$\theta_{ss}}$ = 6.283', color = 'black')
axs[0].set_xlabel(r'Time $[s]$')
axs[0].set_ylabel(r'Angular Position $[rad]$')
axs[0].set_title(r'Angular position vs Time with Disk 1 Step Input [2$\pi$ V]')
axs[0].grid(True, color = 'lightgrey', linestyle = '--')
axs[0].legend()

peak_theta = max(output_ang_small)
index_peak_theta = output_ang_small.index(peak_theta)
peak_time = time[index_peak_theta]

axs[1].plot(time, input_ang_small, color='red', label=r'Input $\theta$')
axs[1].plot(time, output_ang_small, color='darkblue', label=r'Output $\theta$')
axs[1].axhline(y = peak_theta, color='black', linestyle='dashed')
axs[1].text(1.4, 7.775, r'$\theta_{max}}$ = 8.210', color = 'black')
axs[1].axvline(x = peak_time, color='black', linestyle='dashed')
axs[1].text(1.3, 1.75, r'$t_{max}}$ = 1.196', color = 'black')
axs[1].axhline(y = input_steady_state, color='black', linestyle='dashed')
axs[1].text(-0.075, 6.4, r'$\theta_{ss}}$ = 6.283', color = 'black')
axs[1].set_xlabel(r'Time $[s]$')
axs[1].set_ylabel(r'Angular Position $[rad]$')
axs[1].set_title(r'Angular position vs Time with Disk 2 Step Input [2$\pi$ V]')
axs[1].grid(True, color = 'lightgrey', linestyle = '--')
axs[1].legend()

plt.show()