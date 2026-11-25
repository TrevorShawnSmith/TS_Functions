function [arr] = rowMult(V1, V2); 
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% rowMult
%DEPRECIATED: Should use diag(V1)*A (rowscale) or A*diag(V1) (colscale)
%
% Macro to perform a multiplication operation not directly supported. 
%
% Used when I have a 1xN (usually time series value), to which I want to
% act as a scalar multiplier in each column to a col vect; 
%
%
% [V2 (mx1)] x [V1 (1xn)] ---> MatArr (mxn); Each column m, were the elements
% of V1, scaled by the value of V2 at (n)



[sz1, ~] = size(V2); 
if sz1 == 1; 
    V2 = V2';
end

arr = repmat(V1, length(V2),1).*repmat(V2, 1, length(V1)); 

end
