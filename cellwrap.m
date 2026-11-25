function [cArr] = cellwrap(Arr)
%Copyright (c) 2022 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% cellwrap
%
% Simple support function to turn a [NxM] doubles array into a {NxM} cell
% array

dims = size(Arr); 
nDims = length(dims); 
cArr = cell(dims); 
% TODO: There HAS to be some optimization
switch nDims
    case 4
        for x = 1:dims(1)
            for y = 1:dims(2)
                for z = 1:dims(3)
                    for a = 1:dims(4)
                        cArr{x,y,z,a} = Arr(x,y,z,a);
                    end
                end
            end
        end
    case 3
        for x = 1:dims(1)
            for y = 1:dims(2)
                for z = 1:dims(3)    
                    cArr{x,y,z} = Arr(x,y,z);
                end
            end
        end
    case 2
         for x = 1:dims(1)
            for y = 1:dims(2)
                cArr{x,y} = Arr(x,y); 
            end
         end
    case 1
        for x = 1:dims(1)
            cArr{x} = Arr(x); 
        end
end
                


end
