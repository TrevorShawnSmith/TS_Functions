function [mu] = nonnanmean(x, DIM)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% nonnanmean
% Support function added to use cellfunc on data; 

    arguments
        x
        DIM = 1; 
    end

    mu = mean(x,DIM, 'omitnan'); 

end