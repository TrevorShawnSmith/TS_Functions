function [mag] = vmag(xt, OP_DIM)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% vmag (vector magnitude)
% Simple utility to take the magnitude of a (row) vector. 
% If input is N*K array, perform the magntitude for each row. 
%
% OP_DIM = dimension to calculate magnitude along; 

% Trevor 

if ~exist('OP_DIM', 'var')
    OP_DIM = 1; 
end

% --> NaN flush?
%NAN_LI = isnan(xt); 
% Since we're measuring vector magnitude, I think excluding nans makes more
% sense than setting them to 0. All Nans --> Nan; 

xt2 = xt.^2; 
mag = sum(xt2, OP_DIM, 'omitnan').^0.5;

nan_LI = all(isnan(xt2), OP_DIM); 

if nnz(nan_LI) < 1
    return; 
end

% -- Not sure the best logic here to clean this up w/ available func; 
switch ndims(xt2)
    case 1
        if OP_DIM == 2 
            mag(nan_LI) = nan; 
        end
    case 2 
        if OP_DIM == 1 % columns; 
            mag(1,nan_LI) = nan; 
        elseif OP_DIM == 2
            mag(nan_li,1) = nan; 
        end
    case 3
        % Check this!
        if OP_DIM == 1
            mag(1,:,nan_LI) = nan; 
        elseif OP_DIM == 2
            mag(:,1,nan_LI) = nan; 
        elseif OP_DIM == 3
            mag(nan_LI,:,1) = nan; 
        end
end
 
end