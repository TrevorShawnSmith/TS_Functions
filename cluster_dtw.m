function [splitData, rowOrder] = cluster_dtw(xt_cll, useIX, vars)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% cluster Delta-T 
%
% Script for identifying interactions between timeseries. 
%
% Uncharacterized exactly what I was using this for
%
%Analogous to the clustering of W, first we need to find the 'best fit',
%with the least modified elements. 
% --> We adapted back from the dtw to simple cos-sin-simularity

arguments
    xt_cll
    useIX = []; 
    vars.minClusters = 2; 
end

[N_XT_CH] = size(xt_cll,1); 
XT_LEN = size(xt_cll{1,1},2); 

if isempty(useIX)
    useIX = 1:XT_LEN; 
end

ten0 = cellzcat(xt_cll(:,1)); 
ten = ten0{1}; 

N_COMPS = size(ten,1); 

%% 1. Dist-Norm

%{
norm_ten = zeros(size(ten)); 
magVect     = zeros(N_COMPS, XT_LEN); 
for c = 1:N_COMPS
    arr = squeeze(ten(c,:,:))'; 
    magVect(c,:) = vmag(arr); 
    %
    invMag = 1./magVect(c,:); 
    invMag(isinf(invMag)) = 1; 
    scMat = repmat(invMag, N_XT_CH,1); 
    norm_arr = arr.*scMat; 
    norm_ten(c,:,:) = norm_arr'; 
    1; 
end
%}

norm_ten = ten; 
norm_ten(isnan(norm_ten)) = 0; 

%% 2. X-Comps
compDist    = zeros(N_COMPS); 
%rescaling indices; 
refIXCell   = cell(N_COMPS); 
compIXCell  = cell(N_COMPS); 

% -->> We need to extract the FIRST and ONLY pulse to better identify the
% problem

%// ref on y; comp on x; 
for ref_y = 1:N_COMPS
    ref_arr = squeeze(norm_ten(ref_y,useIX,:))'; 
    %
    ref_arr(isnan(ref_arr)) = 0; 
    %
    for comp_x = ref_y+1:N_COMPS
        comp_arr = squeeze(norm_ten(comp_x,useIX,:))'; 
        comp_arr(isnan(comp_arr)) =  0; 
        %
        covArr = cosSimCov(ref_arr, comp_arr); 
        %
        dist    = covArr(1,1); 
        refIX   = []; 
        compIX  = []; 
        %{
        % Dynamic Time-Warping between Time Series; 
        [dist, refIX, compIX] = dtw(ref_arr, comp_arr); 
        %
        %}
        % // Write-out
        compDist(ref_y, comp_x)     = dist; 
        refIXCell{ref_y, comp_x}    = refIX; 
        compIXCell{ref_y, comp_x}   = compIX;
    end
end
%// add covariance 
compDist = compDist + compDist'; 

eval = evalclusters(compDist,"kmeans","CalinskiHarabasz","KList",vars.minClusters:6);
%%this gives more... 
% -- >> cluster here is the similarity of the responses; 
nK = eval.OptimalK; 

splitData = cell(N_XT_CH, nK); 
for k = 1:nK
    LI = (eval.OptimalY == k); 
    for ch = 1:N_XT_CH
        splitData{ch, k} = norm_ten(LI,:,ch); 
    end
end

rowOrder = eval.OptimalY; 

if nargout == 1
    rowOrder = []; 
end

end