function plot3d(arr,DIM)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% plot3d
% Simple helper function to call plot3 in a less annoying fashion for an
% array; 

arguments
    arr
    DIM = 1; 
end

if DIM == 2; 
    arr = arr'; 
end

x = arr(1,:); 
y = arr(2,:); 
z = arr(3,:); 

plot3(x',y',z'); 


end
