import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

dc_motor_large = pd.read_csv('large_exercise3.csv')
dc_motor_small = pd.read_csv('small_exercise3.csv')

#input_ang_ramp100_small = np.array(dc_motor_small['Input Angular Position C2 (rad)'].values).tolist()
#output_ang_ramp100_small = np.array(dc_motor_small['Output Angular Position C2 (rad)'].values).tolist()
#input_ang_ramp100_large = np.array(dc_motor_large['Input Angular Position C2 (rad)'].values).tolist()
#output_ang_ramp100_large = np.array(dc_motor_large['Output Angular Position C2 (rad)'].values).tolist()
#output_ang_ramp100_disturbance_large = np.array(dc_motor_large['Output Angular Position C2 disturbance (rad)'].values).tolist()

input_ang_ramp10_small = np.array(dc_motor_small['Input Angular Position C3 (rad)'].values).tolist()
output_ang_ramp10_small = np.array(dc_motor_small['Output Angular Position C3 (rad)'].values).tolist()
input_ang_ramp10_large = np.array(dc_motor_large['Input Angular Position C3 (rad)'].values).tolist()
output_ang_ramp10_large = np.array(dc_motor_large['Output Angular Position C3 (rad)'].values).tolist()
time = np.array(dc_motor_small['Input time stamp C1 (s)'].values).tolist()

error_ramp10_small = []
error_ramp10_large = []
for i in range(len(input_ang_ramp10_small)):
    error_ramp10_small.append(input_ang_ramp10_small[i] - output_ang_ramp10_small[i])
    error_ramp10_large.append(input_ang_ramp10_large[i] - output_ang_ramp10_large[i])
average_steadystate_small = sum(error_ramp10_small[(len(error_ramp10_small)-200):len(error_ramp10_small)])/200
average_steadystate_large = sum(error_ramp10_large[(len(error_ramp10_large)-200):len(error_ramp10_large)])/200
print(average_steadystate_small)
print(average_steadystate_large)

plt.plot(time, error_ramp10_small, color='darkblue', label=r'Disk 2 Error $e$')
plt.plot(time, error_ramp10_large, color='darkblue', alpha = 0.5, label=r'Disk 1 Error $e$')
plt.axhline(y = average_steadystate_small, color='darkblue', linestyle = '--')
plt.text(0.1, 0.59, r'$e_{ss} = 0.530$', color='darkblue', alpha = 0.5)
plt.text(0.1, 0.4, r'$e_{ss} = 0.512$', color='darkblue')
plt.axhline(y = average_steadystate_large, color='darkblue', alpha = 0.5, linestyle = '--')
plt.xlabel(r'Time $[s]$')
plt.ylabel(r'Error $[rad]$')
plt.title(r'Error vs Time with Disk 1 and 2 Ramp (10 $rads^{-1}$)')
plt.grid(True, color = 'lightgrey', linestyle = '--')
plt.legend()
plt.show()