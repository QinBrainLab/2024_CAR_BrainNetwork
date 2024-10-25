import seaborn as sns
import pandas as pd
import xlrd
# Load some example data
placebo_color = (98/255,121/255,249/255)
dxm_color = (219/255,189/255,41/255)
#打开excel
wb = pd.read_excel('FigS2_p1.xls',sheet_name=0)

#print(wb)

# change into long list


wb_wm_0b = pd.melt(wb, id_vars=['condition'],value_vars=['placebo', 'dxm'],var_name = 'state')


# Draw the bar chart
ax = sns.barplot(
    data=wb_wm_0b,
    x="condition",
    y="value",
    hue="state",
    alpha=0.7,
    capsize=.1,
    #ci=None,
    palette = [placebo_color,dxm_color]
)
sns.despine()
# Get the legend from just the bar chart
handles, labels = ax.get_legend_handles_labels()

# Draw the stripplot
sns.stripplot(
    data=wb_wm_0b,
    x="condition",
    y="value",
    hue="state",
    dodge=True,
    jitter=0.1,
    alpha=0.3,
    size = 5,
    edgecolor="black",
    linewidth=.5,
    ax=ax,
palette = [placebo_color,dxm_color]
)
# Remove the old legend
ax.legend_.remove()