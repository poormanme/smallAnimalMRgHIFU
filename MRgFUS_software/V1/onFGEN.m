function handle = onFGEN(handle)
%% Turns on the function generator/HIFU
% Created by M. Poorman, W. Grissom - Fall 2014
% Institute of Imaging Science, Vanderbilt University, Nashville, TN
% Department of Biomedical Engineering, Vanderbilt University
%
%
% INPUTS:
% handle ------ structure containing all inputs and data thus far
% 
% OUTPUTS:
% handle ------ same structure with switch for FGEN added
%
if voltage == 0
    fprintf(handle.HIFU.fncngen,'OUTP1 OFF;');
else
    fprintf(handle.HIFU.fncngen,'OUTP1 ON;');
    cur_cmd = sprintf('SOUR1:VOLT %1.5f;',handle.HIFU.voltage);
    fprintf(handle.HIFU.fncngen,cur_cmd);
end

