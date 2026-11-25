function [yt, offset] = threshinterp(xt, THRESH, DIR)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%gapinterp
%// TS Utility to 'interpolate' missing signal from a time series trace
%which passes above/below baseline. Uses a Gaussian smooth for the
%components above Threshold and elements below threshold.
% A differential signal is estimated, then added to the original signal. 
%
% --> Necessary for estimating the range of xt or dxt for a continuous 
% signal when there are truncations/ ranging errors in the raw sig. 
% Our original use case was EMG signal with ringing/ impact artifacts where noise >>> signal amplitude over a short duration. 
%
% THRESH: Value of signal to exceed smooth 'high' or 'low' 
%       if based as a [1x2] double, perform both; 
% DIR: {'high', 'low', 'both'}

% 6.15.2024 - Update for N-D 

[N_XT, XT_LEN] = size(xt); 

offset = zeros(N_XT, XT_LEN); 

yt = xt; 

N_THRESH = length(THRESH); 

if ~exist('DIR', 'var') && N_THRESH == 1
    DIR = 'hi'; 
end

for m = 1:N_XT
    xt0 = xt(m,:); 

    if N_THRESH == 2
        HI_THRESH = max(THRESH); 
        LO_THRESH = min(THRESH); 
    else
        switch DIR
            case {'high', 'hi'}
                HI_THRESH = THRESH; 
                LO_THRESH = min(xt0) - 1; %unseen
            case {'low', 'lo'}
                HI_THRESH = max(xt0) + 1; %unseen
                LO_THRESH = THRESH; 
            case {'both', 'dual'}
                HI_THRESH = abs(THRESH); 
                LO_THRESH = -abs(THRESH); 
        end
    end
        
    %// Estimate step functions; 
    xt_hi = xt0 > HI_THRESH; 
    xt_low = xt0 < LO_THRESH; 
    
    if nnz(xt_hi) == 0 && nnz(xt_low) == 0
        %offset = zeros(size(xt0)); 
        %yt = xt0; 
        %return
        continue; 
    end
    
    
    %// Determine the lengths of hi/low sections
    gap_dura_hi = findDuraDist(xt0, HI_THRESH); 
    gap_dura_lo = findDuraDist(-xt0, -LO_THRESH); %double neg necessary here to thresh 'below'
    
    %// run min here to have 4 STD inside smallest element; 
    MAX_GAP = max([gap_dura_hi gap_dura_lo]); 
    
    kn = getgausskernel(MAX_GAP, round(MAX_GAP/4)); 
    
    NEG_GAUSS = conv(xt_low, kn); 
    POS_GAUSS = conv(xt_hi, kn); 
    
    SM_GAUSS = HI_THRESH*POS_GAUSS - abs(LO_THRESH*NEG_GAUSS); 
    
    offset_xt = SM_GAUSS(MAX_GAP+1:end-MAX_GAP); 
    % ___ 
    offset(m,:) = offset_xt; 
end

yt = xt + offset; 

if nargout == 1
    offset = []; 
end

end