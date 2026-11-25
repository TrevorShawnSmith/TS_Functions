function classMat = getCooccurrenceMatrix(N_EVENTS, N_DIGITS )
%Copyright (c) 2023 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% Get Co-Occurence Matrix 
% Generate a binary array of [(2^N_EVENTS)-1, N_EVENTS] which corresponds
% to the 'class definitions' of which events are cooccuring. 
% Starts with single-digit classes (A,B,C ... ), then two-event classes (A+B), 
% (A+C) ... , then three-event classes, etc. 
%
% INPUTS: 
%   N_EVENTS = Number of independent events
%   N_DIGITS = Maximum number of co-occuring events to check for. 
% OUTPUTS:
%   classMat = binary array, described as above. 

arguments
    N_EVENTS 
    N_DIGITS = N_EVENTS; 
end

nComps = (2^N_EVENTS)-1; 

classMat = zeros(nComps, N_EVENTS);  

i0 =1; 
for d = 1:N_DIGITS
    perms = nchoosek([1:N_EVENTS], d); 
    [nRows,nCols] = size(perms); 
    subMat = zeros(nRows, N_EVENTS); 
    for r = 1:nRows
        subMat(r,perms(r,:)) = ones(1, nCols);  
    end
    %
    classMat(i0:i0+nRows-1,:) = subMat; 
    i0 = i0+nRows; 
end

if ~(N_EVENTS == N_DIGITS)
    %// trim matrix
    LI = (sum(classMat,2) > 0); 
    classMat = classMat(LI,:); 
end

end