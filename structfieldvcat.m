function catArr = structfieldvcat(S, sField, sIndex, rIndex)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% structfieldvcat
% general macro to quickly extract data from a given (1xN) structure, from
% a particular field ([MxP] doubles arr), provided N and M.  (Designed
% specifically for the boutStruct data Structure). 
%
% Expected output is an ARRAY (M*N x P)
%
% if more than 1 rIndex is supported, order arrays r1-S1, r2-S1, r1-S2, ...
%
% --> Maybe just incorporate a toggle for different methods, if they become
% useful? 

arguments
    S struct
    sField {mustBeTextScalar} = []; 
    sIndex {mustBeInteger} = []; %row index
    rIndex {mustBeInteger} = []; %subfield index
end

%// If performing vertcat, implicit assumption that the numCols of doubles
%array are consistent; 

%if ~exist(
%if ~exist('sIndex', 'var')
if isempty(sIndex)
    sIndex = 1:length(S); 
end

%{
if isempty(sIndex)
    catArr = []; 
    return
end
%}

subStruct = {S(sIndex).(sField)}; 

if isempty(rIndex)
%if ~exist('rIndex', 'var')
    [rIndex, nCols] = size(subStruct{1,1}); 
else
    nCols = size(subStruct{1,1},2); 
    %catArr = []; 
    %return
end

N_SUBROWS       = length(rIndex); 

subFlat = cellhcat(subStruct); 
subArr = subFlat(rIndex,:); 

subCell = cell(N_SUBROWS,1); 
for ri = 1:N_SUBROWS
    subCell{ri} = reshape(subArr(ri,:), nCols, [])'; 
end

if N_SUBROWS == 1
    catArr = subCell{1}; 
else
    catArr = subCell; 
end

end
