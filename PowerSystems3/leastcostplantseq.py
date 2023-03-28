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

prob += plant_pounds_gwh[0]*power_plant[0] + plant_pounds_gwh[1]*power_plant[1] + plant_pounds_gwh[2]*power_plant[2] + plant_pounds_gwh[3]*power_plant[3] + plant_pounds_gwh[4]*power_plant[4] + plant_pounds_gwh[5]*power_plant[5] + plant_pounds_gwh[6]*power_plant[6] + plant_pounds_gwh[7]*power_plant[7] + plant_pounds_gwh[8]*power_plant[8]
prob += power_plant[0] + power_plant[1] + power_plant[2] + power_plant[3] + power_plant[4] + power_plant[5] + power_plant[6] + power_plant[7] + power_plant[8] == max_load_hour[0]

prob.solve()
print("Optimization status:", pulp.LpStatus[prob.status])
print("Optimal cost:", pulp.value(prob.objective))
for i in range(len(plant_type)):
  print(f'{plant_type[i]}, {pulp.value(power_plant[i])}, {pulp.value(power_plant[i])/plant_gwh[i]}')