
function [DI] = getDispersionIndex(xt)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% getDispersionIndex()
% Simple heuristic for identifying a pulse which has the least
% 'dispersion', by comparing the total integral of the signal vs. the
% integral of the signal weighed by the time. % -->> Effectively the
% standard deviation. 

[N_COMPS, N_XT] = size(xt); 

tVect = 1:N_XT; 

DI = zeros(N_COMPS, 1); 

for c = 1:N_COMPS
    % __ Integral 
    c_sum = sum(abs(xt(c,:))); 
    % __ Mean-time == time @ mean; 
    cs = cumsum(abs(xt(c,:)))/c_sum; 
    t_mn = find(cs>=0.5,1); 
    if ~isempty(t_mn)
    % __ weighted sum of values
    wxt = (t_mn-tVect).^2 .* abs(xt(c,:)); 
    % __ 
    DI(c) = c_sum/sqrt(sum(wxt));
    else
        DI(c) = 0; 
    end
end

% __>> This works, just note that it only really makes sense when the
% tVects are comparable across groups, and there is only 1 expected pulse
1; 

end