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

csv_data = pd.read_csv("TC_group_compare.csv")
csv_data["id"] = csv_data.index

# use to set style of background of plot

seaborn.set(style="whitegrid")


# loading data-set
csv_all = pd.melt(csv_data, id_vars=['condition1'],value_vars=['rest','emo','2b'],var_name = 'state')

ax = sns.violinplot(data=csv_all,x="state", y="value", hue="condition1",
                   palette = [placebo_color,dxm_color], split=True,inner="quart",gap = 10.5)












