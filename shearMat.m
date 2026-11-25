function [sMat] = shearMat(mat, shear,dim)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%% shearMat(mat, shear, dim)
%
% Used to 'shear' a matrix (element-advance each column/row by 1, iteratively)

arguments
    mat
    shear = 1; %offset; dummy; 
    dim = 1; %dummy
end

[N_X, N_Y] = size(mat); 

N_Y2 = 2*N_Y*shear-1; 

N_X2 = N_X; 

sMat = nan(N_Y2,N_X2); 
for jj = 1:N_X
    if shear > 0
        y0 = N_Y-jj+1; 
        y1 = 2*N_Y-jj; %+1;
    elseif shear < 0
        y0 = jj;  
        y1 = N_Y+jj-1; %+1;
    end
    %
    sMat(y0:y1,jj) = mat(:,jj); 
end

end