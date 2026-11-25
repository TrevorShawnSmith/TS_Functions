function [x_int, y_val, pBest] = fitExponentialLineIntersect(xt, plotOn)
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
%
% Note that this needs to go from max--> min val

% Requires a slope similar to 1/x, 1/exp(x), or parabolic shape, such that
% the sides of the slopes are sufficently linear. 
%
% Component of the script designed to find a threshold somewhat
% consistently w/ different amplitudes of noisy signal, sorted according to
% absolute amplitude level. 
%
%-- pBest (Best-fit Parameters)
% - 1) Slope of line fit to high-amplitude vals; 
% - 2) Slope of line fit to low-amplitude vals; 
% - 3) Y-Intercept of line fit to high-amp vals; 
% - 4) Y-Intercept of line fit to low-amp vals;  

% --> Trash; Hard to get exactly what I want ou of this 

% --> We are assuming here that the signal is already properly
% pre-processed to be continous-like.

if ~exist('plotOn', 'var')
    plotOn = 0; 
end

xts = xt; % this was different when we were sorting directly. 

ts = 1:length(xts); 
fun_ls = @(p) sseval_dualLineSeg(p, ts, xts); 
%p_0 = [-mean(xts(1:2000))/2000, -mean(xts(end-1999:end))/2000, xts(1), xts(end)]; 

nPts = 5000; 


m2 = mean(xts(end-nPts+1:end)); 
%m2 = -mean(xts(end-nPts+1:end))/nPts; 
%b2 = xts(end-nPts/2+1)/ (-mean(xts(end-nPts+1:end))/nPts * (length(xts)-nPts/2+1)); 
b2 = 1; 

p_0 = [mean(xts(1:nPts)), m2, xts(1), b2];  %xts(end)]; 

pBest = fminsearch(fun_ls, p_0); 

% -- Calculate intersect of the two lines
%{
x_int = round( (pBest(4)-pBest(3))/(pBest(1)-pBest(2)) ); 
y_val = xts(x_int); 
%}
% ___ CLANDESTINE PLOT FUNCTION __________
if plotOn == 1
    figure; 
    xVal = 1:length(xts); 
    y1 = pBest(1)*exp(-pBest(3)*xVal) - min(xts); 
    %y1 = xVal*pBest(1)+pBest(3); 
    %y2 = xVal*pBest(2)+pBest(4); 
    y2 = pBest(2)*exp(-pBest(4)*xVal) - min(xts); 
    hold on; 
    plot(xVal, y1); 
    plot(xVal, y2); 
    plot(xVal, y1+y2, 'lineWidth', 2); 
    plot(xVal, xts, '--'); 
    hold off
    title("Line Fits");
    xlabel ("Sorted Observations"); 
    ylabel ("Signal Amplitude"); 
    legend({'FitExp', 'FitLine', 'Y1+Y2', 'Original Line'}); 
end


if nargout == 2
    pBest = []; 
end

end


% -- Auxillary Support Function 
% // Function to minimize
function [sse] = sseval_dualLineSeg(p, xdata, ydata)
m1 = p(1); %Lambda
m2 = p(2); 
b1 = p(3); %sacalar
b2 = p(4); 
% --- Line 1; 
%y1 = m1*xdata+b1; 
y1 = m1*exp(-b1*xdata) - min(ydata); 

y1(y1<0) = 0; %ignore negative elements; 

w1 = (length(xdata):-1:1).^2/length(xdata); 
%w1 = ones(1,length(xdata)); %equal weight high-amp vect
%w1 = log([length(xdata):-1:1]/length(xdata)+1); %weight high-amp components

% --- Line 2; 
%y2 = m2*xdata+b2;
y2 = m2*exp(-b2*xdata) - min(ydata); 

y2(y2<0) = 0; %ignore negative elements; 

w2 = log([1:length(xdata)]/length(xdata)+1); %weight low-amp components on low-amp 



%Sum of Squared Error
%sse = sum( (ydata - y1-y2).^2);

%// difference in projections, weighted as above
sse = sum( (w1.*(ydata - y1) + w2.*(ydata-y2)).^2); 

end