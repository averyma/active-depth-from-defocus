# Computational Active Depth from Defocus

My Master’s thesis focuses on 3D reconstruction technologies. I am building a novel active depth sensing system that infers depth by analyzing the blurriness of the projection pattern at different depth levels caused by camera defocus. Without relying on complex hardware, I constructed multiple parametric (Gaussian based) and non-parametric (DNN-based) computational models for depth inference. This repository contains a number of different models implemented for my thesis work [more info](https://averyma.github.io/publications/).

## Parametric computational model (Gaussian-based):
[Circularly-Symmetric 2D Gaussian](https://github.com/averyma/active-depth-from-defocus/tree/master/parametric_model/std_depth_inference_model) [[paper](http://openjournals.uwaterloo.ca/index.php/vsl/article/view/96)]

[Elliptical 2D Gaussian:](https://github.com/averyma/active-depth-from-defocus/tree/master/parametric_model/minEigen_depth_inference_model) [[paper](https://icipe17.uwaterloo.ca/papers/27TMa.pdf)]

## Non-parametric computational model (DNN-based):
The [/non_parametric_model/DfD_matlabNN/](https://github.com/averyma/active-depth-from-defocus/tree/master/non_parametric_model/DfD_matlabNN) folder contains a collection of models that are inplemented using the native Matlab Neural Network Toolbox. [[paper](https://link.springer.com/chapter/10.1007/978-3-319-59876-5_5)]

The [/non_parametric_model/DfD_tf/](https://github.com/averyma/active-depth-from-defocus/tree/master/non_parametric_model/DfD_tf) folder contains a collection of models that use TensorFlow's high-level APIs.
