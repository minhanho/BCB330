Feature extraction steps are from:
https://github.com/tomrunia/TF_FeatureExtraction

Rought steps on Leon's machine to extract features:
export PYTHONPATH="/Users/lfrench/Desktop/results/MinhBCB330/tensorflow_models/models/research/slim:$PYTHONPATH"

python3 ./example_feat_extract.py --network resnet_v1_101 --checkpoint "/Users/lfrench/Desktop/results/MinhBCB330/tensorflow checkpoints/resnet_v1_101.ckpt" --image_path /Users/lfrench/Desktop/results/MinhBCB330/data/processed --out_file ./features.h5 --num_classes 1000  --layer_names resnet_v1_101/logits