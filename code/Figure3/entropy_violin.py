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


# fo
csv_data = pd.read_excel("E:\DST_multitask\python/revision/FO_2b_domi_diff.xls",sheet_name=0)
csv_data = pd.read_excel("E:\DST_multitask\python/revision/FO_emo_domi_diff.xls",sheet_name=0)
csv_data = pd.read_excel("E:/DST_multitask/python/rs_domi_diff.xls",sheet_name=0)

# mean-life
csv_data = pd.read_excel("E:\DST_multitask\python/revision/meanlife_emo_domi_diff.xls",sheet_name=0)
csv_data = pd.read_excel("E:\DST_multitask\python/revision/meanlife_nback_domi_diff.xls",sheet_name=2)
csv_data = pd.read_excel("E:\DST_multitask\python/revision/meanlife_rs_domi_diff.xls",sheet_name=0)


# use to set style of background of plot
seaborn.set(style="whitegrid")

# loading data-set
csv_all = pd.melt(csv_data, id_vars=['condition'],value_vars=['s2','s10'],var_name = 'state')

ax = sns.violinplot(data=csv_all,x="state", y="value", hue="condition",
                   palette = [placebo_color,dxm_color], split=True,inner="quart",gap = 10.5)
               #    scale="count",inner="quart")
ax.set_yticks([0, 0.4, 0.8])
ax.set_yticklabels(['0', '40', '80'])

for violin in ax.collections:
    violin.set_alpha(0.75)  # 设置透明度

# 显示图形
plt.show()
plt.ylim(-0.3, 0.6)


# Get the legend from just the bar chart
handles, labels = ax.get_legend_handles_labels()

# use to set style of background of plot
seaborn.set(style="whitegrid")

# loading data-set
csv_all = pd.melt(csv_data, id_vars=['condition'],value_vars=['s1','s8'],var_name = 'state')

ax = sns.violinplot(data=csv_all,x="state", y="value", hue="condition",
                   palette = [placebo_color,dxm_color], split=True,inner="quart",gap = 10.5)
               #    scale="count",inner="quart")
ax.set_yticks([0, 0.4, 0.8])
ax.set_yticklabels(['0', '40', '80'])

for violin in ax.collections:
    violin.set_alpha(0.75)  # 设置透明度

# 显示图形
plt.show()
plt.ylim(-0.3, 1.3)



# Get the legend from just the bar chart
handles, labels = ax.get_legend_handles_labels()

# use to set style of background of plot
seaborn.set(style="whitegrid")

# loading data-set
csv_all = pd.melt(csv_data, id_vars=['condition'],value_vars=['s4','s5'],var_name = 'state')

ax = sns.violinplot(data=csv_all,x="state", y="value", hue="condition",
                   palette = [placebo_color,dxm_color], split=True,inner="quart",gap = 10.5)
               #    scale="count",inner="quart")
ax.set_yticks([0, 0.4, 0.8])
ax.set_yticklabels(['0', '40', '80'])

for violin in ax.collections:
    violin.set_alpha(0.75)  # 设置透明度

# 显示图形
plt.show()
plt.ylim(-0.3, 1.3)









