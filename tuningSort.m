function [outArr, IX] = tuningSort(datArr, vars)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% tuningSort (TS_Functions)
%
% Sort row vectors in an array by various methods; May be useful for
% sorting spike rates. 
%
% INPUTS: 
%   datArr = [N_OBS, N_XT] array of points. Rows will be sorted; 
% NAME-VALUE PAIRS:
%   'method' (Default = 'phase')
%       - peak:     Find peak value in each row; sort
%       - centroid: Find the center-of-mass of each row; sort 
%       - phase:    Perform across the population; assign a phase
%           relationship between pc1/pc2; atan2(pc1,pc2); sort according to
%           ascending phase; 
%       - none:     No sort. Used for homogeneity when integrating code
%           into other pipelines. 
%   'order'
%       - 'ascend' (default)
%       - 'descend' 
% OUTPUTS
%   outArr  - Sorted array [N_OBS, N_XT]; 
%   IX      - Row sorting index; outArr = datArr(IX); 

% Trevor Smith, 2025

arguments
    datArr
    vars.method {mustBeMember(vars.method, {'none', 'peak', 'centroid', 'phase'})} = 'phase';
    vars.order {mustBeMember(vars.order, {'ascend', 'descend'})} = 'ascend'; 
end

rateCodes = datArr; 

switch vars.method
    case 'none'
        % Only added for homogenity
        IX = 1:height(datArr); 
    case 'phase'
        % Perform PCA
        [~, score, ~] = pca(rateCodes);
        %[coeff, score, ~] = pca(rateCodes);

        % PC1 and PC2 activations for each row
        pc1 = score(:, 1);
        pc2 = score(:, 2);

        % Calculate relative phase positions using PC1/PC2 activations
        phases = atan2(pc2, pc1); % Compute phase angles

        % Align spike trains based on phase
        %[~, sortedIndices] = sort(phases); % Sort by phase
        %[~, IX] = sort(phases); 
        [~, IX] = sort(phases, vars.order); 
        %sortedRateCodes = rateCodes(sortedIndices, :);
        %outArr = rateCodes(IX,:); 
        1; 
        
        % Display results
        %{
        disp('Original Matrix:');
        disp(rateCodes);
        disp('Sorted by PC1/PC2 Phases:');
        disp(sortedRateCodes);
        %}

        % Optionally: Visualize PCA results
        %{
        figure;
        scatter(pc1, pc2, 50, 'filled');
        hold on;
        for i = 1:length(pc1)
            text(pc1(i), pc2(i), num2str(sortedIndices(i)), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
        end
        xlabel('PC1 Activation');
        ylabel('PC2 Activation');
        title('PCA Alignment by PC1/PC2');
        grid on;
        %}
        
    case 'centroid'  
        cArr = cumsum(abs(datArr'))';

        scArr = diag(1./cArr(:,end)); 
        scArr(isnan(scArr)) = 0; 
        scArr(isinf(scArr)) = 1; 
        zMat = scArr*cArr; 
        pcV = sum(zMat, 2);
        %[~, IX] = sort(pkV, 'descend');
        [~, IX] = sort(pcV, vars.order); 
        %
    case 'peak'
        %datArr = datArr.^2; 
        [~, pos] = max(datArr, [], 2); 
        %[~, IX] = sort(pos, 'ascend'); 
        [~, IX] = sort(pos, vars.order); 
end

outArr = datArr(IX,:);
if nargout == 1 
    IX = []; 
end

end