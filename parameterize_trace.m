function [xVal, xPos] = parameterize_trace(x, nPts)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% parameterize trace
%
% Operates under the assumption of a roughly monotonic input signal (x)
%
% Outputs a list of coordinates corresponding to percentages given an input signal,
% which can then be used for re-interpolation or timewarping. 
%
% INPUTS:
% [xVal,xPos] = parameterize_trace(x,nPts)
% - x = vector of signal to interpret
% - nPts = number of points to equally distribute the signal around, 
%   when defining percentages (n+1).
% OUTPUTS:
% - xVal = percentiles/ linker points. 
% - xPos = Indexed positions at queried percentiles. 

try
    dx = [0 diff(x)]; 
catch
    dx = [0; diff(x)]; 
end

xH = cumsum(abs(dx)); 

x0 = xH/xH(end); % scale 0 to 1. 

pRange = (0:nPts)/nPts; 


xPos = zeros(1,nPts); 
xVal = zeros(1,nPts); 

for p = 1:nPts+1
    xVal(p) = pRange(p); 
    xPos(p) = find(x0 >= xVal(p), 1); 
end


end

