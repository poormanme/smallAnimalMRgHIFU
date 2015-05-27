function handle = onFGEN(handle);
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

%% Create TCP connection
% Create TCP/IP object 'fncngen'. Specify server machine and port number. 
handle.HIFU.fncngen = tcpip(handle.ipAddress, 5025,'NetworkRole','Client'); 

% Set size of receiving buffer, if needed. 
set(handle.HIFU.fncngen, 'InputBufferSize', 30000); 
disp('opening connection to FGEN ...')

% Open connection to the server. 
fopen(handle.HIFU.fncngen);
disp('connection created!');

%% Initialize pulser
ncycles = 500;
freq = 1.1; % MHz
handle.HIFU.Vmax = handle.vMax; % V
handle.HIFU.Vmin = 5e-3; % V

fprintf(handle.HIFU.fncngen,'OUTP1 OFF;');
fprintf(handle.HIFU.fncngen,'OUTP1:LOAD 50.0');
fprintf(handle.HIFU.fncngen,'OUTP1:POL NORM');

fprintf(handle.HIFU.fncngen,'SOUR1:FUNC:SHAP SIN;');
%fprintf(t,'SOUR1:FREQ 1.1e+06;');
%fprintf(t,'SOUR1:FREQ 3.68e+06;');
handle.HIFU.cmd = sprintf('SOUR1:FREQ %1.3fe+06;',freq);
fprintf(handle.HIFU.fncngen,cmd);
fprintf(handle.HIFU.fncngen,'SOUR1:VOLT:UNIT VPP;');
fprintf(handle.HIFU.fncngen,'SOUR1:VOLT 0.005;');
fprintf(handle.HIFU.fncngen,'SOUR1:VOLT:OFFS 0.0E+00;');
fprintf(handle.HIFU.fncngen,'SOUR1:VOLT:HIGH 2.5E-03;');
fprintf(handle.HIFU.fncngen,'SOUR1:VOLT:LOW -2.5E-03;');
%fprintf(t,'SOUR1:PHASe 0.000000E+00;');
fprintf(handle.HIFU.fncngen,'UNIT:ANGLe DEG;');
fprintf(handle.HIFU.fncngen,'SOUR1:SWEep:STATe OFF;');
fprintf(handle.HIFU.fncngen,'SOUR1:SWEep:SPAC LIN;');
fprintf(handle.HIFU.fncngen,'SOUR1:SWEep:RTIMe 0.0E+00;');
fprintf(handle.HIFU.fncngen,'SOUR1:SWEep:HTIMe 0.0E+00;');
fprintf(handle.HIFU.fncngen,'SOUR1:FREQ:STOP 1.0E+03;');
fprintf(handle.HIFU.fncngen,'SOUR1:FREQ:STAR 1.0E+02;');
fprintf(handle.HIFU.fncngen,'SOUR1:BURSt:STATe OFF;');
fprintf(handle.HIFU.fncngen,'SOUR1:BURSt:MODE TRIG;');
%fprintf(t,'SOUR1:BURSt:NCYCles 5.000E+02;');
handle.HIFU.cmd = sprintf('SOUR1:BURSt:NCYCles %1.3fE+00',ncycles);
fprintf(handle.HIFU.fncngen,cmd);
fprintf(handle.HIFU.fncngen,'SOUR1:BURst:GATe:POLarity NORM;');
fprintf(handle.HIFU.fncngen,'SOUR1:BURSt:PHASe 0.0e+00;');
fprintf(handle.HIFU.fncngen,'UNIT:ANGLe DEG;');
fprintf(handle.HIFU.fncngen,'OUTP1 OFF;');
fprintf(handle.HIFU.fncngen,'OUTP1:LOAD 50.0');
fprintf(handle.HIFU.fncngen,'OUTP1:POL NORM');

% define pid params
ppi.nom = handle.targT; % deg C, target mean temp in focus
ppi.pgain = handle.pGain; % proportional gain
ppi.igain = handle.iGain; 
ppi.cmin = 0;
ppi.cmax = 0.1;
handle.HIFU.ppi = ppi;
handle.HIFU.voltage = 0;
