function normalpdf = normPDFcol_2unity3D(arr, handleNeg)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% Normalize PDF Columns to Unity (3D)
% Treat column vectors as discretely (and homogenously) sampled probability
% distribution functions. Elementwise division of each element by the sum
% of its column. 

% Because p(x) cannot equal zero, handle negative values of columns either
% by 1) treating x<0 as x = 0 or 2) 'leveling' = adding a scalar to the
% whole vector to make the most negative value == 0.

% This version can be applied to a 3D array

% -- Trevor S. Smith


%// Assume that the array contains col vectors representing probability
%density functions. Normalize colwise using vectors

%// Assume arr is a 3D array; 

%Handle Neg; (no part of PDF can be < 0)
    %'level' = translate PDF by |min|
    %'zero' = all < 0; --> 0
    %'none' = Not defined as a case; --> essentially uncorrected 

if nnz(any(arr<0)>0) % note 'all' tag not valid with my version of MATLAB
    switch handleNeg
        case 'level'
            %// This won't work in 3D space...
            arr = arr+repmat(abs(min(arr)), size(arr,1),1, size(arr,3)); 
            %arr = arr+ abs(min(arr)); 
        case 'zero'
            arr(arr<0) = 0; 
    end
end

scalearr = repmat(sum(arr,2), 1, size(arr,1), 1); 
normalpdf = arr./scalearr; 

normalpdf(isnan(normalpdf)) = 0; %flush NaNs to 0; 

end