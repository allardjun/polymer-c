using GridSearch

k_cap_min=0.01
k_cap_max=10000
k_del_min=0.00001
k_del_max=10
r_cap_min=10
r_cap_max=10000000

points= 15

GridSearch.generateCombo(k_cap_min, k_cap_max, k_del_min, k_del_max, r_cap_min, r_cap_max, points)