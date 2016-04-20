close all; clear all; clc;
%% runControlSoftware provies a real-time, closed-loop feedback method to 
%% perform controlled MRgFUS of small animals.
% Created by M. Poorman, December 2015
% Institute of Imaging Science, Vanderbilt University, Nashville, TN
% Department of Biomedical Engineering, Vanderbilt University

% The script execution can be controlled via gui or direct script.  Toggle
% the gui variable below to use the gui execution or not
useGUI = 0;

% You can also run the script execution in recon mode to re-watch a 
% sonication without inducing heat or sending signals to the FUS system.  
% Set the variable below to 1 to run a post-processing. Set to 0 to conduct
% real-time sonication
reconMode = 0;

% If you would like to save the data please use the below toggle and define
% a folder location
saveData = 0;
saveloc = ['~/myfilepath/',num2str(clock),'.mat'];

% The script is modular and can be adapted for other scanner systems
% The default values are in place, directly polling the varianc acq file

%% Setup the execution
if ~useGUI 
    
    %%%%% USER SETUP PARAMETERS HERE IF NOT USING GUI 
    
    %---PID
    ppi.nom = 4; %deg C
    ppi.pgain = 0.001;
    ppi.igain = 0.00001;
    ppi.dgain = 0.005;
    ppi.cmin = 0;
    ppi.cmax = 0.1;

    %---FUS
    fus.Vmax = 70e-3; %V
    fus.Vmin = 5e-3; %V
    fus.ncycles = 500;
    fus.frequency = 1.1; %MHz
    fus.ipaddress = '10.200.32.57';

    %---CEM values
    CEM.T0 = 37; %deg C
    algo.quitwithCEM = 0;
    CEM.thresh = 20; %CEM43
    
    %---algorithm settings
    %algo.dynfilepath = '~/vnmrsys/exp2/acqfil/fid';
    algo.dynfilepath = '~/vnmrsys/data/studies/s_20160417_03/gems_hifu_01.fid/fid';
    %algo.dynfilepath = '~/buffyhome/Documents/Data/Thermom/horiz47t/s_20151213_01/gems_hifu_05.fid/fid';
    algo.focusROI = zeros(512);
    algo.focusROI(255:275,255:275) = true;
    [r,c] = find(algo.focusROI > 0);
    algo.focusvect = [c(1)-1 r(1)-1 c(end)-c(1)+2 r(end)-r(1)+2];
    algo.quitwithCEM = 0;
    algo.driftcorr = 1;
    algo.driftroi = zeros(512);
    algo.driftroi(380:420,345:385) = true;
    [r,c] = find(algo.driftroi > 0);
    algo.driftvect = [c(1)-1 r(1)-1 c(end)-c(1)+2 r(end)-r(1)+2];
    algo.gamma = 42.58; %MHz/T
    algo.alpha = 0.01; %ppm/deg C
else
    
    %---call UI
    handle = userinterface;
    
    %---restructure variables
    %-PID
    ppi.nom = handle.targetRise;
    ppi.pgain = handle.pgain;
    ppi.igain = handle.igain;
    ppi.dgain = handle.dgain;
    ppi.cmin = 0;
    ppi.cmax = 0.1;


    %-FUS
    fus.Vmax = handle.vmax;
    fus.Vmin = handle.vmin;
    fus.frequency = handle.frequency;
    fus.ncycles = handle.ncycles;
    fus.ipaddress = handle.ipaddress;

    %-CEM values
    CEM.T0 = handle.startingTemp;
    if ~isfield(handle,'threshCEM')
        algo.quitwithCEM = 0;
    else
        algo.quitwithCEM = 1;
        CEM.thresh = handle.threshCEM;
    end

    %-algorithm settings
    algo.dynfilepath = handle.dynPath;
    algo.focusROI = handle.focusROI;
    algo.focusvect = handle.focusvect;
    if ~isfield(handle,'driftroi');
        algo.driftcorr = 0;
    else
        algo.driftcorr = 1;
        algo.driftroi = handle.driftroi;
        algo.driftvect = handle.driftvect;
    end
    algo.gamma = 42.58; %MHz/T
    algo.alpha = 0.01; %ppm/deg C
    
end
%---load image params

try
    imgp = parsepp(algo.dynfilepath(1:end-4));
catch
    warning('Error in reading image parameter file...experiment aborted');
	return;
end

%---Initialize function generator
if ~reconMode
    tic;
    fus.fncngen = initFGEN(fus);
    execution.fgen = toc;
end

%---wait for run command
waitRun = runExpGui;
proceed = waitRun.run;
%% Run the sonication experiment 

while proceed
    
    try
        keepgoing = 1;
        
        outputs = runTempRecon(fus,algo,imgp,ppi,CEM,keepgoing,reconMode);

     catch
         if ~reconMode
             offFGEN(fus.fncngen);
         end
         warning('Error in execution...function generator output terminated.');
         return;
     end
    
    %---Stop sonication
    disp('stopping sonication...');
    if ~reconMode
        offFGEN(fus.fncngen);
    end
    proceed = 0;
    disp('Done');
end
outputs.execution.fgen = execution.fgen;

%% Save data
if saveData
    save(saveloc);
end