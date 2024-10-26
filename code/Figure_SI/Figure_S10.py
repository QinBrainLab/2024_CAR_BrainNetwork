
% keen point analysis

from kneed import DataGenerator
import matplotlib.pyplot as plt
from kneed import KneeLocator
import pandas as pd
knee_data = pd.read_csv("E:/DST_multitask/python/Fig_S10.csv")


sort_knee_data = sorted(knee_data['rest'],reverse=True)
sort_knee_data = sorted(knee_data['emotion'],reverse=True)
sort_knee_data = sorted(knee_data['nback'],reverse=True)

sum_data = [0]
for i in range(10):
    sum_data.append(sum(sort_knee_data[:i+1]))


x = range(0,11)


kneedle = KneeLocator(x, sum_data,
                      S=1.0, curve="concave",
                      direction="increasing")
kneedle.plot_knee()
kneedle.knee

kneedle.plot_knee_normalized()
plt.legend([],[], frameon=False)
plt.show()

print(round(kneedle.knee, 3))
kneedle.plot_knee()


