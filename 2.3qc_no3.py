import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np


data = pd.read_csv("testCount.txt",sep ='\t')
data_result = pd.read_csv("DoubletFinder_result.txt", sep ='\t')
b = np.array(data_result)

list1 = list()
for i, double in enumerate(b[:, 1]):
    if(double == 'Doublet'):
        list1.append(b[i][0])

# 筛除doublets
data = data.drop(list1, axis=1)

a = np.array(data)

cols = np.sum(a, axis=0)   # Count depth
# rows = np.sum(a, axis=1)  # Number of genes

cols.sort()
# print(cols)
y = cols
x = np.arange(len(y))

# logit
plt.plot(x, y)
plt.yscale('log')
plt.axhline(y=1500, color='r')

# 设置坐标轴区间大小

# plt.ylim(0,1000)
# plt.xlim(0,5000)
plt.xlabel('Barcode rank')
plt.ylabel('Count depth')
plt.show()
