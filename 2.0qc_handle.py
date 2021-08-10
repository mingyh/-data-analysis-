import pandas as pd
import numpy as np

data = pd.read_csv("testCount.txt", sep ='\t')
data_result = pd.read_csv("DoubletFinder_result.txt", sep ='\t')
b = np.array(data_result)
print(data.shape[1])    # 查看列数

list_cols = list()
list_rows = list()
for i, double in enumerate(b[:, 1]):
    if(double == 'Doublet'):
        list_cols.append(b[i][0])
        list_rows.append(i)

# 筛除doublets
data = data.drop(list_cols, axis=1)     # 删除对应列
data_result = data_result.drop(list_rows)   # 删除对应行
print(data.shape[1])    # 查看列数

a = np.array(data)
b = np.array(data_result)

cols = np.sum(a, axis=0)  # Count depth
del_cols = list()   # 创建删除下标list
del_data_cols = list()   # 创建删除元素list
for i in range(len(cols)):
    if cols[i] < 1500:
        del_cols.append(i)  # 将删除的添加到list

for i in del_cols:
    del_data_cols.append(b[i][0])   # 添加删除元素到list里
    data_result = data_result.drop(i+1)     # 删除对应行
data = data.drop(del_data_cols, axis=1)     # 删除对应列
print(data.shape[1])    # 查看列数

nozero = np.array((data != 0).astype(int).sum(axis=0))  # Number of genes
del_nozero = list()  # 创建删除下标list
del_data_nozero = list()   # 创建删除元素list
for i in range(len(nozero)):
    if nozero[i] < 900:
        del_nozero.append(i)

b = np.array(data_result)
for i in del_nozero:
    del_data_nozero.append(b[i][0])
    data_result = data_result.drop(i+1)       # 删除对应行
data = data.drop(del_data_nozero, axis=1)     # 删除对应列

# data_result = data_result.drop(del_nozero[0])    # 删除对应行
print(data.shape[1])    # 查看列数

# np.savetxt('qc_data.csv', data, delimiter=',')    # 没表头，差评！
data.to_csv("qc_data.csv", sep=',')
data_result.to_csv("qc_result_data.csv", sep=',')
