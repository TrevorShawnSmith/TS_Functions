function [m, b] = movLSSlope(sig, N_BIN_PTS, phiDelay) 
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% movLSSlope
% || Moving Least-Squares Slope || 
% 
% UTILITY: 
% Identify the slope and y-intercept of the least-squares line for a time 
% series dataset, calculated within a sliding window. 
% This allows a decomposition of a x(t) signal into dx(t) + b(t)
%
% METHOD:
% Within each window bin, calculate the mean of points in the bin, Xbarr,
% and then calculate the difference between x and Xbarr, over the change of
% Y
%
% PURPOSE: 
% Designed specifically for filtering DC offsets
%
% Based on https://byjus.com/maths/least-square-method/
%
% OUTPUT: 
%   m = moving slope, calculated over the given window
%   b = intercept of the moving slope line


% -- Trevor Smith; 6.6.2022

%08.17.2022 : Upgrade to permit phase delay in bin points for use in
%causal vs. acausal filtering/slope detection

    if ~exist('N_BIN_PTS', 'var') 
        N_BIN_PTS = 1000; %length of bin width to calculate between 
    end
    if ~exist('phiDelay', 'var')
        phiDelay =  0; %offset for center of window bin relative to ti
    end  
    
    bPtH0 = floor((N_BIN_PTS-1)/2); %half-point for bin; 
    bPtH_L = bPtH0+phiDelay; %left (causal) bin point size
    bPtH_R = bPtH0-phiDelay; %right(acausal) bin point size
    
    sigPt = length(sig);              
    ti = bPtH_L+1;      % time index for iterating over all points
    
    m = zeros(size(sig)); 
    b = zeros(size(sig)); 
   
    %% -- initial signal points < bPtH
    %// Use all components between ti and 0
    t0 = 1; 
    while t0 < ti
        xpts_0 = 1:t0+ti; 
        sxpts_0 = sum(xpts_0); 
        x2pts_0 = xpts_0.^2; 
        sx2pts_0 = sum(x2pts_0); 
        n0 = length(xpts_0); 
        ypts_0 = sig(1:t0+ti); 
        xypts_0 = xpts_0.*ypts_0; 
        % --- 
        m(t0) = (sum(xypts_0)-sxpts_0*sum(ypts_0)/n0)/(sx2pts_0-sx2pts_0/n0); 
        b(t0) = (sum(xypts_0)-m(t0)*sx2pts_0)/sxpts_0; 
        %
        t0 = t0+1; 
    end
    
    %% -- Signal Midpoints

    % -- Various squaring and summing operations
    xpts = 1:(bPtH_L+bPtH_R+1); 
    sxpts = sum(xpts); 
    x2pts = xpts.^2; 
    sx2pts = sum(x2pts); 
    n = length(xpts); 
    while ti < (sigPt - bPtH_R)
        %
        ypts = sig(ti-bPtH_L:ti+bPtH_R); 
        xypts = xpts.*ypts; 
        % -- LS fit w/in interval
        m(ti) = (sum(xypts)-sxpts*sum(ypts)/n)/(sx2pts-sx2pts/n); 
        b(ti) = (sum(xypts)-m(ti)*sx2pts)/sxpts; 
        %
        ti = ti+1;
    end
    
    %% -- Terminal signal points > sigPt - binPt 
    t2 = ti; 
    while t2 < sigPt+1
        xpts_2 = 1:sigPt-t2+bPtH_L; 
        sxpts_2 = sum(xpts_2); 
        x2pts_2 = xpts_2.^2;
        sx2pts_2= sum(x2pts_2); 
        n2 = length(xpts_2); 
        ypts_2 = sig(t2-bPtH_L+1:end); 
        xypts_2= xpts_2.*ypts_2; 
        % --- 
        m(t2) = (sum(xypts_2)-sxpts_2*sum(ypts_2)/n2)/(sx2pts_2-sx2pts_2/n2); 
        b(t2) = (sum(xypts_2)-m(t2)*sx2pts_2)/sxpts_2;
        % --- 
        t2 = t2+1; 
    end
    
    % -- if only single arg requested, default to slope
    if nargout == 1
        b = []; 
    end
    
end
