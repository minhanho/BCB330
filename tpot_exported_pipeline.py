import numpy as np
import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix
import seaborn as sns
import matplotlib.pyplot as plt

#TODO
featureLevel1 = "/Users/minhanho/Documents/BCB330/TF_FeatureExtraction/features_with_level1class.csv"

tpot_data = pd.read_csv(featureLevel1)
first = tpot_data.drop('target', axis=1)
second = first.drop('fullFilename', axis=1)
features = second.drop('cell_id', axis=1).values
training_features, testing_features, training_target, testing_target = \
            train_test_split(features, tpot_data['target'].values, random_state=42)

# Average CV score on the training set was:0.559082180119182
exported_pipeline = LogisticRegression(C=0.01, dual=False, penalty="l2")

exported_pipeline.fit(training_features, training_target)
results = exported_pipeline.predict(testing_features)

cell_types = []
for i in tpot_data["target"]:
    if i not in cell_types:
        cell_types.append(i)

cm = confusion_matrix(testing_target, results, cell_types)
print(cm)

#Based off https://gist.github.com/hitvoice/36cf44689065ca9b927431546381a3f7
cm_sum = np.sum(cm, axis=1, keepdims=True)
cm_perc = cm / cm_sum.astype(float) * 100
annot = np.empty_like(cm).astype(str)
nrows, ncols = cm.shape
for i in range(nrows):
    for j in range(ncols):
        c = cm[i, j]
        p = cm_perc[i, j]
        if i == j:
            s = cm_sum[i]
            annot[i, j] = '%.1f%%\n%d/%d' % (p, c, s)
        elif c == 0:
            annot[i, j] = '%.1f%%\n%d' % (p, c)
        else:
            annot[i, j] = '%.1f%%\n%d' % (p, c)
cm = pd.DataFrame(cm, index=cell_types, columns=cell_types)
cm.index.name = 'Actual'
cm.columns.name = 'Predicted'
fig, ax = plt.subplots(figsize=(7,7))
sns.heatmap(cm, annot=annot, fmt='', ax=ax)
plt.tight_layout()
#plt.show()
#OR
plt.savefig("ConfusionMatrix.png")