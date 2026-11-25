function [smTmpArr] = interpxttemplate(tmpArr, refPoints, queryRange, varargin)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% interpXtTemplate
%
%// general function to 'interpolate' a given-length signal, sampled at 
%known time points, at alternative time points, assuming the change in
%signal amplitude is linear over those time points; 
% // Used to keep track and account for a dynamic template;
%
% Note that this method is highly dependent on the order of the supplied
% signal, and that discontinuities in response will massively affect the
% assumed-linear/continous response

% tmpArr = [nObservations x N_DATA_POINTS] arr


p = inputParser;
addOptional(p, 'method', 'linear'); %'linear'/'step';
parse(p, varargin{:}); 
pR = p.Results; 
METHOD = pR.method; 


if ~exist('queryRange', 'var')
    queryRange = 1:max(refPoints); 
end

[N_OBS, N_PTS] = size(tmpArr);

%// for now, let's assume that the template array is a [N_OBS x XT]
%template array; positioned by 'RefPoints'

% --> If we cast outside of the query point location, we need to assign to
% closest, as we have no knowledge of endpoints; 

if max(queryRange) > max(refPoints) 
   %// need to dummy outside elements (assume no-change) to descending-ordered template array; 
   tmpArr(end+1,:) = tmpArr(end,:); 
   refPoints(end+1) = max(queryRange); 
   N_OBS = N_OBS+1; 
end

if min(queryRange) < min(refPoints)
    %// need to dummy outside elements, assuming no-change; 
    buffArr = zeros(N_OBS+1, N_PTS); 
    buffPoints = zeros(N_OBS+1, 1); 
    buffArr(2:end,:) = tmpArr; 
    buffPoints(2:end) = refPoints; 
    buffArr(1,:) = tmpArr(1,:); 
    buffPoints(1) = queryRange(1); 
    tmpArr = buffArr; 
    refPoints = buffPoints; 
end

tmpArr(isnan(tmpArr)) = 0; 

if ndims(tmpArr) > 2
    tmpArr0 = squeeze(tmpArr); 
    [sz_Y, sz_X] = size(tmpArr0); 
    if (sz_Y == N_PTS) && (sz_X == N_OBS) && ~(sz_Y == sz_X)
        tmpArr = tmpArr0'; 
    else
        tmpArr = tmpArr0; 
    end
end

switch METHOD
    case 'linear'
        %// This uses linear interpolation between points; 
        [Xi,Yi] = meshgrid(1:N_PTS,refPoints); 
        [Xq,Yq] = meshgrid(1:N_PTS,queryRange); 
        try 
            smTmpArr = interp2(Xi, Yi, tmpArr, Xq, Yq); 
        catch
            smTmpArr = interp2(Xi', Yi', tmpArr, Xq', Yq'); 
        end
    case 'step'
        %// repeat prior values until a new update is provided; (from
        %below)
        nQueries = length(queryRange); 
        smTmpArr = zeros(nQueries, N_PTS); 
        
        for qi = 1:nQueries
            qq = queryRange(qi); 
            [~, ri] = max(refPoints(refPoints <= qq)); 
            smTmpArr(qi,:) = tmpArr(ri,:); 
        end
end
        
%{
dt = diff(RefPoints); 


testArr = zeros(4000, 120); 
xi = 1;

for ss = 1:4000
    testArr(ss,:) = interp1(RefPoints, tmpArr(ss,:), QueryPoints); 
end


%{
for nn = 1:120; 
    if any(ismember(nn, RefPoints)); 
        testArr(:,nn) = tmpArr(:,xi); 
        xi = xi + 1; 
    end
end
%}




%// parameterized smooth change in points
dxdt = dxRP./repmat(dt, N_PTS, 1);  


dtArr = []; 
repArr = []; 
for nn = 1:N_OBS
    tt = dt(nn); 
    dtArr = [dtArr kron(1:tt', dxdt(:,nn))]; 
    repArr = [repArr kron(1:tt', dxdt(:,nn))]; 
    %dtArr = [dtArr kron(dxdt(:,nn), 1:tt')]; 
    %repArr = [repArr kron(tmpArr(:,nn), 1:tt')]; 
end

%}
1; 

end

