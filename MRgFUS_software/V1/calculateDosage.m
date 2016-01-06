function cem = calculateDosage(handle,t)
% keyboard
%% Calculate dosage (CEM - cumulative equivalent minutes) 
% Created by M. Poorman, W. Grissom - Fall 2014
% Institute of Imaging Science, Vanderbilt University, Nashville, TN
% Department of Biomedical Engineering, Vanderbilt University
%
% Function takes handle of data run thus far and inputs to calculate CEM
%
% INPUTS:
% handle ------ structure containing all inputs and data thus far
% 
% OUTPUTS:
% handle ------ same structure with new field for calculated CEM
%
%% calc CEM

% t - time since beginning (in seconds)
% T_0 - body temp (degrees C)
% tmap - current temperature map (degrees C)
% keyboard
% keyboard;
handle.T_0 = 37; %<---hard code body temp for now

tmap = handle.Therm.tmap + handle.T_0;

Rabove = tmap;
Rbelow = Rabove;
Requal = Rabove;
Rabove(Rabove<43) = NaN;
Rabove(Rabove>=43) = 1/2;
Rbelow(Rbelow>=43) = NaN;
Rbelow(Rbelow<43) = 1/4;
Requal(Requal~=43) = NaN;
Requal(Requal==43) = 1;

Requal(isnan(Requal)) = 0;
Rabove(isnan(Rabove)) = 0;
Rbelow(isnan(Rbelow)) = 0;

R = Requal+Rabove+Rbelow;

cem = t/60*R.^(43-tmap);

% keyboard
% temps = handle.Therm.tmap + 37; % 37 is body temp                       
% dim = size(temps);
% 
% % Create running CEM count if does not exist already
% if handle.Therm.nblocksread == 2
%     handle.Therm.runCEM = zeros(dim(1), dim(2),1);
% end
% curCEM = zeros(dim(1), dim(2), 3);
% 
% % Calculate current CEM depending on what temperature is
% R = [0.5 0.25 1];
% CEMup = temps > 43 ;
% CEMmid = temps == 43;
% CEMdown = temps < 43;
% curCEM(:,:,1) = (R(1).^(43-(temps.*CEMup)))*TR;
% curCEM(:,:,2) = (R(3).^(43-(temps.*CEMmid)))*TR;
% curCEM(:,:,3) = (R(2).^(43-(temps.*CEMdown)))*TR;
% curCEM = cumsum(curCEM,3);
% 
% % Update running measure of CEM calculation
% handle.Therm.runCEM= cat(3,handle.Therm.runCEM,curCEM(:,:,3));
% 
% % Find mean CEM in focus
% sumCEM = cumsum(runCEM,3);
% tCEM = sumCEM(:,:,end);
% % figure(2)                   %----uncomment for verification purposed
% % subplot(221);
% % imagesc(tCEM);
% % colorbar;
% % title ('CEM');
% % axis image;
% 
% roiCEM = tCEM(handle.output.focusmask);
% % subplot(222);               %----uncomment for verification purposed
% % imagesc(roiCEM);
% % colorbar;
% % title ('CEM ROI');
% % axis image;
% 
% handle.Therm.meanCEM(end+1) = mean2(roiCEM(roiCEM~=0));
% % subplot(212);               %----uncomment for verification purposed
% % plot(t(1:length(meanCEM)),meanCEM);
% % xlim([0 eps+t(length(meanCEM))]);% tmin tmax]);
% % xlabel('Block Index');
% % ylabel ('Mean Dosage (CEM43)');