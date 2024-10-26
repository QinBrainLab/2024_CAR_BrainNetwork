# Python program to illustrate
# violinplot using inbuilt data-set
# given in seaborn

# importing the required module
import seaborn
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns

placebo_color = (98/255,121/255,249/255)
dxm_color = (219/255,189/255,41/255)
black = (0,0,0)


# FO for emotion and 2back condition (block-based) as well as rest
csv_data = pd.read_excel("E:\DST_multitask\python/revision/Fig_S1314_FO_2b_domi_diff.xls",sheet_name=0)
csv_data = pd.read_excel("E:\DST_multitask\python/revision/Fig_S1314_FO_emo_domi_diff.xls",sheet_name=0)
csv_data = pd.read_excel("E:/DST_multitask/python/Fig_S1314_rs_domi_diff.xls",sheet_name=0)

# use to set style of background of plot
seaborn.set(style="whitegrid")
csv_all = pd.melt(csv_data, id_vars=['condition'],value_vars=['s4','s5','s9'],var_name = 'state')
ax = sns.violinplot(data=csv_all,x="state", y="value", hue="condition",
                   palette = [placebo_color,dxm_color], split=True,inner="quart",gap = 10.5)

# 显示图形
plt.show()


# Mean lifetime for emotion and 2back condition (block-based) as well as rest
csv_data = pd.read_excel("E:\DST_multitask\python/revision/Fig_S1314_meanlife_emo_domi_diff.xls",sheet_name=0)
csv_data = pd.read_excel("E:\DST_multitask\python/revision/Fig_S1314_meanlife_nback_domi_diff.xls",sheet_name=2)
csv_data = pd.read_excel("E:\DST_multitask\python/revision/Fig_S1314_meanlife_rs_domi_diff.xls",sheet_name=0)

# use to set style of background of plot
seaborn.set(style="whitegrid")
csv_all = pd.melt(csv_data, id_vars=['condition'],value_vars=['s2','s3','s4','s7','s10'],var_name = 'state')
ax = sns.violinplot(data=csv_all,x="state", y="value", hue="condition",
                   palette = [placebo_color,dxm_color], split=True,inner="quart",gap = 10.5)

# 显示图形
plt.show()









