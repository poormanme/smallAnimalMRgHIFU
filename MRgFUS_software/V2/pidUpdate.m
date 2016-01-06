function [c,p] = pidUpdate(c,meas,p)
% Created by M. Poorman, W. Grissom Fall 2015
% Institute of Imaging Science, Vanderbilt University, Nashville, TN
% Department of Biomedical Engineering, Vanderbilt University
% function updates control variable c, based on current state meas and 
% parameters p

% p is a struct that contains:
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
% [p.pgain*delta p.igain*p.deltaold p.dgain*changedelta]

% c = c + p.pgain*delta + p.igain*p.deltaold; % update control
% c = p.pgain*delta + p.igain*p.deltaold; % update control
c = c+ p.pgain*delta + p.igain*p.deltaold +p.dgain*changedelta; % update control
% add the error into integral for the next iteration
p.deltaold = p.deltaold + delta;
p.deltaprev = delta;
% constrain to feasible controller values
c = max(c,p.cmin);
c = min(c,p.cmax);
