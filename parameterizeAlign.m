function parameterizeAlign(sig1, refSig)
%% parameterizeAlign
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
% Util to slow/speed up one signal (time warp) to match another signal,
% by matching the excursion of the signal (angular displacement) 

% UNFINISHED!

if isempty(refSig)

    N_PTS = length(sig1); 
    gaussCDF = normcdf([-3:6/N_PTS:3], 0, 1); 
    refSig = gaussCDF;
end
    
nPts = 10; 

[xVal_1, xPos_1] = parameterize_trace(sig1, nPts); 


% -- // Gaussian alignment? \\ --



[xVal_0, xPos_0] = parameterize_trace(refSig, nPts); 


xRecon = zeros(size(sig1)); 
xCell = cell(nPts,1); 

for p = 1:nPts
    t0_0 = xPos_0(p); 
    t1_0 = xPos_0(p+1); 
    %
    dp_0 = t1_0-t0_0+1; 
    % __ Obs Distance__
    t0_1 = xPos_1(p); 
    t1_1 = xPos_1(p+1); 
    dp_1 = t1_1-t0_1+1; 
    
    tVect_1 = 1:dp_1; % original "X"; 
    %tVect_1 = t0_1:t1_1; % original "X"
    
    tQuery =  1:dp_1/(dp_0+1):dp_1; % Query "X"
    
    vQ = interp1(tVect_1, sig1(t0_1:t1_1), tQuery); 
    
    %
    %xRecon(t0_0:t1_0) = vQ; 
    xCell{p} = vQ; 
    
    
    1;
    %xPos_0(p); 
    
end

1; 

% __>> Align to gaussian; 
%

%}

end