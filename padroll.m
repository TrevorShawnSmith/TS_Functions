function xt_out = padroll(xt, N_SHIFT, METHOD)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% padroll
% utility to 'roll' (circle shift) data window; pad edges of data window to dummy
% sig; (Currently, only rolls horizontally); 
% Only functions in 1 or 2 D. 
%
% INPUTS
%   xt - [1,n] row vector or [m,n] array of row vectors. (If array, will
%   shift along dimension 2)
%   N_SHIFT -(1,1) index or (m,1) index of integers to shift. If (m,1),
%       apply the m'th component to the m'th row. 
%   'METHOD'
%   'zero' 
%       -- Zero-pad missing windows (DEFAULT)
%   'endPoint'
%       -- Fill with the endpoint
%   'mean' 
%       -- Fill with the mean of the signal 
%   'taper'
%       -- Fill w/ the linearly-interpolated difference between window
%       endpoints; 


% Trevor Smith

if ~exist('METHOD', 'var')
    METHOD = 'zero'; %
end

N_SHIFT = round(N_SHIFT); 
N_SHIFT = N_SHIFT(:); 


if ~ismatrix(xt)
    disp("WARNING: Not yet supported for 3+ Dimensions"); 
end

[szY, szX] = size(xt); 

if length(N_SHIFT) == 1
    ELEMWISE = 0;
elseif length(N_SHIFT) == szY
    ELEMWISE = 1; 
else
    disp("ERROR (padroll): Input shifts do not match input matrix."); 
    xt_out = xt; 
    return
end
    
DIM = 2; % Rowwise; (For future upgrading)

% __ >> pos shift = rightwards; 

padPts = max(abs(N_SHIFT)); 

switch METHOD
    case 'zero'
        %______ Zero-pad Window_________
        pad0 = zeros(szY, padPts); 
        pad1 = zeros(szY, padPts); 
        1; 
    case {'endPoint', 'endpoint'}
        %_____ Duplicate Endpoint_____
        pad0 = xt(:,1).*ones(szY, padPts); 
        pad1 = xt(:,end).*ones(szY, padPts); 

    case 'reflect'
        pad0 = fliplr(xt(:,1:padPts)); 
        pad1 = fliplr(xt(:,end-ptPts+1)); 
    case {'nan', 'nanpad'}
        pad0 = nan(szY, padPts); 
        pad1 = nan(szY, padPts); 
    case 'mean'
        %_____ Fill w/ sample mean______
        pad0 = mean(xt,2).*ones(szY, padPts); 
        pad1 = mean(xt,2).*ones(szY, padPts); 
       
    case 'taper'
        %___ Fill endpoints using a linear interpolation between endpoints; 
        dx = xt(:,1)-xt(:,end); 
        % __ 2026.10.27 patch; 
        % // calculate per-step dX; integrate over points;
           
        dV = dx/(2*padPts+1); 
        dVA = diag(dV)*ones(szY, 2*padPts); % right edge; 
            
        xVect = cumsum(dVA,2)+xt(:,end); 
        
        pad1 = xVect(:,1:padPts); 
        pad0 = xVect(:,end-padPts+1:end); 

end

buffXt = [pad0, xt, pad1]; 

if ELEMWISE
    xt_2 = buffXt; 
    for r = 1:szY
        xt_2(r,:) = circshift(xt_2(r,:), N_SHIFT(r), DIM); 
    end
else
    xt_2 = circshift(buffXt, N_SHIFT); 
end

xt_out = xt_2(:,padPts+1:end-padPts);        


end