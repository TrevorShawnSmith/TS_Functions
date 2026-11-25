function [normedArr, offset] = cellArrBSNorm(arr, OP_DIM, MV_PT_BIN) 
%Copyright (c) 2022 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% cellArrBSNorm
% Given a cell array (default horizontally concatenated OP_DIM = 2), take a moving
% least-squares slope (Y-intercept) estimate of the time series data, given
% a set mvpt window. Apply a constant offset to adjacent cell element (time
% series) to 'level' the signal if concatenated together. 
% (i.e no step artifacts at junctions), if cells were
% concatenated across the OP_DIM. (e.g. DC Correction)
%
% INPUTS
%   'arr' - N x K cell array of [1xM] time series datasets
%   'OP_DIM' - [1/2] Dimension over which to level (i.e. which to concatenate)
%       - Default = 2; 
%   'MV_PT_BIN' - [Int] Number of points to use in the moving least-squares
%       average estimate. 
%        - Default = 100
% OUTPUTS
%   'normedArr' - N x K cell array of normed Signal
%   'offset'    - NxK Doubles array of constant offset applied. 
%           - if number of output arguments = 1; skip



if ~exist('DIM', 'var')
    %// cat over columns
    OP_DIM = 2; 
end

if ~exist('MV_PT_BIN', 'var')
    MV_PT_BIN = 100; 
end

if OP_DIM == 1 
    arr = arr'; 
end

[N_ROWS, N_COLS] = size(arr); 

%--------------

intercept = cell(size(arr)); 

for r=1:N_ROWS
    for c=1:N_COLS
        [~, intercept{r,c}] = movLSSlope(arr{r,c}, MV_PT_BIN); 
    end
end

out = cellfun(@min, intercept);
offset = repmat(max(out,[],2),1,5)-out; 
% -- 

arr2 = arr; 
for r=1:N_ROWS
    for c=1:N_COLS
        arr2{r,c} = arr2{r,c}+offset(r,c); 
    end
end

if OP_DIM == 1
    normedArr = arr2'; 
else
    normedArr = arr2; 
end

if nargout == 1 
    offset = []; 
end

end