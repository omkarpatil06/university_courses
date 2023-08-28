import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

dc_motor_large = pd.read_csv('large_exercise2.csv')
dc_motor_small = pd.read_csv('small_exercise2.csv')
real_angvel_large = np.array(dc_motor_large['Real angular velocity B1 (rad/s)'].values).tolist()
simulated_angvel_large1 = dc_motor_large['Simulated angular velocity B1 (rad/s)'].values
simulated_angvel_large2 = dc_motor_large['Simulated angular velocity B2 (rad/s)'].values
simulated_angvel_large3 = dc_motor_large['Simulated angular velocity B3 (rad/s)'].values
time = np.array(dc_motor_large['Real time B1 (s)'].values).tolist()
initial_large = real_angvel_large[0]
stead_state_large = real_angvel_large[len(real_angvel_large)-2]
timeconstant_large = 0.632*stead_state_large
closest_timeconstant_large = min(real_angvel_large, key = lambda x: abs(x - timeconstant_large))
index = real_angvel_large.index(closest_timeconstant_large)
time_timeconstant_large = time[index]

real_angvel_small = np.array(dc_motor_small['Real angular velocity B1 (rad/s)'].values).tolist()
simulated_angvel_small1 = dc_motor_small['Simulated angular velocity B1 (rad/s)'].values
simulated_angvel_small2 = dc_motor_small['Simulated angular velocity B2 (rad/s)'].values
simulated_angvel_small3 = dc_motor_small['Simulated angular velocity B3 (rad/s)'].values
time = np.array(dc_motor_small['Real time B1 (s)'].values).tolist()
initial_small = real_angvel_small[0]
stead_state_small = real_angvel_small[len(real_angvel_small)-1]
print(stead_state_small)
timeconstant_small = 0.632*stead_state_small
closest_timeconstant_small = min(real_angvel_small, key = lambda x: abs(x - timeconstant_small))
print(closest_timeconstant_small)
index = real_angvel_small.index(closest_timeconstant_small)
time_timeconstant_small = time[index]
print(time_timeconstant_small)

fig, axs = plt.subplots(1, 2, figsize = (12, 5))
axs[0].plot(time, real_angvel_large, color='red', label=r'Real $\omega$')
axs[0].plot(time, simulated_angvel_large1, color='darkblue', alpha = 0.3, label=r'Simulated $\omega_1$')
axs[0].plot(time, simulated_angvel_large2, color='darkblue', alpha = 0.6, label=r'Simulated $\omega_2$')
axs[0].plot(time, simulated_angvel_large3, color='darkblue', alpha = 0.9, label=r'Simulated $\omega_3$')
axs[0].axhline(y = initial_large, color='black', linestyle='dashed')
axs[0].text(3.3, -9, r'$\omega_{o}$ = 0', color = 'black')
axs[0].axhline(y = stead_state_large, color='black', linestyle='dashed')
axs[0].text(3.1, 243, r'$\omega_{ss}$ = 238.79', color = 'black')
axs[0].axhline(y = closest_timeconstant_large, color='black', linestyle='dashed')
axs[0].text(3.1, 140, r'$\omega_{\tau}$ = 151.08', color = 'black')
axs[0].axvline(x = time_timeconstant_large, color='black', linestyle='dashed')
axs[0].text(1.55, 40, r'$t_{\tau}$ = 1.42', color = 'black')
axs[0].set_xlabel(r'Time $[s]$')
axs[0].set_ylabel(r'Angular Velocity $[rads^{-1}]$')
axs[0].set_title('Angular velocity vs Time of a DC Motor with Disk 1')
axs[0].grid(True, color = 'lightgrey', linestyle = '--')
axs[0].legend()

axs[1].plot(time, real_angvel_small, color='red', label=r'Real $\omega$')
axs[1].plot(time, simulated_angvel_small1, color='darkblue', alpha = 0.3, label=r'Simulated $\omega_1$')
axs[1].plot(time, simulated_angvel_small2, color='darkblue', alpha = 0.6, label=r'Simulated $\omega_2$')
axs[1].plot(time, simulated_angvel_small3, color='darkblue', alpha = 0.9, label=r'Simulated $\omega_3$')
axs[1].axhline(y = initial_small, color='black', linestyle='dashed')
axs[1].text(3.3, -9, r'$\omega_{o}$ = 0', color = 'black')
axs[1].axhline(y = stead_state_small, color='black', linestyle='dashed')
axs[1].text(3.1, 244.5, r'$\omega_{ss}$ = 239.53', color = 'black')
axs[1].axhline(y = closest_timeconstant_small, color='black', linestyle='dashed')
axs[1].text(3.1, 140, r'$\omega_{\tau}$ = 152.27', color = 'black')
axs[1].axvline(x = time_timeconstant_small, color='black', linestyle='dashed')
axs[1].text(1.3, 40, r'$t_{\tau}$ = 1.09', color = 'black')
axs[1].set_xlabel(r'Time $[s]$')
axs[1].set_ylabel(r'Angular Velocity $[rads^{-1}]$')
axs[1].set_title('Angular velocity vs Time of a DC Motor with Disk 2')
axs[1].grid(True, color = 'lightgrey', linestyle = '--')
axs[1].legend()

plt.show()