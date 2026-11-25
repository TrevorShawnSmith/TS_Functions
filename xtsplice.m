function [xtOut, offset] = xtsplice( xt1, xt2, vars)%OFFSET)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% xtsplice
%
% Uses 'xcorr' between two observations of the same signal; Identifies the
% overlap between the two as the normalized peak of the xcorr overlap; 
% Provides the lag, then averages the two down across observations
%
% -->> Assumes that xt1 and xt2 are non-oscillatory over the sampled
% interval

% if xt1 and xt2 are arrays, rather than vectors, then these must be the
% same size. 

% --> If OFFSET is passed as a variable, then apply a known offset to two
% samples. 

% __ >> May require a future patch if different-sized samples are
% interferring with the detection of which is phasic. 

% TS
arguments
   xt1 
   xt2 = []; 
   vars.offset = []; 
end

OFFSET = vars.offset; 

%// extract cell 
if isa(xt1, 'cell') && isempty(xt2) %~exist('xt2', 'var')
    xt2 = xt1{2}; 
    xt1 = xt1{1}; 
end
if isempty(OFFSET) 
    CALC_OFFSET = 1; 
else
    CALC_OFFSET = 0; 
end

%____ 
[sz_x1, sz_y1] = size(xt1); 
[sz_x2, sz_y2] = size(xt2); 
%_____
if (sz_x1 == 1) || (sz_y1 == 1)
    len_1 = max(sz_x1, sz_y1); 
else
    MULTICOMP = 1; 
    len_1 = sz_y1; 
end
if (sz_x2 == 1) || (sz_y2 == 1)
    len_2 = max(sz_x2, sz_y2); 
else
    MULTICOMP = 1; 
    len_2 = sz_y2; 
end

N_DIMS = size(xt1,1); 

if MULTICOMP
    if ~( (sz_x1 == sz_x2) )%&& (sz_y1 == sz_y2) )
        disp(" X(t) Arrays dimensions are not compatible for xtsplice."); 
        return
    end
end
%______

N_ROWS = sz_x1; 

if CALC_OFFSET
    raw_xc = cell(N_ROWS, 1); 
    
    pk  = zeros(N_ROWS,1); 
    %pos = zeros(N_ROWS,1); 
    offset = zeros(N_ROWS,1); 
    
    for row = 1:N_ROWS
        raw_xc{row} = xcorr(xt1(row,:), xt2(row,:)); 
        
        xtBuffLen = min(len_1, len_2); 
        
        % __ Normalize XCorr by degree of overlap
        denom = xtBuffLen*ones(size(raw_xc{row}));
        denom(1:xtBuffLen) = 1:xtBuffLen; 
        denom(end-xtBuffLen+1:end) = xtBuffLen:-1:1; 
        
        nXc = raw_xc{row}./denom; 
        
        [~, pk(row)] = max(nXc); 
    
        offset(row) = len_1 - pk(row); 
    end
    
    chOffset = median(offset); 

else
    chOffset = OFFSET; 
end

if mod(chOffset, 1) > 0
    %// round ties; 
    chOffset = round(chOffset); 
end


if chOffset  <= 0
    LEAD_X = 1; 
    xtOutLen = max(len_1, len_2 -chOffset ); 
else
    LEAD_X = 2; 
    xtOutLen = max(len_2, len_1 - chOffset ); 
end

xtOutBuff = nan*ones(2, N_DIMS, xtOutLen); 

%
if LEAD_X == 1
    xtOutBuff(1,:,1:len_1) = xt1; 
    xtOutBuff(2,:,-chOffset +1:-chOffset +len_2) = xt2; 
else
    xtOutBuff(1,:,1:len_2) = xt2; 
    xtOutBuff(2,:,chOffset +1:chOffset +len_1) = xt1;
end

% --> Average down; 
xtOut = squeeze(mean(xtOutBuff, 1, 'omitnan')); 


if nargout == 1
   offset = []; 
else
    offset = chOffset ; 
end


end