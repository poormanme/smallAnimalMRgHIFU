function [CEM] = calcCEM_vect(meantemp,dt,T0)
% Created by M. Poorman Fall 2015
% Institute of Imaging Science, Vanderbilt University, Nashville, TN
% Department of Biomedical Engineering, Vanderbilt University

% calculate CEM dosage given 
% meantemp - vector of average temperatures (delta degrees C)
% dt - change in time vector (in seconds)
% T0 - body temperature beginning (degrees C)

% handle.T_0 = 37; %<---hard code body temp for now

% tmap = handle.Therm.tmap + handle.T_0;
R = [];
meantemp = meantemp + T0;

for ii = 1:length(meantemp)
    tmp = meantemp(ii);
%     keyboard
    if tmp <43
        R = 0.25;
    elseif tmp > 43
        R = 0.5;
    else
        R = 1;
    end
    CEM(ii) = dt/60*R.^(43-tmp);
end
