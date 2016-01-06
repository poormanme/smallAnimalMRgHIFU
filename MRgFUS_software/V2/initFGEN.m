function fncngen = initFGEN(fus)
% Created by M. Poorman, Fall 2015
% Institute of Imaging Science, Vanderbilt University, Nashville, TN
% Department of Biomedical Engineering, Vanderbilt University


% Create TCP/IP object 'fncngen'. Specify server machine and port number. 
fncngen = tcpip(fus.ipaddress, 5025,'NetworkRole','Client'); 

% Set size of receiving buffer, if needed. 
set(fncngen, 'InputBufferSize', 30000); 

% Open connection to the server. 
disp('opening connection..')
fopen(fncngen);
disp('connection created!');

% Initialize pulser
fprintf(fncngen,'OUTP1 OFF;');
fprintf(fncngen,'OUTP1:LOAD 50.0');
fprintf(fncngen,'OUTP1:POL NORM');

fprintf(fncngen,'SOUR1:FUNC:SHAP SIN;');
cmd = sprintf('SOUR1:FREQ %1.3fe+06;',fus.frequency);
fprintf(fncngen,cmd);
fprintf(fncngen,'SOUR1:VOLT:UNIT VPP;');
fprintf(fncngen,'SOUR1:VOLT 0.005;');
fprintf(fncngen,'SOUR1:VOLT:OFFS 0.0E+00;');
fprintf(fncngen,'SOUR1:VOLT:HIGH 2.5E-03;');
fprintf(fncngen,'SOUR1:VOLT:LOW -2.5E-03;');
%fprintf(t,'SOUR1:PHASe 0.000000E+00;');
fprintf(fncngen,'UNIT:ANGLe DEG;');
fprintf(fncngen,'SOUR1:SWEep:STATe OFF;');
fprintf(fncngen,'SOUR1:SWEep:SPAC LIN;');
fprintf(fncngen,'SOUR1:SWEep:RTIMe 0.0E+00;');
fprintf(fncngen,'SOUR1:SWEep:HTIMe 0.0E+00;');
fprintf(fncngen,'SOUR1:FREQ:STOP 1.0E+03;');
fprintf(fncngen,'SOUR1:FREQ:STAR 1.0E+02;');
fprintf(fncngen,'SOUR1:BURSt:STATe OFF;');
fprintf(fncngen,'SOUR1:BURSt:MODE TRIG;');
%fprintf(t,'SOUR1:BURSt:NCYCles 5.000E+02;');
cmd = sprintf('SOUR1:BURSt:NCYCles %1.3fE+00',fus.ncycles);
fprintf(fncngen,cmd);
fprintf(fncngen,'SOUR1:BURst:GATe:POLarity NORM;');
fprintf(fncngen,'SOUR1:BURSt:PHASe 0.0e+00;');
fprintf(fncngen,'UNIT:ANGLe DEG;');
fprintf(fncngen,'OUTP1 OFF;');
fprintf(fncngen,'OUTP1:LOAD 50.0');
fprintf(fncngen,'OUTP1:POL NORM');