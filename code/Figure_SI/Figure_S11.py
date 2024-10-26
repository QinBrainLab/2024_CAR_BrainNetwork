
import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt
import scipy.stats as sci

placebo_color = (98/255,121/255,249/255)
dxm_color = (219/255,189/255,41/255)
emo_color = [0.91,0.58,0.46]
nback_color = [0.58,0.63,0.76]
csv_data = pd.read_csv("E:/DST_multitask/python/revision/Fig_S11.csv")

csv_data.head
csv_data.columns.values
csv_data["id"] = csv_data.index

g = sns.lmplot(x="fo_emo_8_cohort2", y="emo_rt_cohort2", data=csv_data,line_kws={'color': emo_color}, scatter_kws={'linewidths':0,'color': emo_color})
g = sns.lmplot(x="meanlife_emo_8_cohort2", y="emo_rt_cohort2", data=csv_data,line_kws={'color': emo_color}, scatter_kws={'linewidths':0,'color': emo_color})


# combine analyses

g = sns.lmplot(x="cortisol_auci", y="fo_emo_s8", data=csv_data, line_kws={'color': 'k'},scatter = False)

plt.scatter(csv_data["cortisol_auci"][0:28], csv_data["fo_emo_s8"][0:28],color = nback_color)
plt.scatter(csv_data["cortisol_auci"][28:61], csv_data["fo_emo_s8"][28:61],color = nback_color)
plt.scatter(csv_data["cortisol_auci"][61:117], csv_data["fo_emo_s8"][61:117],color = emo_color)
plt.show()

g = sns.lmplot(x="cortisol_auci", y="fo_2back_s3", data=csv_data, line_kws={'color': 'k'},scatter = False)

plt.scatter(csv_data["cortisol_auci"][0:28], csv_data["fo_2back_s3"][0:28],color = nback_color)
plt.scatter(csv_data["cortisol_auci"][28:61], csv_data["fo_2back_s3"][28:61],color = nback_color)
plt.scatter(csv_data["cortisol_auci"][61:117], csv_data["fo_2back_s3"][61:117],color = emo_color)
plt.show()

