import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# tl40 = pd.read_csv('40mm.csv')
# tl100 = pd.read_csv('100mm.csv')
# tl160 = pd.read_csv('160mm.csv')

# s11_dB = np.array(tl100['S11/dB'].values).tolist()
# freq = np.array(tl160['Frequency[Hz]'].values).tolist()
# print((1 + 10**(-11.2/20))/(1 - 10**(-11.2/20)))

swr = [16.72, 5.46, 2.44, 1.72, 1.07, 1.54, 1.76]
fre = [286, 586, 870, 1200, 1725, 2025, 2370]

plt.plot(fre, swr, color = 'darkblue')
plt.xlabel(r'Frequency $[MHz]$')
plt.ylabel(r'Standing Wave Ratio (SWR)')
plt.title('Standing Wave Ratio (SWR) vs Frequency')
plt.grid(True, color = 'lightgrey', linestyle = '--')
plt.show()