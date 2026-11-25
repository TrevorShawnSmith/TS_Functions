function [covMat] = cosSimCov(xvArr1, xvArr2)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% Cos-sim clustering; 
%// xvArr takes in columwise-vectors
% Simple function to calculate the cosine Simularity between columnwise
% observations; 

arguments
    xvArr1
    xvArr2 = []; 
end

X_COMPS = 0; 
if ~isempty(xvArr2)
    X_COMPS = 1; 
    [y_1, x_1] = size(xvArr1); 
    [y_2, x_2] = size(xvArr2); 
    if y_1 == y_2
        compDim = 2; 
    elseif x_1 == x_2
        compDim = 1; 
    else
        disp("Dimensions Not Compatible for alignment"); 
        return
    end


end

%// Determine the shared and common magnitudes between observations; 

%// First we'll determine the magnitude of each component

colMag = vmag(xvArr1); 

N_COLS = size(xvArr1,2); 

if X_COMPS == 0

    covMat = zeros(N_COLS); 
    
    for c1 = 1:N_COLS
        for c2 = 1:N_COLS
            covMat(c1,c2) = sum(xvArr1(:,c1).*xvArr1(:,c2))/ (colMag(c1)*colMag(c2)); 
        end
    end

else
    % // Cross-Comps

    colMag2 = vmag(xvArr2); 
    if compDim == 2
        numer = xvArr1'*xvArr2;
        denom = colMag'*colMag2; 
    else
        numer = xvArr1*xvArr2'; 
        denom = colMag*colMag2; 
    end
    %numer = dot(xvArr1, xvArr2,compDim); 
    %denom = colMag.*colMag2; 
    % -->> We could select some variant of (t); 
    %
    covMat = numer./denom; 
    %covMat = eye(2)*mean(numer./denom, 'omitmissing'); 
end

end