import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

file_name = 'rise_time.csv'
component_tested = 'Rise Time'
transient = pd.read_csv(file_name)
time = np.array(transient['Time (s)'].values).tolist()
voltage = np.array(transient['Volt (V)'].values).tolist()

moving_avg_window = 1
conv_coef = np.ones(moving_avg_window)/moving_avg_window
voltage_smooth = np.convolve(voltage, conv_coef, mode='same').tolist()
max_value = max(voltage_smooth)
min_value = min(voltage_smooth)
steady_state1 = sum(voltage_smooth[0:100])/len(voltage_smooth[0:100])
steady_state2 = sum(voltage_smooth[(len(voltage_smooth)-100):len(voltage_smooth)])/len(voltage_smooth[0:100])
steady_state_differential = abs(steady_state1-steady_state2)
start_point = steady_state1 + 0.1*steady_state_differential
start_point_index = voltage_smooth.index(min(voltage_smooth, key=lambda x: abs(x - start_point)))
end_point = steady_state1 + 0.9*steady_state_differential
end_point_index = voltage_smooth.index(min(voltage_smooth, key=lambda x: abs(x - end_point)))
time_differential = abs(time[start_point_index] - time[end_point_index])
print(time_differential)

plt.plot(time, voltage, 'k')
plt.scatter(time[start_point_index], start_point, c='k')
plt.scatter(time[end_point_index], end_point, c='k')
plt.axhline(y = start_point, color='k', linestyle='--')
plt.axhline(y = end_point, color='k', linestyle='--')
plt.text(-0.55E-06, 0, f'Δt = {round(time_differential,10)} [s]')
plt.xlabel('Time (s)')
plt.ylabel('Voltage (V)')
plt.title(f'{component_tested} Analysis')
plt.grid(True, which='both', axis='both', linestyle='--', linewidth=0.5, color='gray', alpha=0.5, zorder=-1, markevery=0.1)
plt.show()