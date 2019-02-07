from tpot import TPOTClassifier
from sklearn.model_selection import train_test_split
from CreateDataset import load_cells

cells = load_cells()
X_train, X_test, y_train, y_test = train_test_split(cells.data, cells.target,
                                                    train_size=0.75, test_size=0.25)

pipeline_optimizer = TPOTClassifier(generations=5, population_size=20, cv=5,
                                    random_state=42, verbosity=2)
pipeline_optimizer.fit(X_train, y_train)
print(pipeline_optimizer.score(X_test, y_test))
pipeline_optimizer.export('tpot_exported_pipeline.py')