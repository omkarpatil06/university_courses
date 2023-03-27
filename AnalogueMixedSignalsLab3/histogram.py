import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

file_name = 'noise_transmitter_off.csv'
transient = pd.read_csv(file_name)
time = np.array(transient['Time (s)'].values).tolist()
voltage = np.array(transient['Volt (V)'].values)

var = np.var(voltage)
mean = np.mean(voltage)
x = np.linspace(np.min(voltage), np.max(voltage), 1000)
nor_dist = 1.3*np.array((1/(np.sqrt(2*np.pi*var)))*np.exp(-0.5*((x-mean)/np.sqrt(var))**2))

plt.plot(x, nor_dist, 'k', linestyle = '--')
plt.hist(voltage, bins=16, color = 'lightgrey', ec = 'black')
plt.xlabel('Voltage (V)')
plt.ylabel('Frequency')
plt.text(-0.0063, 325, f'σ²(Noise) = {round(np.var(voltage), 10)}')
plt.title('Receiver Noise Frequency Histogram')
plt.show()