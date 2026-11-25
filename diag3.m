function [out] = diag3(arr3, arr2)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% diag3(arr3, arr2)
%
% Helper function which sets the elements of a 3D array using the elements
% of a 2D array
%
% Requires the newer version of matlab > 2022 for the pagemtimes
% operations; 


[sz3_y, sz3_x, sz3_z] = size(arr3); 

GET_DIAG = 0; 
if ~exist('arr2', 'var')
    GET_DIAG = 1; 
end

%[sz2_y, sz2_x] = size(arr2); 

% __ >> There is no quick way to do this, so we'll use linear indices; 

dz = sz3_y*sz3_x; 

[X,Y] = meshgrid(1:sz3_x, 1:sz3_y); 
[Z,~]=meshgrid(0:dz:dz*sz3_z-dz,ones(1,sz3_x)); 
%______________
J = X*sz3_y - sz3_y; 
%J = X*(diag(1:sz3_y-1)-sz3_y); 
G = J+Y;

LI_xy = diag(G); 
LI_xyz = LI_xy*ones(1,sz3_z)+Z; 
%__________

if GET_DIAG
    out = arr3(LI_xyz); 
else
    arr3(LI_xyz) = arr2; 
    out = arr3; 
    1; 
end

end