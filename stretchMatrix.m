function outMat = stretchMatrix(mat, newDim, method)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% 'stretch' matrix
%
% Here, we take an input matrix, and 'stretch' it by another set of
% dimensions; could either linearly interpolate or binary fit. This is
% effectively a wrapper for existing interp methods; 
%
% This is only going to make sense in 2D space

arguments
    mat
    newDim = size(mat); 
    method {mustBeMember(method, {'linear', 'nearest'})} = 'nearest'; 
end

matDim = size(mat); 

if length(matDim) > 2
    disp("stretchMatrix is currently only enabled for 2D"); 
end

yStretch = newDim(1)/matDim(1); 
xStretch = newDim(2)/matDim(2); 

% stretch cols, then stretch rows; 
outxMat = zeros(matDim(1), newDim(2)); 


xRef = zeros(1, matDim(1)*matDim(2)); 
xQuery = zeros(1, newDim(1)*newDim(2)); 

%{
for ii = 1:matDim(2); 
    t0 = 1+(ii-1)*matDim(1); 
    xRef(t0:t0+matDim(1)-1) =   ii*(1:matDim(2)); 
end

for ii = 1:newDim(2)
    t0 = 1+(ii-1)*newDim(1); 
    xQuery(t0:t0+newDim(1)-1) = ii*(1:newDim(1)); 
end
%}

%xRef = repmat()
%yRef = repmat(1:matDim(1), 1, matDim(2)); 
%yQuery = repmat(1:newDim(1), 1, newDim(2)); 

[xRef, yRef] = meshgrid(1:matDim(2), 1:matDim(1)); 

dy = (matDim(1)-1)/(newDim(1)-1); 
if isnan(dy)
    dy = 0; 
end

dx = (matDim(2)-1)/(newDim(2)-1); 

xVect = 1:dx:matDim(2);
yVect = 1:dy:matDim(1); 

[xQuery, yQuery] = meshgrid(xVect, yVect); 

outMat = interp2(xRef, yRef, mat, xQuery, yQuery, method);  
  

% __ Posthoc corrections


1; 
%{
switch method 
    case 'linear'
        %// linearly interpolate pts: 
        for row = 1:matDim(1); 
            y = 1:matDim(2); 
            xnew = interp1(y, mat(y,:), 1 )

%}


%outMat = zeros(newDim); 



end