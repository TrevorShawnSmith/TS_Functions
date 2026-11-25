function [x_int, y_val, pBest] = fitDualLineIntersect(xt, plotOn)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% fitDualLineIntersect
%
% Fits a given time series/ discretely sampled continous object, using a
% pair of intersecting lines to 'sum' to the shape of the input object. 
%
% Only uses elements of each line which compute to a y val > 0
% Note that this needs to go from max--> min val
%
% Requires a slope similar to 1/x, 1/exp(x), or parabolic shape, such that
% the sides of the slopes are sufficently linear. 
%
% Component of the script designed to find a threshold somewhat
% consistently w/ different amplitudes of noisy signal, sorted according to
% absolute amplitude level. 

%-- pBest (Best-fit Parameters)
% - 1) Slope of line fit to high-amplitude vals; 
% - 2) Slope of line fit to low-amplitude vals; 
% - 3) Y-Intercept of line fit to high-amp vals; 
% - 4) Y-Intercept of line fit to low-amp vals;  

% --> We are assuming here that the signal is already properly
% pre-processed to be continous-like.

if ~exist('plotOn', 'var')
    plotOn = 0; 
end

xts = xt; % this was different when we were sorting directly. 

ts = 1:length(xts); 
fun_ls = @(p) sseval_dualLineSeg(p, ts, xts); 
try
    p_0 = [-mean(xts(1:2000))/2000, -mean(xts(end-1999:end))/2000, xts(1), xts(end)]; 
catch
    xts_buffLen = length(xts)/10; 
    p_0 = [-mean(xts(1:xts_buffLen))/xts_buffLen, -mean(xts(end-xts_buffLen+1:end))/xts_buffLen, xts(1), xts(end)]; 
end
    
[pBest, ~, exitF] = fminsearch(fun_ls, p_0); 

% -- Calculate intersect of the two lines
x_int = round( (pBest(4)-pBest(3))/(pBest(1)-pBest(2)) ); 
try
y_val = xts(x_int); 
catch
    exitF = 0; 
end

% ___ CLANDESTINE PLOT FUNCTION __________
if plotOn
    figure; 
    xVal = 1:length(xts); 
    y0_1=xVal*p_0(1)+p_0(3); 
    y0_2=xVal*p_0(2)+p_0(4); 
    y0_1(y0_1<0) = 0; 
    y0_2(y0_2<0) = 0; 
    %
    y1 = xVal*pBest(1)+pBest(3); 
    y2 = xVal*pBest(2)+pBest(4); 
    y1(y1<0) = 0; 
    y2(y2<0) = 0; 
    hold on; 
    plot(xVal, y0_1); 
    plot(xVal, y0_2); 
    %
    plot(xVal, y1); 
    plot(xVal, y2); 
    plot(xVal, y1+y2, 'lineWidth', 2); 
    plot(xVal, xts, '--'); 
    hold off
    xlabel ("Sorted Observations"); 
    ylabel ("Signal Amplitude"); 
    legend({'OrigF1', 'OrigF2', 'FitExp', 'FitLine', 'Y1+Y2', 'Original Line'}); 
end

if exitF == 0
    % -- No good convergence
    1; 
    y_val = std(xts); %best approximation; 
    [~, x_int] = min(abs( xts - y_val));  
end

if nargout == 2
    pBest = []; 
end

end


% -- Auxillary Support Function 
% // Function to minimize
function [sse] = sseval_dualLineSeg(p, xdata, ydata)
m1 = p(1); 
m2 = p(2); 
b1 = p(3); 
b2 = p(4); 
% --- Line 1; 
y1 = m1*xdata+b1; 
y1(y1<0) = 0; %ignore negative elements; 

%w1 = ones(1,length(xdata)); %equal weight high-amp vect
%w1 = log(ydata); 
%w1(w1<0) = 0; 

% --- Line 2; 
y2 = m2*xdata+b2; 
y2(y2<0) = 0; %ignore negative elements; 

%w2 = log(2*[1:length(xdata)]/length(xdata)+1); %extra weight low-amp components on low-amp 

%w2 = ydata.^-1; 

%Sum of Squared Error
sse = sum( (ydata - y1-y2).^2);

%// difference in projections, weighted as above
%sse = sum( (w1.*(ydata - y1) + w2.*(ydata-y2)).^2); 

end