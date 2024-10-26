import seaborn as sns
import pandas as pd
import xlrd
# Load some example data
placebo_color = (98/255,121/255,249/255)
dxm_color = (219/255,189/255,41/255)
#打开excel


wb = pd.read_excel('behavior_diff_rt.xls',sheet_name=1)  # emotion

wb = pd.read_excel('behavior_diff_rt.xls',sheet_name=0)  # nback

#print(wb)

wb_wm_0b = pd.melt(wb, id_vars=['condition'],value_vars=['0b_rt','2b_rt'],var_name = 'state')

wb_wm_0b = pd.melt(wb, id_vars=['condition'],value_vars=['emo_rt', 'neu_rt'],var_name = 'state')

placebo_color = (114/255,113/255,113/255)

# Draw the bar chart
ax = sns.barplot(
    data=wb_wm_0b,
    x="state",
    y="value",
    hue="condition",
    alpha=0.7,
    capsize=.1,
    #ci=None,
    #color='#898989',
    palette = [placebo_color,dxm_color]
)
sns.despine()

# Get the legend from just the bar chart
handles, labels = ax.get_legend_handles_labels()

# Draw the stripplot
sns.stripplot(
    data=wb_wm_0b,
    x="state",
    y="value",
    hue="condition",
    dodge=True,
    alpha=0.65,
    #edgecolor="black",
    linewidth=1,
    ax=ax,
    #color='#898989',
    palette = [placebo_color,dxm_color]
#palette = [placebo_color,dxm_color]
)
# Remove the old legend
ax.legend_.remove()

