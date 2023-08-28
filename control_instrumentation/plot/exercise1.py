import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression

dc_motor = pd.read_csv('exercise1.csv')
voltage = np.array(dc_motor['Input Voltage (V)'].values).reshape(-1, 1)
ang_vel = np.array(dc_motor['Angular Velocity (rad/s)'].values).reshape(-1, 1)
gain = dc_motor['Angular Velocity (rad/s)']/dc_motor['Input Voltage (V)']
model = LinearRegression()
model.fit(voltage, ang_vel)
model.score(voltage, ang_vel)
m, c = model.coef_[0][0], model.intercept_[0]                       

x = np.arange(start = -10, stop = 10, step = 0.01)
y = [m*i + c for i in x]
final_gain = gain[len(gain)-1]

fig, axs = plt.subplots(1, 2, figsize = (12, 5))

axs[0].plot(voltage, gain, color = 'darkblue')
axs[0].axhline(y = final_gain, color='darkblue', alpha = 0.4, linestyle='dashed')
axs[0].text(-10, 22.5, r'$K_v = 23.93$', color = 'darkblue', alpha = 0.4)
axs[0].set_xlabel('Voltage [V]')
axs[0].set_ylabel('Motor Gain')
axs[0].set_title('Motor Gain vs Input Voltage of a DC Motor')
axs[0].grid(True, color = 'lightgrey', linestyle = '--')

axs[1].plot(voltage, ang_vel, color = 'darkblue', linewidth = 2, label = 'Measured Angular Velocity vs Voltage')
axs[1].plot(x, y, color = 'darkblue', linestyle='dashed', alpha = 0.4, label = 'Least Squares Approximation')
axs[1].text(-1.5, 60, r'$\omega = K_v v_m$', color = 'darkblue')
axs[1].text(2.5, 25, r'$y = 23.783x + 0.074$', color = 'darkblue', alpha = 0.4)
axs[1].set_xlabel('Voltage [V]')
axs[1].set_ylabel('Angular Velocity [rad/s]')
axs[1].set_title('Angular Velocity vs Input Voltage of a DC Motor')
axs[1].grid(True, color = 'lightgrey', linestyle = '--')
axs[1].legend()

plt.show()