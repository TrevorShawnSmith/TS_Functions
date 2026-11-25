function [lvmat] = bslevel(mat, OP_DIM, vars)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% bslevel.m 
%  simple utility to baseline subtract the earliest occurence of a non-nan
%  element in a vector from the vector
% -->> Upgrade to test for mean vs. min of the first N points. 

arguments
    mat
    OP_DIM = 2; 
    vars.nPoints = 100; 
    vars.method {mustBeMember(vars.method, {'mean', 'min'})} =  'mean'; %'first'; 
end

DIM_SZ = size(mat); 

nnIDX = ~isnan(mat); 

[~, LI] = max(nnIDX, [], OP_DIM); 
DIM_SZ2 = size(LI); 

OP_DIM2 = find(DIM_SZ == DIM_SZ2); 

[dim1, dim2] = size(mat); 

xmat = zeros(dim1,dim2); 

if OP_DIM == 1
    switch vars.method
        case 'mean'
        %case 'first'
            for d = 1:dim2
                xt = mat(~isnan(mat(:,d)),d); 
                if isempty(xt)
                    xmat(d,:) = mat(d,:); 
                    continue; 
                end
                xmat(:,d) = mat(:,d) - mean(xt(1:min(dim1, vars.nPoints)), 'omitnan'); 
            end
        %}
        case 'min'
            for d= 1:dim2
                xmat(:,d) = mat(:,d) - min(mat(:,d), [], 'omitnan'); 
            end

    end
    %{
%if OP_DIM2 == 1
   xRows = mat(:,LI); 
    switch vars.method
        case 'first'

        case 'min'
            %xRows = min(mat(:,LI), OP_DIM2); 
    end
    xVals = diag(xRows); 
    xmat = repmat(xVals, 1, DIM_SZ(OP_DIM));
    %} 
else
    %xRows = mat(1:11,LI);
    switch vars.method
        case 'mean'
        %case 'first'
            for d = 1:dim1
                xt = mat(d, ~isnan(mat(d,:))); 
                if isempty(xt)
                    xmat(d,:) = mat(d,:); 
                    continue
                end
                xmat(d,:) = mat(d,:) - mean(xt(1:min(dim1, vars.nPoints)), 'omitnan'); % - xt(1); 
            end
        case 'min'
            for d = 1:dim1
                xmat(d,:) = mat(d,:) - min(mat(d,:), [], 'omitnan'); 
            end
    end
    %{
    xVals = diag(xRows); 
    xmat = repmat(xVals, DIM_SZ(OP_DIM), 1); 
    %}
end

lvmat = xmat; 
%lvmat = mat-xmat; 

end