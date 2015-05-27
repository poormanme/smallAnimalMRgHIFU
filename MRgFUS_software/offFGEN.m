function handle = offFGEN(handle);
%% Switches the FGEN off at the end of the experiment
% Created by M. Poorman, W. Grissom - Fall 2014
% Institute of Imaging Science, Vanderbilt University, Nashville, TN
% Department of Biomedical Engineering, Vanderbilt University
%
% INPUTS:
% handle ------ structure containing all inputs and data thus far
% 
% OUTPUTS:
% handle ------ same structure with switch for FGEN added
%
%Stop pulsing and close out TCP connection
fprintf(handle.HIFU.fncngen,'OUTP1 OFF;');

% Disconnect and clean up the server connection. 
fclose(handle.HIFU.fncngen); 
delete(handle.HIFU.fncngen); 
clear handle.HIFU.fncngen