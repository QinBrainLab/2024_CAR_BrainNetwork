import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns

state = pd.read_csv("E:/DST_multitask/python/revision/Fig_S7.csv")


N = 14
theta = np.linspace(0.0, 2 * np.pi, N, endpoint=False)
r = state['state 1']
width = np.array([0.4] * N)
label = state['network']

# for cohort 1
col = sns.color_palette()
col = [(188/255,189/255,34/255),(44/255,160/255,44/255),(0.5,0.5,0.5),(23/255,190/255,207/255),(31/255,119/255,180/255),(0.5,0.5,0.5),(0.5,0.5,0.5),(255/255,127/255,14/255),(0.5,0.5,0.5),(0/255,145/255,58/255)]

# for cohort 2
col = [(0.5,0.5,0.5),(0/255,145/255,58/255),(188/255,189/255,34/255),(0.5,0.5,0.5),(23/255,190/255,207/255),(0.5,0.5,0.5),(31/255,119/255,180/255),(255/255,127/255,14/255),(44/255,160/255,44/255),(0.5,0.5,0.5)]


ln = state.columns.tolist()
lis = ln[1::]


cnt=-1
fig = plt.figure()
for i in lis:
    cnt=cnt+1
    N = 14
    theta = np.linspace(0.0, 2 * np.pi, N, endpoint=False)
    r = state[i]
    width = np.array([0.4] * N)
    label = state['network']
    #fig = plt.figure()
    #ax = plt.subplot(111, projection='polar')
    ax = plt.subplot(2,5,cnt+1, projection='polar')
    ax.set_rlim(-1, 1)
    ax.set_rticks(np.arange(-1,2,1))
    ax.set_thetagrids(theta * 180 / np.pi)
    ax.set_rlabel_position(-15)
    plt.grid(b=True, which='both', color='0.65',linewidth = '0.5',linestyle='--')
    ax.bar(x=theta, height=r+1, width=width, bottom=-1, alpha=0.6, tick_label=label,color = col[cnt])
   # ax.bar(x=theta, height=r + 1, width=width, bottom=-1, alpha=0.6, color=col[cnt])
    #ax.set_xticklabels([])
    ax.axes.xaxis.set_ticklabels([])
    figname = url + 'state_all'
    #plt.show()
