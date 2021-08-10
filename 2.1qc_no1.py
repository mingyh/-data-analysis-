import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

data = pd.read_csv("testCount.txt", sep ='\t')
data_result = pd.read_csv("DoubletFinder_result.txt", sep ='\t')
b = np.array(data_result)

list1 = list()
for i,double in enumerate(b[:,1]):
    if(double == 'Doublet'):
        list1.append(b[i][0])
# 筛除doublets
data = data.drop(list1, axis=1)

a = np.array(data)
cols = np.sum(a, axis=0) # Count depth
nozero = (data != 0).astype(int).sum(axis=0) #统计每列不为0的个数

data_test = list(zip(cols, nozero))
data_test = np.mat(data_test)   # list转矩阵

data_test = pd.DataFrame(data_test, columns=list('AB'))

# sns.displot(x="A",data=data_test)
sns.histplot(data=data_test, x="A", bins=200)
plt.axvline(x=1500,color='r')


# 设置坐标轴区间大小
# plt.ylim(0,50)
# plt.xlim(0,10000)
plt.xlabel('Count depth')
plt.ylabel('Frequency')
plt.show()



