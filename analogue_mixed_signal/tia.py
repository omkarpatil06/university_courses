import numpy as np
from sklearn.linear_model import LinearRegression
import matplotlib.pyplot as plt

mega = 10**6
pico = 10**(-12)

def tia_resistor(freq_cutoff, cap_total, gbwp):
    return gbwp/(2*np.pi*cap_total*(freq_cutoff**2))

def tia_capacitor(resistor, cap_total, gbwp):
    alpha = 1/(4*np.pi*resistor*gbwp)
    return alpha*(1 + (1 + 8*np.pi*resistor*cap_total*gbwp)**0.5)

print(tia_resistor(8*mega, 26*pico, 100*mega))
print(tia_capacitor(tia_resistor(8*mega, 26*pico, 100*mega), 26*pico, 100*mega))

def trans_function(pd_resistance, resistor, cap_total, capacitor, freq):
    angular_freq = 2*np.pi*freq
    a = (resistor + pd_resistance)/pd_resistance
    b = capacitor + cap_total
    c = angular_freq*resistor*capacitor
     
    real_numerator = a + b*(c**2)/capacitor
    imaginary_numerator = (b*c)/capacitor - a*c
    denominator = pd_resistance + c**2
    return 20*np.log10(((real_numerator/denominator)**2 + (imaginary_numerator/denominator)**2)**0.5)

# freq = np.array(np.arange(2*mega, 8*mega + 100000, 100000)).reshape((-1,1))
# resistor = np.array([tia_resistor(freq[i], 26*pico, 100*mega) for i in range(len(freq))])
# capacitor = np.array([tia_capacitor(resistor[i], 26*pico, 100*mega) for i in range(len(freq))])
# # trans_func = np.array([trans_function(10**4, 10**4, 26*pico, 5*pico, freq[i]) for i in range(len(freq))])

# model = LinearRegression()
# model.fit(freq, trans_func)

# print((5*pico - model.intercept_)/model.coef_)
# print(tia_resistor((5*pico - model.intercept_)/model.coef_, 26*pico, 100*mega))

# plt.plot(freq, trans_func)
# # plt.plot(freq, capacitor_4, 'o')
# # plt.plot(freq, capacitor_5, 'o')
# # plt.plot(freq, capacitor_6, 'o')
# plt.xlabel('Cut-off Frequency (Hz)')
# plt.ylabel('TIA Resistor (Ohms)')
# plt.title('Cut-off frequency vs TIA resistor')
# plt.show()

def sallen_key(m1, fc1, capacitor1, fc2, capacitor2):
    q_butterworth = [[1.0, 0.5412], [1.0, 1.3065]]

    n1 = ((q_butterworth[0][1]*(m1 + 1))**2)/m1
    tau1 = 2*np.pi*q_butterworth[0][0]*((m1*n1)**0.5)*fc1
    resistor1 = 1/(tau1*capacitor1)
    sk1 = [resistor1*m1, resistor1, capacitor1, capacitor1*n1]

    coef = [0, 4, -1*(4 + (1/(q_butterworth[1][1]**2))), 1]
    m2 = np.roots(coef).tolist()
    tau2 = 2*np.pi*q_butterworth[1][0]*(m2[0]**0.5)*fc2
    resistor2 = 1/(tau2*capacitor2)
    sk2 = [resistor2*m2[0], resistor2, capacitor2, capacitor2]
    return sk1, sk2

print(sallen_key(0.25, 8*mega, 15*pico, 5.5*mega, 15*pico))