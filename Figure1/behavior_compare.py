import seaborn as sns
import pandas as pd
import xlrd
# Load some example data
placebo_color = (98/255,121/255,249/255)
dxm_color = (219/255,189/255,41/255)

wb = pd.read_excel('behavior_diff.xls',sheet_name=0)  # emotion exclude perf <0.5
wb = pd.read_excel('behavior_diff.xls',sheet_name=1)  # nback exclude perf <0.5



#print(wb)

# change into long list

wb_wm_0b = pd.melt(wb, id_vars=['condition'],value_vars=['emotion', 'neutral'],var_name = 'state') # for emotion matching task

wb_wm_0b = pd.melt(wb, id_vars=['condition'],value_vars=['0b','1b','2b'],var_name = 'state')  # for n-back task


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


# Add just the bar chart legend back
ax.legend(
    handles,
    labels,
    loc=7,
    bbox_to_anchor=(1.25, .5),
)

ax.set(ylim=(0, 1.2))
