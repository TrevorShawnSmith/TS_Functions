function [nxc,lags] = normXCorr(xt, wvlt, varargin)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% normXCorr()
%
% Cross-correlation of two signal sequences, but compensate for differences
% in scaling of the xcorr due to padding zeros at the ends of sequences,
% and normalize by wavelet energy^2 and sequence energy^2; 

% Otherwise xcorr could cause issues when xt is close to the size of wvlt

% - TS 4.1.2022

if isempty(varargin); 
    method = 'average';
else
    method = varargin{1};
end
if ~exist('wvlt', 'var') 
    %// autocorrelation; 
    wvlt = xt; 
end


[xc, lags] = xcorr(xt, wvlt); 

%// normalize by power of wavelet as available for overlap at that point
switch method
    case 'energy'
        %compensate for differences in observations and packet energy; 
        wvlt2 = wvlt.^2; 
        normXT = [cumsum(flip(wvlt2(1:end))) sum(wvlt2)*ones(1, 2*(length(xt)-length(wvlt))) flip(cumsum(wvlt2(1:end-1)))];
    case 'average'
        %// compensate for differences in observations
        normXT = xcorr(ones(size(xt)), ones(size(wvlt))); 
        
    case 'variance'
        %// Note this is variance of XT, not of the wavelet
        xt_var = movvar(xt, length(wvlt)); 
        normXT = [flip(xt_var(1:end)) xt_var(2:end)]; 
end
nxc = xc./normXT;

if nargout == 1
    lags = []; 
end

end