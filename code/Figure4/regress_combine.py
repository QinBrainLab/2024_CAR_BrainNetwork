
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

csv_data = pd.read_csv("E:/DST_multitask/python/revision/regression_combine.csv")

csv_data.head
csv_data.columns.values
csv_data["id"] = csv_data.index

g = sns.lmplot(x="cortisol_r30", y="fo_emo_8", data=csv_data, line_kws={'color': emo_color}, scatter_kws={'linewidths':0,'color': emo_color})
#g.set(ylim=(0.6, 1.05))
g.set(xlim=(-15, 28))

g = sns.lmplot(x="aucg", y="switchemo-neu", data=csv_data,line_kws={'color': nback_color}, scatter_kws={'linewidths':0,'color': nback_color})
#g.set(ylim=(0.6, 1.05))
g.set(xlim=(-15, 28))

g = sns.lmplot(x="cortisol_aucg", y="switch0-2", data=csv_data,line_kws={'color': nback_color}, scatter_kws={'linewidths':0,'color': nback_color})

g = sns.lmplot(x="cortisol_aucg_cohort2", y="emo_acc_cohort2", data=csv_data,line_kws={'color': emo_color}, scatter_kws={'linewidths':0,'color': emo_color})

g = sns.lmplot(x="fo_emo_8_cohort2", y="emo_rt_cohort2", data=csv_data,line_kws={'color': emo_color}, scatter_kws={'linewidths':0,'color': emo_color})

g = sns.lmplot(x="meanlife_emo_8_cohort2", y="emo_rt_cohort2", data=csv_data,line_kws={'color': emo_color}, scatter_kws={'linewidths':0,'color': emo_color})


g = sns.lmplot(x="cortisol_auci_cohort2", y="emo_rt_cohort2", data=csv_data,line_kws={'color': emo_color}, scatter_kws={'linewidths':0,'color': emo_color})




g = sns.lmplot(x="aucg", y="switchemo-neu", line_kws={'color': 'k'}, data=csv_data)
g.set(xlim=(0, 37))
plt.scatter(csv_data["aucg"][0:27], csv_data["switchemo-neu"][0:27],color = placebo_color)
plt.scatter(csv_data["aucg"][28:60], csv_data["switchemo-neu"][28:60],color = dxm_color)
plt.show()

g = sns.lmplot(x="aucg", y="switch2-0", line_kws={'color': [0,0,0]}, data=csv_data)
g.set(xlim=(0, 37))
plt.scatter(csv_data["aucg"][0:27], csv_data["switch2-0"][0:27],color = placebo_color)
plt.scatter(csv_data["aucg"][28:60], csv_data["switch2-0"][28:60],color = dxm_color)
plt.show()

g = sns.lmplot(x="cortisol_auci_cohort1", y="fo_emo_8_cohort1", line_kws={'color': [0,0,0]}, data=csv_data)
#g.set(xlim=(0, 37))
plt.scatter(csv_data["cortisol_auci_cohort1"][0:28], csv_data["fo_emo_8_cohort1"][0:28],color = placebo_color)
plt.scatter(csv_data["cortisol_auci_cohort1"][28:61], csv_data["fo_emo_8_cohort1"][28:61],color = dxm_color)
plt.show()

# combine analyses

g = sns.lmplot(x="cortisol_auci", y="fo_emo_8", data=csv_data, line_kws={'color': 'k'},scatter = False)

plt.scatter(csv_data["cortisol_auci"][0:28], csv_data["fo_emo_8"][0:28],color = nback_color)
plt.scatter(csv_data["cortisol_auci"][28:61], csv_data["fo_emo_8"][28:61],color = nback_color)
plt.scatter(csv_data["cortisol_auci"][61:117], csv_data["fo_emo_8"][61:117],color = emo_color)
plt.show()

g = sns.lmplot(x="cortisol_auci", y="fo_2back_34", data=csv_data, line_kws={'color': 'k'},scatter = False)

plt.scatter(csv_data["cortisol_auci"][0:28], csv_data["fo_2back_34"][0:28],color = nback_color)
plt.scatter(csv_data["cortisol_auci"][28:61], csv_data["fo_2back_34"][28:61],color = nback_color)
plt.scatter(csv_data["cortisol_auci"][61:117], csv_data["fo_2back_34"][61:117],color = emo_color)
plt.show()


g = sns.lmplot(x="cortisol_aucg", y="switch0-2", data=csv_data, line_kws={'color': 'k'},scatter = False)

plt.scatter(csv_data["cortisol_aucg"][0:28], csv_data["switch0-2"][0:28],color = nback_color)
plt.scatter(csv_data["cortisol_aucg"][28:61], csv_data["switch0-2"][28:61],color = nback_color)
plt.scatter(csv_data["cortisol_aucg"][61:117], csv_data["switch0-2"][61:117],color = emo_color)
plt.show()

g = sns.lmplot(x="cortisol_aucg", y="switchemo-neu", data=csv_data, line_kws={'color': 'k'},scatter = False)

plt.scatter(csv_data["cortisol_aucg"][0:28], csv_data["switchemo-neu"][0:28],color = nback_color)
plt.scatter(csv_data["cortisol_aucg"][28:61], csv_data["switchemo-neu"][28:61],color = nback_color)
plt.scatter(csv_data["cortisol_aucg"][61:117], csv_data["switchemo-neu"][61:117],color = emo_color)
plt.show()

g = sns.lmplot(x="auci_combine", y="2back_accu_hit_false", data=csv_data, line_kws={'color': 'k'},scatter = False)

plt.scatter(csv_data["auci_combine"][0:58], csv_data["2back_accu_hit_false"][0:58],color = nback_color)
plt.scatter(csv_data["auci_combine"][58:113], csv_data["2back_accu_hit_false"][58:113],color = emo_color)
plt.show()


g = sns.lmplot(x="emo_auci_combine", y="emo_accu_hit_false", data=csv_data, line_kws={'color': 'k'},scatter = False)

plt.scatter(csv_data["emo_auci_combine"][0:60], csv_data["emo_accu_hit_false"][0:60],color = nback_color)
plt.scatter(csv_data["emo_auci_combine"][60:115], csv_data["emo_accu_hit_false"][60:115],color = emo_color)
plt.show()


g = sns.lmplot(x="2_back_auci_efficiency", y="2back_effciency", data=csv_data, line_kws={'color': 'k'},scatter = False)

plt.scatter(csv_data["2_back_auci_efficiency"][0:26], csv_data["2back_effciency"][0:26],color = placebo_color)
plt.scatter(csv_data["2_back_auci_efficiency"][26:58], csv_data["2back_effciency"][26:58],color = dxm_color)
g.set(ylim=(0, 1.6))
plt.show()

g = sns.lmplot(x="1_back_auci_efficiency", y="1back_effciency", data=csv_data, line_kws={'color': 'k'},scatter = False)

plt.scatter(csv_data["1_back_auci_efficiency"][0:27], csv_data["1back_effciency"][0:27],color = placebo_color)
plt.scatter(csv_data["1_back_auci_efficiency"][27:59], csv_data["1back_effciency"][27:59],color = dxm_color)
g.set(ylim=(0, 3.5))
plt.show()