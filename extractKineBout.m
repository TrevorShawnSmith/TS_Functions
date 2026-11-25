function [idx_0, idx_1, sampXY] = extractKineBout(XY, IX0, maxPts, threshVal, FPS)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% extractKineBout (Extract Kinematic Bout) 
% Simple extractor for bouts for the kinematics data; the kinematics data
% assumes XY is paired, within the same coordinate system for running
% magnitude; assumes the data is primarily dominated by low-frequency
% smooth components -- as with kinematics. 
% Assumes that -before- trigger trial, the data is fairly flat. Can fail if
% animal executes multiple low-amplitude oscillations. 
% Threshold of 0.05 is somewhat conservative, but more resiliant against
% hysteresis drift relative to other thresholds (e.g., 0.01). 

%  Trevor. 


arguments
   XY % [nPts, [X trace, Y trace]]; 
   IX0 = 1; 
   maxPts = 60; % max IX + maxPts
   threshVal = 0.05
   FPS = 240; 
end
%


%% 1. smooth Signals (Gaussian sig 100 ms) 

sigma = round(FPS*0.1); 
sXY = smoothdata(XY, 'gaussian', sigma); 

%% 2. Calculate Vector Magnitude (Position)

V = vmag(sXY'); 

%% 3. Calculate Velocity (Magnitude)

adV = abs(diff(V)); % ABS easier to extract +/- smoothing 

%% 4. Calculate Peak/Pos w/in search window

IX00 = max(IX0-maxPts,1); 
IX11 = min(IX0+maxPts,numel(adV)); 

samp_adv = adV(IX00:IX11); 
[pkVal, pkPos] = max(samp_adv); 
pkPos = pkPos+IX00-1; % offset for base. 

%% 5. Calculate Moving Envelope
thMvPt = movmean(adV, sigma); 

%% 6. Calculate Threshold

thVal = pkVal*threshVal; 

%% 7. find X < Thresh; ascending, descending

t0_0 = find(thMvPt(IX00:pkPos)>thVal,1); %ascending
t0 = t0_0+IX00-1; 
t1_1 = find(thMvPt(pkPos:IX11)<thVal,1); %descending
if isempty(t1_1)
    % 1. -- Expand window
    t1_1 = find(thMvPt(pkPos:end)<thVal,1); 
    if isempty(t1_1)
        % 2. -- set max; 
        t1_1 = (IX11-pkPos); 
    end
    disp("Warning: Endpoint not found in region -- setting to maximum range"); 
    %
end
t1 = t1_1+pkPos-1; 

idx_0 = t0; 
idx_1 = t1; 
sampXY = XY(idx_0:idx_1,:); 

% __ Writeout
if nargout == 2 
    sampXY = []; 
end

end