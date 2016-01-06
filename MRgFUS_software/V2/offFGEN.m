function offFGEN(fncngen)

%Stop pulsing and close out TCP connection
fprintf(fncngen,'OUTP1 OFF;');

% Disconnect and clean up the server connection. 
fclose(fncngen); 
delete(fncngen);