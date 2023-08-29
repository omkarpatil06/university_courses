import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

file_name = 'oscilloscope.csv'
component_tested = 'Oscilloscope Output (TP2) [Analyse Tool]'
freq_response = pd.read_csv(file_name)
freq = np.array(freq_response['Frequency (Hz)'].values).tolist()
gain_db = np.array(freq_response['Gain (dB)'].values).tolist()

moving_avg_window = 5
conv_coef = np.ones(moving_avg_window)/moving_avg_window
gain_db_smooth = np.convolve(gain_db, conv_coef, mode='same').tolist()
peak_value = max(gain_db_smooth)
peak_index, cutoff_gain = gain_db_smooth.index(peak_value), peak_value - 3
closest_value1 = min(gain_db_smooth[50:len(gain_db_smooth)], key=lambda x: abs(x - cutoff_gain))
cutoff_freq1_index = gain_db_smooth.index(closest_value1)
#closest_value2 = min(gain_db_smooth[150:300], key=lambda x: abs(x - cutoff_gain))
#cutoff_freq2_index = gain_db_smooth.index(closest_value2)


plt.plot(freq[2:len(freq)-5], gain_db_smooth[2:len(gain_db_smooth)-5], 'k')
plt.scatter(freq[peak_index], peak_value, c='k')
plt.scatter(freq[cutoff_freq1_index], closest_value1, c='k')
#plt.scatter(freq[cutoff_freq2_index], closest_value2, c='k')
plt.axhline(y = closest_value1, color='k', linestyle='--')
plt.axvline(x = freq[cutoff_freq1_index], color='k', linestyle='--')
#plt.axvline(x = freq[cutoff_freq2_index], color='k', linestyle='--')
#plt.text(round(freq[peak_index], -6), peak_value, f'({freq[peak_index]}, {peak_value})', ha='center', va='top')
#plt.text(freq[cutoff_freq1_index], closest_value1, f'({freq[cutoff_freq1_index]}, {closest_value1})', ha='center', va='top')
#plt.text(freq[cutoff_freq2_index], closest_value2, f'({freq[cutoff_freq2_index]}, {closest_value2})', ha='center', va='top')
plt.xscale('log')
plt.xlabel('Frequency (Hz)')
plt.ylabel('Gain (dB)')
plt.title(f'Magnitude Response at {component_tested}')
plt.grid(True, which='both', axis='both', linestyle='--', linewidth=0.5, color='gray', alpha=0.5, zorder=-1, markevery=0.1)
plt.show()