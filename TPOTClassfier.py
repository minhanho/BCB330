from tpot import TPOTClassifier
from sklearn.model_selection import train_test_split
import pandas as pd

df = pd.read_csv("/Users/lfrench/Desktop/results/TF_FeatureExtraction/features_with_level1class.csv")
cells_target = df["level1class"]

filter_col = [col for col in df if col.startswith('V')]

cells_data = df[filter_col]

X_train, X_test, y_train, y_test = train_test_split(cells_data, cells_target,
                                                    train_size=0.75, test_size=0.25)

pipeline_optimizer = TPOTClassifier(generations=5, population_size=20, cv=5,
                                    random_state=42, verbosity=2)
pipeline_optimizer.fit(X_train, y_train)

print(pipeline_optimizer.score(X_test, y_test))

pipeline_optimizer.export('tpot_exported_pipeline.py')
