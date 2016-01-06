function [c,p] = pidupdate(c,meas,p)
%% Implements PID controller for use in thermometry
% Created by M. Poorman, W. Grissom - Fall 2014
% Institute of Imaging Science, Vanderbilt University, Nashville, TN
% Department of Biomedical Engineering, Vanderbilt University
%
% Function takes current voltage, temperature measure, and structure with
% controller parameters and previous iteration information.  It calculates
% output voltage based on proportional, integral, and derivative control
%
% INPUTS:
% c ----------- previous output voltage
% meas -------- current temperature measurement
% p ----------- structure with parameters and previous iteration info
% 
% OUTPUTS:
% c ----------- new voltage output
% p ----------- structure with parameters and iteration info

%% p is a struct that contains:
%  p.nom: nominal operating point
%  p.deltaold: error integral 
%  p.pgain: proportional error gain
%  p.igain: integral error gain
%  p.dgain: derivative error gain
%  p.cmin: min controller value
%  p.cmax: max controller value

if ~isfield(p,'deltaold')
  p.deltaold = 0;
end

if ~isfield(p,'deltaprev')
  p.deltaprev = 0;
end

delta = p.nom - meas; % calc error
changedelta = delta-p.deltaprev;
[p.pgain*delta p.igain*p.deltaold p.dgain*changedelta];

c = c+ p.pgain*delta + p.igain*p.deltaold +p.dgain*changedelta; % update control

% add the error into integral for the next iteration
p.deltaold = p.deltaold + delta;
p.deltaprev = delta;

% constrain to feasible controller values
c = max(c,p.cmin);
c = min(c,p.cmax);
