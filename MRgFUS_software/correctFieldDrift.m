function handle = correctFieldDrift(handle)
%% Correct for field inhomogenity from heating
% Created by M. Poorman, W. Grissom - Fall 2014
% Institute of Imaging Science, Vanderbilt University, Nashville, TN
% Department of Biomedical Engineering, Vanderbilt University
%
% Function subtracts off phase in region outside hotspot for correction
%
% INPUTS:
% handle ------ structure containing all inputs and data thus far
% 
% OUTPUTS:
% handle ------ same structure with corrected tmap 
%

phase = angle(handle.output.driftmask.*(handle.Therm.img(:,:,handle.Therm.nblocksread+1)));
avgPhase = mean2(phase(phase~=0));
handle.Therm.corrtmap = handle.Therm.tmap-abs(avgPhase);