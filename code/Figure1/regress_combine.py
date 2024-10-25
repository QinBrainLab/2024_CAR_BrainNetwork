
import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt
import scipy.stats as sci
#rest  0.44,0.71,0.63
#nback 0.91,0.58,0.46
#emo:  0.58,0.63,0.76
placebo_color = (98/255,121/255,249/255)
dxm_color = (219/255,189/255,41/255)
emo_color = [0.91,0.58,0.46]
nback_color = [0.58,0.63,0.76]

csv_data = pd.read_csv("E:/DST_multitask/python/revision/regression_combine.csv")

csv_data.head
csv_data.columns.values
csv_data["id"] = csv_data.index


# combine analyses

# excluding ouliers of performance during emotion condition in both Cohorts & missing data of auci in cohort 2 
g = sns.lmplot(x="emo_auci_combine", y="emo_accu_hit_false", data=csv_data, line_kws={'color': 'k'},scatter = False)

plt.scatter(csv_data["emo_auci_combine"][0:60], csv_data["emo_accu"][0:60],color = nback_color) # cohort 1
plt.scatter(csv_data["emo_auci_combine"][60:115], csv_data["emo_accu"][60:115],color = emo_color) # cohort 2
plt.show()

# excluding ouliers of performance during 2-back condition in both Cohorts & missing data of auci in cohort 2 

g = sns.lmplot(x="auci_combine", y="2back_accu_hit_false", data=csv_data, line_kws={'color': 'k'},scatter = False)

plt.scatter(csv_data["auci_combine"][0:58], csv_data["2back_accu_hit_false"][0:58],color = nback_color)
plt.scatter(csv_data["auci_combine"][58:113], csv_data["2back_accu_hit_false"][58:113],color = emo_color)
plt.show()
