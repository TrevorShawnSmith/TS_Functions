function [xtcm] = xtxcorrmat(xt1, xt2, N_BINS)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% xtxcorrmat
%
% Takes two time series state mapping vectors, and creates a
% cross-correlogram of state (array of max states. Assume States are
% square)
%
% Assume that the number of observations in Xt1 and Xt2 are complete. 
%
% Assume xt1 and xt2 are vectors (e.g. 1xN or Nx1)
if isempty(N_BINS) 
    N_BINS = max(max(xt1), max(xt2)); 
end

% --> We'll calculate this by the iterating xt1 and querying xt2

xtcm = zeros(N_BINS); 

for x = 1:N_BINS
    LI_xt1 = (xt1 == x); %logical index; 
    xt2Vals = xt2(LI_xt1); 
    if ~isempty(xt2Vals)
        px = histcounts(xt2Vals, 1:N_BINS+1); 
        xtcm(:,x) = px; 
    end
end
    
N_OBS = length(xt1); 

xtcm = xtcm/N_OBS; 


end



