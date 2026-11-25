function classDataOut = merge_classdata(classData1, classData2)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% merge_classData
% Shortcut for combining classData structures. 
% If two structures have a different size, align the common elements to the
% top left corner. 
%
% 'classData' is a {N_CHANNELS x N_CLASSES} cells containing [N_OBS,
% XT_LEN] observations in a doubles array

[y1,x1] = size(classData1); 
[y2,x2] = size(classData2); 

y = max(y1,y2); 
x = max(x1,x2); 

dat1 = cell(y,x); 
dat1(1:y1,1:x1) = classData1; 

dat2 = cell(y,x); 
dat2(1:y2,1:x2) = classData2; 

classDataOut = cell(y,x); 

for yi = 1:y
    for xi = 1:x
        if ~isempty(dat1{yi,xi}) && ~isempty(dat2{yi,xi})
            classDataOut{yi,xi} = cellvcat({dat1{yi,xi}; dat2{yi,xi}});
        elseif ~isempty(dat1{yi,xi})
            classDataOut{yi,xi} = dat1{yi,xi}; 
        elseif ~isempty(dat2{yi,xi})
            classDataOut{yi,xi} = dat2{yi,xi}; 
        else
            classDataOut{yi,xi} = {}; 
        end
    end
end


end