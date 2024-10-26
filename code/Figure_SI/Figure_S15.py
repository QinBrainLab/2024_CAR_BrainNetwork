
import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt
import scipy.stats as sci
# bla 4 5 cma 6 7
#rest  0.44,0.71,0.63
#nback 0.91,0.58,0.46
#emo:  0.58,0.63,0.76
placebo_color = (98/255,121/255,249/255)
dxm_color = (219/255,189/255,41/255)
emo_color = [0.91,0.58,0.46]
nback_color = [0.58,0.63,0.76]
csv_data = pd.read_csv("E:/DST_multitask/python/revision/Fig_S15.csv")


csv_data.head
csv_data.columns.values
csv_data["id"] = csv_data.index

# 2back efficiency (excluding poor performance in 2-back condition)
g = sns.lmplot(x="2_back_auci_efficiency", y="2back_effciency", data=csv_data, line_kws={'color': 'k'},scatter = False)

plt.scatter(csv_data["2_back_auci_efficiency"][0:27], csv_data["2back_effciency"][0:27],color = placebo_color)
plt.scatter(csv_data["2_back_auci_efficiency"][27:59], csv_data["2back_effciency"][27:59],color = dxm_color)
g.set(ylim=(0, 1.6))
plt.show()

# 1back efficiency (excluding poor performance in 1-back condition)
g = sns.lmplot(x="1_back_auci_efficiency", y="1back_effciency", data=csv_data, line_kws={'color': 'k'},scatter = False)

plt.scatter(csv_data["1_back_auci_efficiency"][0:27], csv_data["1back_effciency"][0:27],color = placebo_color)
plt.scatter(csv_data["1_back_auci_efficiency"][27:60], csv_data["1back_effciency"][27:60],color = dxm_color)
g.set(ylim=(0, 3.5))
plt.show()