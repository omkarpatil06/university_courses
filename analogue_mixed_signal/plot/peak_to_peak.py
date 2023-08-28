import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

file_name = 'peak_to_peak.csv'
component_tested = 'Peak to Peak Voltage'
transient = pd.read_csv(file_name)
time = np.array(transient['Time (s)'].values).tolist()
voltage = np.array(transient['Volt (V)'].values).tolist()

moving_avg_window = 1
conv_coef = np.ones(moving_avg_window)/moving_avg_window
voltage_smooth = np.convolve(voltage, conv_coef, mode='same').tolist()
max_value = max(voltage_smooth)
min_value = min(voltage_smooth)
start_point_index = voltage_smooth.index(max_value)
end_point_index = voltage_smooth.index(min_value)
voltage_differential = abs(max_value - min_value)
print(voltage_differential)

plt.plot(time, voltage, 'k')
plt.scatter(time[start_point_index], max_value, c='k')
plt.scatter(time[end_point_index], min_value, c='k')
plt.axhline(y = max_value, color='k', linestyle='--')
plt.axhline(y = min_value, color='k', linestyle='--')
plt.text(-2.67E-06, 0, f'Vₚₖ₋ₚₖ = {round(voltage_differential,10)} [V]')
plt.xlabel('Time (s)')
plt.ylabel('Voltage (V)')
plt.title(f'{component_tested} Analysis')
plt.grid(True, which='both', axis='both', linestyle='--', linewidth=0.5, color='gray', alpha=0.5, zorder=-1, markevery=0.1)
plt.show()