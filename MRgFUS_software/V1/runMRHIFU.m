function outputs = runMRHIFU(basepath)
%% runMRHIFU provides a real-time, closed-loop feedback method to 
%% perform controlled hyperthermia via MR guided HIFU.
% Created by M. Poorman, W. Grissom - Fall 2014
% Institute of Imaging Science, Vanderbilt University, Nashville, TN
% Department of Biomedical Engineering, Vanderbilt University
%
% Function takes single-slice gradient echo images, along with user defined
% parameters, and calculates the temperature rise in degrees C at the focus
% of the HIFU transducer. It is intended to work with Varian fid data. 
%
% INPUTS:
% basepath ---- file path in single quotes to the fid containing base
%               anatomical image
% 
% OUTPUTS:
% images ------ data set of all images 
% calculated -- structure containing pertinent calculated variables (ie.
%               mean temperature over time, dosage, etc.)
%
% Function also plots the given temperature over time as the experiment is
% taking place in order to visualize the temperature rise.

%% Load Base Img
% Use a T1 or T2 weighted anatomical image taken before dynamic scans
% started
% NOTE: MUST BE SINGLE SLICE, SQUARE FOV (as of 20140924)
img = readInFID(basepath);
save('baseim.mat','img');
sz=size(img);
if sz(1) ~= sz(2);
    error('Base image is not single slice or square');
end

%% Call GUI for setup
handle = mrhifuSetUpGui;

%% Run Experiment
%% At this point you should start your dynamic scans on the MR scanner
waitRun = runExpGui;
while waitRun.run ==1
    % Initiate HIFU
%     handle = onFGEN(handle);

    % Run temperature mapping and visualize output
    %----- Also vizualize the output
    %----- runs CEM calc and field drift correction if selected

    handle.Therm.fp = 1;
    handle.Therm.keepgoing = 1;
    handle.Therm.tmax = 15; % deg C, for display
    handle.Therm.tmin = -5; 
%     keyboard
% % pause
    %---- While more images, keep reconstructing and plotting
%     try
        while handle.Therm.keepgoing
%             pause
            handle = runTemperatureReconstruction(handle);
        end
        handle = offFGEN(handle);
%     catch
%         pause
%         handle = offFGEN(handle);
%         disp('Error in execution...function generator output terminated.');
%     end
%     pause
    outputs = handle.Therm;
    waitRun.run = 0;
end
    

