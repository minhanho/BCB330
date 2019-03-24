# BCB330: Cell Morphology Classification and Transcriptomic Correlation

## Requirements
* R (latest release) from https://cran.r-project.org/mirrors.html
* Python3
```
sudo apt install python3 git wget
sudo apt install python3-pip
```
* Tensorflow
```
mkdir ~/tensorflow/
cd ~/tensorflow
pip3 install tensorflow
git clone https://github.com/tensorflow/models/
cd models/research/slim
sudo python3 setup.py install
```
* ResNet V1 101
```
cd ~/tensorflow
mkdir checkpoints
cd checkpoints
wget http://download.tensorflow.org/models/resnet_v1_101_2016_08_28.tar.gz
tar xf resnet_v1_101_2016_08_28.tar.gz
```

## Image Processing
```
git clone https://github.com/minhanho/BCB330.git
```
* Run imageManipulation.R

## Feature Extraction
* Feature extraction steps are from: https://github.com/tomrunia/TF_FeatureExtraction
```
git clone https://github.com/tomrunia/TF_FeatureExtraction
cd ~/tensorflow
export PYTHONPATH="/models/research/slim"
python3 example_feat_extract.py --network resnet_v1_101 --checkpoint ../checkpoints/resnet_v1_101.ckpt --image_path ~/BCB330/data/processed/ --out_file ./features.h5 --num_classes 1000 --layer_names resnet_v1_101/logits
```

## Classifier Determination
* Run h5ExampleCode.R
```
python TPOTClassifer.py
```

## Classification
```
python tpot_exported_pipeline.py
```

## Correlations
* Run ZeiselAndMerge.R

