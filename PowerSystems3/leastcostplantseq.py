import pulp
import pandas as pd

power = pd.read_csv('LeastCostPlanningSequence.csv')
plant_type = power['Plant type'].values
plant_gwh = power['Plant GWh'].values
plant_number = power['Number of Plants']
plant_pounds_gwh = power['Max £/GWh'].values
max_load_hour = power['Max Load Demand'].values

power_plant = [0 for i in range(len(plant_type))]
prob = pulp.LpProblem("Power_System_Optimization", pulp.LpMinimize)

for i in range(len(plant_type)):
  power_plant[i] = pulp.LpVariable(plant_type[i], 0, plant_number[i]*plant_gwh[i], pulp.LpContinuous)

#gas = pulp.LpVariable("Gas Generator", 0, 15, pulp.LpContinuous)
#ccgt = pulp.LpVariable("CCGT Generator", 0, 612*10, pulp.LpContinuous)
#coal = pulp.LpVariable("Coal Generator", 0, 918*10, pulp.LpContinuous)
#diesel = pulp.LpVariable("Diesel Generator", 0, 16.2*100, pulp.LpContinuous)
#wind_on = pulp.LpVariable("Onshore Wind Generator", 0, 10.26*100, pulp.LpContinuous)
#wind_off = pulp.LpVariable("Offshore Wind Generator", 0, 13.68*100, pulp.LpContinuous)
#solar = pulp.LpVariable("Solar Generator", 0, 3.42*100, pulp.LpContinuous)
#hydro = pulp.LpVariable("Hydro Generator", 0, 342*10, pulp.LpContinuous)
#nuclear = pulp.LpVariable("Nuclear Generator", 600, 1836*3, pulp.LpContinuous)

prob += plant_pounds_gwh[0]*power_plant[0] + plant_pounds_gwh[1]*power_plant[1] + plant_pounds_gwh[2]*power_plant[2] + plant_pounds_gwh[3]*power_plant[3] + plant_pounds_gwh[4]*power_plant[4] + plant_pounds_gwh[5]*power_plant[5] + plant_pounds_gwh[6]*power_plant[6] + plant_pounds_gwh[7]*power_plant[7] + plant_pounds_gwh[8]*power_plant[8]
prob += power_plant[0] + power_plant[1] + power_plant[2] + power_plant[3] + power_plant[4] + power_plant[5] + power_plant[6] + power_plant[7] + power_plant[8] = max_load_hour[0]

prob.solve()
print("Optimization status:", pulp.LpStatus[prob.status])
print("Optimal cost:", pulp.value(prob.objective))
for i in range(len(plant_type)):
  print(f'{plant_type[i]}, {pulp.value(power_plant[i])}, {pulp.value(power_plant[i])/plant_gwh[i]}')

#print("Gas production level:", pulp.value(gas))
#print("CCGT production level:", pulp.value(ccgt), pulp.value(ccgt)/612)
#print("Coal production level:", pulp.value(coal), pulp.value(coal)/918)
#print("Diesel production level:", pulp.value(diesel), pulp.value(diesel)/16.2)
#print("Onshore Wind production level:", pulp.value(wind_on), pulp.value(wind_on)/10.26)
#print("Offshore Wind production level:", pulp.value(wind_off), pulp.value(wind_off)/13.68)
#print("Solar production level:", pulp.value(solar), pulp.value(solar)/3.42)
#print("Hydro production level:", pulp.value(hydro), pulp.value(hydro)/342)
#print("Nuclear production level:", pulp.value(nuclear), pulp.value(nuclear)/1836)
