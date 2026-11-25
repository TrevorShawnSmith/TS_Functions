function vect = unravelDiagonal(mat)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% unravelDiagonal
% alternative way to 'vectorize' a matrix, which takes successive
% diagonals, which may be a preferable method to represent the data

% Assume 'mat' is square; 

nStates = size(mat,1); 
vect = zeros(nStates.^2,1); 

t0 = 1; 
for d = [-nStates+1: nStates-1]
    dv = diag(mat, d); 
    %
    t1 = t0+ nStates-abs(d)-1; 
    %
    vect(t0:t1) = dv; 
    t0 = t1+1; 
end

end