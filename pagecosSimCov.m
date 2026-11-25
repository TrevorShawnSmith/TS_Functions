function [covmat] = pagecosSimCov(M1, M2, vars); 
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% pagewise cosine similarity covariance (pagecossim)
% Fairly generic method for assigning similarity between pages of two
% 3D matrices A, B. Here, Dim_1: A == Dim_1: B && Dim_2:A == Dim_2:B;
% Dimension 3 can differ; 
%
% INPUTS: 
% - M1 : 3D Matrix - Reference
% - M2 : 3D Matrix - Query
% OUTPUTS: 
% - covmat = the pagewise cosine similarity

% NAME-VALUE PAIRS: 
% - 'handleZero' {Boolean}

% Analogous function to cosSimCov, but for pages (Dim 1x2 of 3D Array); 

% This was originally built for the 3D SDOs; evaluting similarity of arrays

arguments 
    M1
    M2 = []; 
    vars.handleZero {mustBeNumeric} = 1; 
    %vars.handleZero {mustBeMember(vars.handleZero, {1, 0})} = 1; 
end

if isempty(M2); 
    M2 = M1; %Autocorrelation
end

[A_1, A_2, A_3] = size(M1); 
[B_1, B_2, B_3] = size(M2); 

covmat = zeros(A_3, B_3); 

if ~((A_1 == B_1) && (A_2 == B_2))
    warning("Matrices not compatible"); 
    
    return
end

%elseif ~(A_3 == B_3)
    % elementwise; 
    for row = 1:A_3
        for col = 1:B_3
            numer = sum(M1(:,:,row).*M2(:,:,col), 'all'); 
            denom = sum(0.5*(M1(:,:,row).^2 + M2(:,:,col).^2), 'all'); %mean
            covmat(row,col) = numer/denom; 
        end
    end
%end

% __ posthoc conform; 
if any(isnan(covmat), 'all')
    covmat(isnan(covmat)) = vars.handleZero; 
end

1; 

end
