function [xtOut] = xtCutNanPad(xtIn, cutIX)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% xtCutNanPad
% Script to replace intervals of signal w/ Nans. 
% Input requires a {1 x N} cell, containing cut indices, or ranges.

arguments
    xtIn double
    cutIX cell 
end

[N_ROWS, N_OBS] = size(xtIn); 

xtOut = xtIn; 
%xtOut = nan*ones(N_ROWS, N_OBS); 

for r = 1:N_ROWS
    if isempty(cutIX{r})
        continue; 
    end
    xtOut(r,cutIX{r}) = nan; 
end


end