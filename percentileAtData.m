function [pct] = percentileAtData(xt, v); 
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% percentileAtData
% Short function to calculate the 'percentile' of a given observation,
% given the dataset. Inverse of 'dataAtPercentile'

XT_LEN = length(xt); 
    sxt = sort(xt); 
    ix = find(sxt > v, 1); 
    if isempty(ix); 
        ix = XT_LEN; 
    end
    
    pct = ix/XT_LEN; 
end
