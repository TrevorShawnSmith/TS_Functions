function [outMat] = matmultzvect(mat, vect)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% matmultzvect(mat, vect)
% --|| Scaling of the third dimension of a matrix, with the i'th 'page' of the
% matrix as scaled by the i'th element of the vector

[sz_x, sz_y, sz_z] = size(mat); 

[v_szA, v_szB] = size(vect); 
if v_szB > v_szA
    vect = vect';
    [v_szA, v_szB] = size(vect); 
end

if (sz_z == 1) && (v_szA > 1)
    mat = repmat(mat, 1, 1, v_szA); 
    sz_z = v_szA; 
end

pgScl = kron(vect, ones(sz_x*sz_y,1));

sclMat = reshape(pgScl, sz_x, sz_y, sz_z); 
outMat = sclMat.*mat; 

end