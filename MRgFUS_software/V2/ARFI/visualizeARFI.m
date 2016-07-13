%% Script to read in ARFI images using eddy current correction method

% Created by M. Poorman, Fall 2015
% Institute of Imaging Science, Vanderbilt University, Nashville, TN
% Department of Biomedical Engineering, Vanderbilt University

%% Define parameters
prefix = '~/buffyhome/Documents/Data/Thermom/horiz47t/s_20160422_01/gems_meg_'; %path to ARFI images
gamma = 2*pi*42.58e6; %Mrad/T
rad2um = @(Ge,tau) 1/(2*gamma*Ge*tau)*10^6; %convert radians to micrometers based on ARFI Equation
parms = parsepp([prefix,num2str(noFUS_pos),'.fid']); %sequence characteristics

%% Read in ARFI images (using eddy current corrections)

noFUS_pos = 34; %image with no FUS and positive motion encoding gradient (MEG)
noFUS_neg = 36; %image with no FUS and negative MEG
yesFUS_pos = 35; %image with FUS and positive MEG
yesFUS_neg = 37; %image with FUS and negative MEG

[img_noFUS_pos,img_100mV_pos,diff_pos] = readARFI([prefix,num2str(noFUS_pos),'.fid/fid'],[prefix,num2str(yesFUS_pos),'.fid/fid']);
[img_noFUS_neg,img_100mV_neg,diff_neg] = readARFI([prefix,num2str(noFUS_neg),'.fid/fid'],[prefix,num2str(yesFUS_neg),'.fid/fid']);
phaseDiff = diff_neg-diff_pos;

%% Convert to micrometers and display

Ge_G_cm = parms.mygradamp; %G/cm
Ge_T_m = Ge_G_cm*(10^-4)*(100); %T/m
dur = parms.mygraddur; %s

immask = abs(img_noFUS_neg) > 0.1.*max(abs(img_noFUS_neg(:)));

displacement_um = (phaseDiff).*immask*rad2um(Ge_T_m,dur);

figure;imagesc(displacement_um);axis image;