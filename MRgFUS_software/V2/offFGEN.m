function offFGEN(fncngen)
% Created by M. Poorman, Fall 2015
% Institute of Imaging Science, Vanderbilt University, Nashville, TN
% Department of Biomedical Engineering, Vanderbilt University

%Stop pulsing and close out TCP connection
fprintf(fncngen,'OUTP1 OFF;');

% Disconnect and clean up the server connection. 
fclose(fncngen); 
delete(fncngen);