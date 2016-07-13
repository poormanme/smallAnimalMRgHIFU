%% Script to read in 2 images and compute phase difference between 2 (for ARFI)

% Created by M. Poorman, Fall 2015
% Institute of Imaging Science, Vanderbilt University, Nashville, TN
% Department of Biomedical Engineering, Vanderbilt University

function [img1,img2,diff] = readARFI(f1,f2)

% read in image 1
img1 = readInFID(f1);
% read in image 2
img2 = readInFID(f2);

% Compute ARFI image

diff = angle(img1.*conj(img2));
