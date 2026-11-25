function f = envelope_plotter(y, yDelta, x, vars)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% envelope_plotter(y,yDelta,x)
% Use-in-place plotter, to call analogous to plot(x,y). 
% .. >> X and Y should be passed in as column vectors;
%
% - Y is the list of y values (elements)
% - yDelta is the (symmetrical) offset from Y
% - X is the matched position (x) coordinate [indices].

% - Trevor 

arguments
    y double
    yDelta double
    x double = []
    vars.cArr = []; % color Array;  
end

y = y(:); 
yDelta = yDelta(:); 
x = x(:); 

FIT_ALPHA = 0; 
if size(vars.cArr,2) == 4
    FIT_ALPHA = 1; 
end

[N_PTS, N_COMPS] = size(y); 
if isempty(x)
    x0 = 1:N_PTS;
    x = repmat(x0(:), 1, N_COMPS); 
end

if (N_COMPS > 1) && (size(x,2)==1)
    x = repmat(x, 1, N_COMPS); 
end

% Ensure yDelta is the same size as y
if size(yDelta,1) ~= size(y,1)
    warning('y\Delta length mismatch. Truncating or padding with zeros.');
    yDelta = padarray(yDelta(:), abs(length(y) - length(yDelta)), 0, 'post');
    yDelta = yDelta(1:size(y,1));
end

% Compute upper and lower bounds
yUpper = y + yDelta;
yLower = y - yDelta;

% Construct polygon for fill
X = [x; flipud(x)];
Y = [yUpper; flipud(yLower)];

Y(isnan(Y)) = 0; % Flush missing to 0 for area. 

% Create figure if output requested
if nargout > 0
    f = figure;
end

if isempty(vars.cArr)
    vars.cArr = rgb_colorGen(N_COMPS, 'default'); 
end

hold on; 
for cc = 1:N_COMPS
    if FIT_ALPHA
        fill(X(:,cc), Y(:,cc), vars.cArr(cc,1:3), 'EdgeColor', 'none', 'FaceAlpha', vars.cArr(cc,4)); 
    else
        fill(X(:,cc), Y(:,cc), vars.cArr(cc,:), 'EdgeColor', 'none', 'FaceAlpha', 0.4); 
    end
end

% // break this out separately here, so that legend will proc on lines. 
for cc = 1:N_COMPS
    plot(x(:,cc), y(:,cc), 'color', vars.cArr(cc,1:3), 'LineWidth', 2);
end

end
