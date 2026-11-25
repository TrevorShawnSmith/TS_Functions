function [dataPoint] = dataAtPercentile(xt, pct)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% dataAtPercentile
%
%// shorthand macro for establishing a cdf of the observed data, setting up
%the appropriate percentile search, and returning value which is at x% of
%the data amplitude
%
%// Data should be rectified prior to percentile search if absolute
%magnitude of percentile is sought

if pct > 1 
    pct = pct/100; 
end

xts = sort(xt); 

dataPoint = xts(max(round(length(xt)*pct),1)); 

end