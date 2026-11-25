function [normMat] = normmat2max(mat, OP_DIM)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% normmat2max
% // General utility for quickly normalizing the values of an array to the
% maximum values of the maximum value of the dimension

DIM_SZ = size(mat); 
%N_DIM = length(DIM_SZ); 

maxVals = max(abs(mat), [], OP_DIM); 
DIM_SZ2 = size(maxVals); 

OP_DIM2 = find(DIM_SZ == DIM_SZ2); 

DIM_SZ2(OP_DIM2) = 1; 

normM = repmat(maxVals, DIM_SZ2); 

normMat = mat./normM; 

end