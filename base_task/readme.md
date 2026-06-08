# Base Task
In this Project, I was tasked to train a predefined MLP (without adding additional CNN layers/Transfer Learning) on the FashionMNIST dataset and to pickle the weights of the model and attach a csv files containing the submissions on the test dataset. 

## Overview
I used a 90/10 split for the training and validation set from the `train=True` dataset of FashionMNIST in pytorch
- Train: 54000 images
- Test: 10000 images
- Validation: 6000 images

To break the strict linearity of the model, I added a few leaky ReLU activation layers between the given layers  
### Transforms
- Standard ToTensor transform
- Z score Normalisation with dataset mean and standard deviation
- Simple augmentation (Horizontal flip) for the train, and none for the val and test

Note: The augmentation was initially absent and the result was almost the same  

### Hyperparameters
- Adam Optimizer with `lr_init=1e-3`
- Cosine Annealing with Warm Restarts `lr_scheduler`
- `T_0=100` `T_mul=2`
- `eta_min=1e-6`
- L2 regularisation with a weight decay of `1e-6`
- `n_epochs=100`

### Results
- Validation Accuracy: 87.68%
- Train Accuracy: 90%
- Test Accuracy: 86.68%

## Directory Structure
This directory contains 4 files (excluding readme.md):
- acc_loss.bin
- fmnist-1.ipynb
- model_wts.bin
- submissions.csv
### acc_loss.bin
Stores the history of recorded, pickled accuracy and loss values obtained during training and validation, used for plotting at the end of the jupyter notebook
### fmnist-1.ipynb
The jupyter notebook file that has the actual code with training loop outputs and final plots and accuracies
### model_wts.bin
Stores the pickled weights of the model corrsponding to the best accuracy - As it was explicitly mentioned to directly pickle, it was stored as a .bin file rather than the built in .pth file
### submissions.csv
Contains the final predictions of the trained model on the test dataset
