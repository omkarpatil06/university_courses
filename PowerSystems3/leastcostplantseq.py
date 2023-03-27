import pulp

prob = pulp.LpProblem("Power_System_Optimization", pulp.LpMinimize)

#gas = pulp.LpVariable("Gas Generator", 0, 15, pulp.LpContinuous)
ccgt = pulp.LpVariable("CCGT Generator", 0, 612*10, pulp.LpContinuous)
coal = pulp.LpVariable("Coal Generator", 0, 918*10, pulp.LpContinuous)
diesel = pulp.LpVariable("Diesel Generator", 0, 16.2*100, pulp.LpContinuous)
wind_on = pulp.LpVariable("Onshore Wind Generator", 0, 10.26*100, pulp.LpContinuous)
wind_off = pulp.LpVariable("Offshore Wind Generator", 0, 13.68*100, pulp.LpContinuous)
solar = pulp.LpVariable("Solar Generator", 0, 3.42*100, pulp.LpContinuous)
hydro = pulp.LpVariable("Hydro Generator", 0, 342*10, pulp.LpContinuous)
nuclear = pulp.LpVariable("Nuclear Generator", 600, 1836*3, pulp.LpContinuous)

prob += 36.79200867*ccgt + 36.79200803*coal + 48.18002288*diesel + 105.120002*wind_on + 210.2400026*wind_off + 70.08000153*solar + 11.38800089*hydro + 60.44400238*nuclear
prob += ccgt + coal + diesel + wind_on + wind_off + solar + hydro + nuclear == 12600

#prob += gas <= 100
prob += ccgt <= 612*3
prob += coal <= 918*3
prob += diesel <= 16.2*5
prob += wind_on <= 10.26*50
prob += wind_off <= 13.68*50
prob += solar <= 3.42*100
prob += hydro <= 342*10
prob += nuclear <= 1836*3

prob.solve()
print("Optimization status:", pulp.LpStatus[prob.status])
print("Optimal cost:", pulp.value(prob.objective))
#print("Gas production level:", pulp.value(gas))
print("CCGT production level:", pulp.value(ccgt), pulp.value(ccgt)/612)
print("Coal production level:", pulp.value(coal), pulp.value(coal)/918)
print("Diesel production level:", pulp.value(diesel), pulp.value(diesel)/16.2)
print("Onshore Wind production level:", pulp.value(wind_on), pulp.value(wind_on)/10.26)
print("Offshore Wind production level:", pulp.value(wind_off), pulp.value(wind_off)/13.68)
print("Solar production level:", pulp.value(solar), pulp.value(solar)/3.42)
print("Hydro production level:", pulp.value(hydro), pulp.value(hydro)/342)
print("Nuclear production level:", pulp.value(nuclear), pulp.value(nuclear)/1836)