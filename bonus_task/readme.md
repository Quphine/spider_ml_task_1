# Bonus Task

This directory is composed of two sub-directories: v1 and v2\
:small_red_triangle:<ins>v2 is the final version</ins>, v1 is just an intermediate

## Overview

In this project, I was tasked to build an autoencoder (without CNNs) using plain MLP architecture.  

### My Architecture 
Image 28x28 → Flatten → 784  
  
Branch 1  
Linear 784 → 512 → GELU  
Linear 512 → 128 → GELU  
  
Branch 2  
Linear 784 → 256 → GELU  
Linear 256 → 64 → GELU  
Combine outputs of Branch 1 and Branch 2 → 128 + 64 = 192  
  
Final Layer  
Linear 192 → 64 → GELU  
Latent embedding of size 64

The same was mirrored for the decoder architecture, starting from the 64 element latent embedding  
This architecture utilizes the Gaussian Error Linear Unit (GELU) which encourages smoother gradients, better gradient flow and henceforth better final model accuracy (in this case better evaluation metric value) compared to ReLU  

### Evaluation Metric
Initially, I tried using simple RMSE and RMSLE and it was clear the model had a very bad visual output as the loss functions did not capture spatial information or the intricate details of the input image. To overcome this disadvantage without the introduction of CNN layers, I implemented MSSSIM (Multi-Scale Structural Similarity Index Measurement), which manages to capture the spatial data.   

Calculation of MSSSIM involves three layers [say `L1`, `L2`, `L3`] (in this case), with each layer outputting a single SSIM score
An SSIM score between the actual and the generated image is calculated by obtaining three quatities:
- Luminance (Compares mean value of Pixel intensity)
- Contrast (Variance of Pixel Intensity)
- Structure (Covariance of Pixel Intensity)

These quantities are multiplied and averaged over a batch to obtain the final SSIM score of the batch  
We begin at `L1` 28x28 and obtain the first SSIM (`S1`)  
This is forwarded to the second layer `L2` by passing the previous image through a 2x2 kernel with a stride 2 (Avg Pool) and the second SSIM is calculated. The same process is repeated for the third.
Finally, the MSSSIM is calculated by `[(S1)^W1]*[(S2)^W2]*[(S3)^W3]`
I set weights to be equal 0.33, meaning that all details have equal priorities (i.e deviation from coarse details `[7*7]` has the same penalty as deviation from the finer ones `[28*28]`

Loss: 1 - MSSSIM
### Hyperparameters
lr_scheduler - Cosine Annealing with Warm Restarts  
`T_0` 35 epochs  
`T_mul` 2    
`eta_min` `1e-6`  
Adam - init_lr of `0.003`  
  
Note: I also added L2 regularisation with weight decay of `1e-5` to prevent overfitting  


## Subdirectory (v2) Structure
This dir contains three files (excluding readme.md):
  - acc_loss_v2.bin
  - autoencoder-v2.ipynb
  - autoencoder_wts_v2.pth

### acc_loss_v2.bin
This file stores the pickled dictionary of MSSSIM and loss history of the autoencoder model, later utilised make plots within the notebook (.ipynb)

### autoencoder-v2.ipynb
Jupyter notebook with the actual code/implementation, epochial data from the training loops and evaluation metric plots

### autoencoder_wts_v2.pth
This file stores the final model weights with the best validation evaluation metric (MSSSIM) - 0.8847

