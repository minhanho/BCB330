import numpy as np
import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix


# NOTE: Make sure that the class is labeled 'target' in the data file
tpot_data = pd.read_csv('/Users/minhanho/Documents/BCB330/TF_FeatureExtraction/features_with_level1class.csv')
first = tpot_data.drop('target', axis=1)
second = first.drop('fullFilename', axis=1)
features = second.drop('cell_id', axis=1).values
training_features, testing_features, training_target, testing_target = \
            train_test_split(features, tpot_data['target'].values, random_state=42)

# Average CV score on the training set was:0.559082180119182
exported_pipeline = LogisticRegression(C=0.01, dual=False, penalty="l2")

exported_pipeline.fit(training_features, training_target)
results = exported_pipeline.predict(testing_features)

mat = confusion_matrix(testing_target, results)
print(mat)