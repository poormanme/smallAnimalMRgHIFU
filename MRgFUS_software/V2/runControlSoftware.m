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
reconMode = 1;

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
    ppi.nom = 6; %deg C
    ppi.pgain = 0.001;
    ppi.igain = 0.00001;
    ppi.dgain = 0.005;
    ppi.cmin = 0;
    ppi.cmax = 0.1;

    %---FUS
    fus.Vmax = 70e-3; %V
    fus.Vmin = 5e-3; %V
    fus.frequency = 1.1; %MHz
    fus.ipaddress = '10.200.32.57';

    %---CEM values
    CEM.T0 = 37.3; %deg C
    algo.quitwithCEM = 1;
    CEM.thresh = 20; %CEM43
    
    %---algorithm settings
%     algo.dynfilepath = '~/vnmrsys/exp2/acqfil/fid';
%     algo.dynfilepath = '~/vnmrsys/data/studies/s_20160417_03/gems_hifu_01.fid/fid';
    algo.dynfilepath = '/buffyexport/home/poormame/Documents/Data/laserFiber/s_20170524_02/gems_29.fid/fid';
    algo.dispSlice = 1; 
    if algo.dispSlice <= 0
        warning('Invalid Display Slice (set to 0 or below)...make sure to set appropriately if it is a multislice scan');
    end
    algo.focusROI = zeros(512);
    algo.focusROI(238:262,335:358) = true;
    [r,c] = find(algo.focusROI > 0);
    algo.focusvect = [c(1)-1 r(1)-1 c(end)-c(1)+2 r(end)-r(1)+2];
    algo.quitwithCEM = 0;
    algo.driftcorr = 'none'; % 'none' = no correction; 'roi' = roi based; 'lookuptable' = lookup table based <-requires calibration file for your scanner/gradient set
    algo.driftroi = zeros(512);
    algo.driftroi(190:230,100:140) = true; %define if want ROI
    [r,c] = find(algo.driftroi > 0);
    algo.driftvect = [c(1)-1 r(1)-1 c(end)-c(1)+2 r(end)-r(1)+2];
    algo.gamma = 42.58; %MHz/T
    algo.alpha = 0.01; %ppm/deg C;
%     keyboard
else
    
    %---call UI
    handle = userinterface;
    
    %---restructure variables
    %-PID
    ppi.nom = guiParams.targetRise;
    ppi.pgain = guiParams.pgain;
    ppi.igain = guiParams.igain;
    ppi.dgain = guiParams.dgain;
    ppi.cmin = 0;
    ppi.cmax = 0.1;


    %-FUS
    fus.Vmax = guiParams.vmax;
    fus.Vmin = guiParams.vmin;
    fus.frequency = guiParams.frequency;
    fus.ncycles = guiParams.ncycles;
    fus.ipaddress = guiParams.ipaddress;

    %-CEM values
    CEM.T0 = guiParams.startingTemp;
    if ~isfield(guiParams,'threshCEM')
        algo.quitwithCEM = 0;
    else
        algo.quitwithCEM = 1;
        CEM.thresh = guiParams.threshCEM;
    end

    %-algorithm settings
    if isfield(guiParams,'sliceChoice')
        algo.dispSlice = guiParams.sliceChoiceVal;
    end
    algo.dispSlice = guiParams.sliceChoice;
    algo.dynfilepath = guiParams.dynPath;
    algo.focusROI = guiParams.focusROI;
    algo.focusvect = guiParams.focusvect;
    if ~isfield(guiParams,'driftroi');
        algo.driftcorr = 0;
    else
        algo.driftcorr = 1;
        algo.driftroi = guiParams.driftroi;
        algo.driftvect = guiParams.driftvect;
    end
    algo.gamma = 42.58; %MHz/T
    algo.alpha = 0.01; %ppm/deg C
    return
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
proceed = waitRun.UserData; %matlab version fix by R Weires

%% Run the sonication experiment 

while proceed
    
%     try
        keepgoing = 1;
        
        outputs = runTempRecon(fus,algo,imgp,ppi,CEM,keepgoing,reconMode);

%      catch
         if ~reconMode
             offFGEN(fus.fncngen);
         end
         
         warning('Error in execution...function generator output terminated.');
         
         return;
%      end
    
    %---Stop sonication
    disp('stopping sonication...');
    if ~reconMode
        offFGEN(fus.fncngen);
    end
    proceed = 0;
    disp('Done');
end

%% Save data
if saveData
    save(saveloc);
end
return

%%
figure;subplot(311);plot(meantemp);title('PyNGL 58 - Focal Temperature');
xlabel('img #');ylabel('\Delta \circ C');
hold on;plot(1:length(meantemp),6*ones(1,length(meantemp)),'r');
subplot(312);plot(voltVals); title('Output Voltage');
xlabel('img #');ylabel('mV');
subplot(313);plot(CEMact_tot);
