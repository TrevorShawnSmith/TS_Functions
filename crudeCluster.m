function [groupArr] = crudeCluster(covMat)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% crudeCluster
% // using provided square data, sort in one dimension, then sort in the
% other. If groups are obvious, this will pull them out
%
%// was written to work with the cosSimCov mat 

N_COLS = length(covMat); 

rowID = meshgrid(1:N_COLS, 1:N_COLS)'; 
colID = 1i*rowID'; %// use an im term here so that I seg out as real/im later

z_ID = rowID + colID; 

[~, rowSort] = sort(covMat(:,1), 'descend'); 

z_ID2   = z_ID(rowSort,:); 
covMat2 = covMat(rowSort,:); 

[~, colSort] = sort(covMat2(1,:), 'descend'); 

z_ID3   = z_ID2(:,colSort); 
covMat3 = covMat2(:, colSort); 


rowID_out = real(z_ID3); 
colID_out = imag(z_ID3); 

% --> As we are just looking at correlations, we could just cluster
% pos/neg; 

LI_col_pos = covMat3(1,:) > 0; 
LI_col_neg = covMat3(1,:) <= 0; 
LI_row_pos = covMat3(:,1) > 0; 
LI_row_neg = covMat3(:,1) <=0; 

groupA = unique([colID_out(1,LI_col_pos) rowID_out(LI_row_pos)']); 
groupB = unique([colID_out(1, LI_col_neg) rowID_out(LI_row_neg)']); 

groupArr = {groupA, groupB}; 


end
