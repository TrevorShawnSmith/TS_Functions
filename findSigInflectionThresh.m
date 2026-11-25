function[xpt, ypt] = findSigInflectionThresh(xt0, steps)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% findSigInflectionThresh
%
% Alternative heuristic to determining the threshold for a signal (xt) than
% a simple STD. Sorts XT by amplitude, to generate a curve. In most
% instances, distribution of amplitude is exponential, with the sorted
% values resembling exponential decay. Rotate this representation -3pi/4
% radians(-135 degrees), such that the min and max values have now been
% rotated to minimum dimensions; the peak of this rotated representation is
% usually the 'inflection' (not technically) of the curve, and often best
% describes the transition between stochastic noise and signal amplitude. 

% Note that this heuristic may fail if there are multiple 'peaks' in the
% rotated representation

if ~exist('steps', 'var')
    steps = 8; 
end

%//xt resembles an exponetial decay, sampled in discrete time if pos;
%sigmoidal if +/-
xt = sort(xt0, 'descend'); 

%//standardize y amplitude to #x points for symmetry
xts  = xt * length(xt)/max(xt); 
%xts  = smoothdata(xts, 'gaussian', 250); 

xpts = 1: length(xt); 

xVal = zeros(1,steps); 
yVal = zeros(1,steps);
jVal = zeros(1,steps);

%'roll' function around, sampling multiple angles
for st = 1:steps
    rad = -st*pi/steps; 
    % -- Rotated Basis Vectors
    i_vec = cos(rad)*xpts-sin(rad)*xts; 
    j_vec = sin(rad)*xpts+cos(rad)*xts; 

    %//minimum of rotated 'amplitude' component = inflection point
    %[~, j_pt] = min(abs(j_vec)); 
    [j_val, pos] = max(j_vec); %find peak
    [i_val] = i_vec(pos);
    %min(abs(j_vec)); 
    
    % -- Back transform to x,y
    xpt = cos(rad)*i_val + sin(rad)*j_val; 
    ypt = -sin(rad)*i_val+ cos(rad)*j_val; 
    
    %
    xVal(st) = xpt; 
    yVal(st) = ypt; 
    jVal(st) = j_val;
    
end

[~, rollIDX] = min(jVal); 
%[~, rollIDX] = max(yVal); %furthest from distance == best 

xpt = round(xVal(rollIDX)); 
ypt = xt(xpt); 


%{
% fit a line from max pt -- to min pt; take difference of integrals ==
% shape of the difference between them

%{
y0 = xts(1);
y1 = xts(end); 
x0 = xpts(1); 
x1 = xpts(end);
%}

%// slope of line defined between min and max; 
m =(y1 - y0)/(x1-x0); 

b = -(m*x0-y0); 



lineInt = cumsum( m*xpts+b); 
curveInt= cumsum( xts); 

%sc = lineInt(end)-curveInt(end); 

netCurve = lineInt-(curveInt); 

figure;plot(netCurve); 
%}

if nargout == 1; 
   ypt = []; 
end

end