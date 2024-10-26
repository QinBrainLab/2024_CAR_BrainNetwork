
import pandas as pd
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns

rest_color = (0.44,0.71,0.63)
emo_color = (255/255,104/255,74/255)
nback_color = (0.33,0.67,1)


color_pal = [rest_color,emo_color,nback_color]


csv_data = pd.read_excel("E:\DST_multitask\python\Fig_S9_p2.xls",sheet_name=0)

csv_data.head
csv_data.columns.values
csv_data["id"] = csv_data.index

# convert wide to long table
csv_data_long = pd.melt(csv_data, id_vars='condition',
                        value_vars=['S1', 'S2', 'S3','S4','S5','S6','S7','S8','S9','S10'])


sns.set_context("notebook", font_scale=1.5)
# plt.figure(figsize=(10,8))

g=sns.catplot(x='variable',
            y='value',
            hue="condition",
            kind="box",
            palette=color_pal,
            data=csv_data_long,
            width=0.5,
            height=6,
            aspect=1.9,
            showfliers = False);

#g.set(ylim=(0, 1))
#plt.ylim(0, 1)
grped_bplot = sns.stripplot(x='variable',
                            y='value',
                            hue='condition',
                            jitter=0.2,
                            dodge=True,
                            #width=0.5,
                            marker='o',
                            palette=color_pal,
                            alpha=0.3,
                            data=csv_data_long)

plt.legend([],[], frameon=False)
plt.show()


