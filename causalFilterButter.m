function [xOut] = causalFilterButter(x, FBin, fs, butterOrder, fType); 
%Copyright (c) 2026 Trevor S. Smith
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% causalFilterButter
% More robust way to filter signal without worrying about filter artifacts;
% 
% Call the same way that one should normally use filter; 
% 1) bookend signal
% 2) Generate filter coefficients (causal)
% 3) filter signal using butterworth 
% 4) Remove bookended signal ;


xFPLen = min(butterOrder*length(x), fs); 

if ~exist('fType', 'var')
    if length(FBin) == 2
        fType = 'bandpass'; 
    else
        fType = 'high'; 
    end
end

%% 1) 

xBk = [ fliplr(x(1:xFPLen,:)); x; fliplr(x(end-xFPLen+1:end,:))]; 
    
%% 2) 

[b, a] = butter(butterOrder, FBin/(fs/2), fType); 

%% 3) 

fxBk = filter(b,a, xBk); 

%% 4) 

xOut = fxBk(xFPLen+1:end-xFPLen,:); 

end

