function [shearMat] = getShearMatrix(mat)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% getShearMatrix()
% Support function for returning a 'shear' of the given matrix. 
% Used for plotting and display; 


N_STATES = size(mat,1); 

shearMat = zeros(2*N_STATES-1,N_STATES); 

for x = 1:N_STATES
    x0 = x; 
    x1 = x+N_STATES-1; 
    shearMat(x0:x1,:) = mat(1:N_STATES,:); 
end
end