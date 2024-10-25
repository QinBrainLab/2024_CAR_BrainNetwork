
import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt
import scipy.stats as sci

placebo_color = (98/255,121/255,249/255)
dxm_color = (219/255,189/255,41/255)
emo_color = [0.91,0.58,0.46]
nback_color = [0.58,0.63,0.76]

csv_data = pd.read_csv("E:/DST_multitask/python/revision/regression_combine.csv")

csv_data.head
csv_data.columns.values
csv_data["id"] = csv_data.index



# combine analyses

g = sns.lmplot(x="cortisol_aucg", y="TC_2_0", data=csv_data, line_kws={'color': 'k'},scatter = False)

plt.scatter(csv_data["cortisol_aucg"][0:28], csv_data["TC_2_0"][0:28],color = nback_color)
plt.scatter(csv_data["cortisol_aucg"][28:61], csv_data["TC_2_0"][28:61],color = nback_color)
plt.scatter(csv_data["cortisol_aucg"][61:117], csv_data["TC_2_0"][61:117],color = emo_color)
plt.show()



g = sns.lmplot(x="cortisol_aucg", y="TC_emo_neu", data=csv_data, line_kws={'color': 'k'},scatter = False)

plt.scatter(csv_data["cortisol_aucg"][0:28], csv_data["TC_emo_neu"][0:28],color = nback_color)
plt.scatter(csv_data["cortisol_aucg"][28:61], csv_data["TC_emo_neu"][28:61],color = nback_color)
plt.scatter(csv_data["cortisol_aucg"][61:117], csv_data["TC_emo_neu"][61:117],color = emo_color)
plt.show()
