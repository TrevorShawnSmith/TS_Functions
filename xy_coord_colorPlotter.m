function xy_coord_colorPlotter(dat)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% Integer VAF- VAF Plotter
% Sort of ad-hoc code; 
%
% Given a list of 2 integer lists, 
% Treate them as coordinates, and populate a heat map
%
% Assume we have a variable dat as a (N_OBS, 2) list


maxVal = max(dat, [], 'all'); 

pXY = zeros(maxVal); 

for r = 1:length(dat) % for each row; 
    x = dat(r,1); 
    y = dat(r,2); 
    pXY(y,x) = pXY(y,x)+1; 
end

figure; 
pcolor(pXY);
%imagesc(pXY); 
axis xy
line([0,maxVal+1], [0, maxVal+1], 'lineStyle', '--', 'color', 'white', 'lineWidth', 2);
xticks([1.5:1:maxVal-0.5]); 
yticks([1.5:1:maxVal-0.5]); 
xticklabels(1:maxVal); 
yticklabels(1:maxVal); 
end
