function [xOut, n] = dyadicTrim(xt, METHOD)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% Dydatic trim
%
% // Support function for linking with WaveLab
% __>> Basically, we can only analyze signals of length= 2^n
%   n = number of divisions;

arguments
    xt
    METHOD {mustBeMember(METHOD, {'trim', 'pad'})} = 'trim'; 
end

[nRows, nCols] = size(xt); 


% There's gotta be a better way to do this.... 
ii = 2;
n = 1; 
while ii < nCols
    ii = ii*2; 
    n = n+1; 
end

switch METHOD
    case 'pad'
        xOut = zeros(nRows, ii); 
        xOut(1:nRows, 1:nCols) = xt; 
    case 'trim'
        iii = round(ii/2); 
        xOut = zeros(nRows, iii); 
        xOut(1:nRows, 1:iii) = xt(1:iii); 
end

if nargout == 1
    n = []; 
end


end