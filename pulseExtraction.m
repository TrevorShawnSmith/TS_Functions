function [ht] = pulseExtraction(xt, yt, yThresh)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% pulse Extraction
%
% Given a step-up/step-down signal xt and an observed response [yt], estimate
% the value of h(t), the step/impulse response, which is assumed homogeneous
%
% dx/dt of a step-up step-down = +/- impulse; 
%
% A better method should exist, but the matrix factorization approach does
% not converge on a unique solution. 
%
% Works fairly well when the pulses can be described from an LTI origin; a
% better description and algorithm should exist. Estimates a pulse using a
% positive waveform. 
%
% --> Alternative to the direct z transform
%
% Somewhat uncharacterized usage
%
% INPUTS: 
%   xt = Signal Input
%   yt = Signal Output 

if ~exist('yThresh', 'var')
    yThresh =  0; 
end

%// Find stim start/stop; 
[~, xi_last] = find(diff(xt)< 0, 1); %stp off; 
[~, xi_first] = find(diff(xt)> 0, 1); %Step On; 

%// Calculate stim dura
stimDura = xi_last-xi_first; 

%// time index of measured response; 
[~, yi_first]   = find(yt > yThresh,1); 
[~, yi_last]    = find(yt > yThresh, 1, 'last');  

%// time delay between stimulus onset and response onset
yDelay     = yi_first - xi_first; 
%// total possible FIR
FIR_LEN = length(xi_first:yi_last); 

%// window sig over entire detected possible range;  
wyt = yt(xi_first:yi_last); 

%// signal differential
wdydt = diff([0, wyt]); 


offTime    = FIR_LEN-stimDura+1; %expected startpoint of -u[n}*h{n]; 

firArr = zeros(2,FIR_LEN); 
onDura = yDelay+stimDura;  

%// If we assume the system is causal (LTI), we can extract the the on-only
%and off-only component from dy/dt in the region between dx/dt; 

yt_on   = wdydt(1:onDura);      %expected ONLY +u[n]
yt_off  = wdydt(offTime:end);   %expected ONLY - u[n]

firArr(1,1:onDura)      = yt_on; 
firArr(2,offTime:end)   = yt_off; 

%// Here we ASSUME that the on/off components of dx/dt are equal and
%opposite: The time and shape of the off of the 'step-off' is opposite the
%known, 'step off' off, at the same relative delay; and vice-versa w/
%on-stim. 

t_u_neg_on = stimDura+1:onDura+stimDura ; % when -u[n] is expected to start + duration of yt_on
t_u_pos_off= offTime-stimDura:offTime-1; %when u[n] is expected to come 'off' + duration of yt_off; 

%  --> We need to truncate in some case; 
t_u_neg_on  = t_u_neg_on(t_u_neg_on <= FIR_LEN); 
t_u_pos_off = t_u_pos_off(t_u_pos_off >= 1); 

un_1_len = length(t_u_neg_on); 
up_0_len = length(t_u_pos_off); 

firArr(2,t_u_neg_on) = -yt_on(1:un_1_len); %-u[n] expected 'on' phase 
firArr(1,t_u_pos_off)= -yt_off(end-up_0_len+1:end); %u[n] expected 'off' phase

%// Assign overlapping regions as subtraction; 
if onDura < 1
    t_u_pos_midpts = 1:t_u_pos_off(1)-1; 
else
    t_u_pos_midpts = onDura+1:t_u_pos_off(1)-1; 
end
    
    
t_u_neg_midpts  = t_u_neg_on(end)+1:offTime-1; 

firArr(1,t_u_pos_midpts) = wdydt(t_u_pos_midpts)-firArr(2, t_u_pos_midpts); 
firArr(2,t_u_neg_midpts) = wdydt(t_u_neg_midpts)-firArr(1, t_u_neg_midpts); 

% __ Let's just assign fit errors here to same-sign; 

firSum = sum(firArr); %// A+B = h[n]*u[n]-h[n]*u[n+T]; 

%// mismatch between observed and expected
yt_err = wdydt - firSum; 

%// We'll set postive error to pos elements; negative error to negative
%elements ....

LI_pos = find(yt_err > 0); 
LI_neg = find(yt_err < 0); 

LI_pos2 = ismember(LI_pos, (stimDura:offTime) ); 
LI_neg2 = ismember(LI_neg, (stimDura:offTime) ); 

LI_pos = LI_pos(LI_pos2); 
LI_neg = LI_neg(LI_neg2); 

firArr(1,LI_pos) = firArr(1,LI_pos)+yt_err(LI_pos); %pos phase; 

firArr(2,LI_neg) = firArr(2,LI_neg)+yt_err(LI_neg); %neg phase; 

a = firArr(1,:); 
b = firArr(2,:); 

%// average ON and OFF responses;
ht = (a-(circshift(b, -stimDura)))/2; 

end


%// Whole bunch of old methods; 
%{

%// time index for missing point; 
ti = 1*iDura+TAU+1; 
while ti < T_END; 
    at0 = a(ti); %unknown; 
    bt0 = b(ti); %known;
    ats = a(ti+iDura); %known; 
    bts = b(ti+iDura); %unknown; 
    cts = c(ti+iDura); 
    ct0 = c(ti); 
    
    ab = at0+bt0;
    cc = ct0-ab; 
    
    if abs(cc) > 0; 
        1; 
    end    
    
    
    if at0 == 0
        at_f = at0+(ct0-bt0); 
        bt_f = bt0; 
        
    elseif bt0 == 0
        %bt0_0 = ct0-at0; 
        %bt0_1 = cts-bts; 
        at_f = at0;
        bt_f = bt0+(ct0-at0); 
        
    end
     
    ab = at_f+bt_f;
    cc = ct0-ab; 
    
    if abs(cc) > 0; 
        1; 
    end
    
    
    a(ti) = at_f; 
    b(ti) = bt_f; 
    
    ti = ti+1; 
end

1; 



c-a; 



%firArr(1, TAU+1:TAU+iDura)  = stepOn_Sig; 
%firArr(2, end-iDura+1:end)  = stepOff_Sig;  



%// We can iteratively project these pulses forward because we ASSUME they
%are equal and opposite, segregated by a distance of iDura

% --> or we can just direct set; 

%// set forward component. 
%firArr(2,TAU+iDura+1:TAU+2*iDura) = -firArr(1,1:TAU+iDura); 

%// set negative component. 
%firArr(1,end-2*iDura-TAU:end-iDura-TAU) = - firArr(2, end-iDura:end); 


%
for t0 = 1:T_OFFSET
    %// forward project positive component
    a = firArr(1,t0); 
    b = -a; 
    b0 = firArr(2,t0+iDura); 
    firArr(2,t0+iDura) = b0+b; 
end
%
%{
Bt = firArr(2,T_OFFSET+1:T_OFFSET+iDura); 

firArr(2,T_OFFSET+1:T_OFFSET+iDura) = Bt + -firArr(TAU+1:T_OFFSET); 
%}
%{
for t0 = FIR_LEN:-1:FIR_LEN-iDura
    %// reverse index; 
    b = firArr(2,t0); 
    a = -b; 
    a0 = firArr(1,t0-iDura-1); 
    firArr(1,t0-iDura-1) = a+a0; 
    %firArr(1,t0-iDura) = a; 
end
%}
At = firArr(1,T_END-iDura+1:T_END); 
firArr(1,T_END-iDura+1:T_END) = At + -firArr(2,T_END:end); 


a = firArr(1,:); 
b = firArr(2,:); 

%// Range 1
%// Unknown time points for A (onset); 
t0 = T_OFFSET+1; 
t1 = T_OFFSET+iDura; 

nPts = t1-t0; 

b_offset = sign(b(t0))*min(abs(b(t0:t1))); %// to avoid discontinuities. 
a_v_offset = b_offset*(1:-1/(nPts):0); 
a_exp = c(t0:t1)-(b(t0:t1)-b_offset); 

a_exp_v = a_exp + a_v_offset; 

firArr(1,t0:t1) = a_exp; 

%// repeat w/ Range 2; 
t0 = 2*iDura+TAU+1; 
t1 = FIR_LEN-iDura-1; 
%t1 = 3*iDura+TAU; 

nPts = t1-t0; 
a_vals = a(t0:t1); 

b_exp = c(t0:t1)-a(t0:t1); 

%a_offset = sign(a(t0))*min(abs(a(t0:t1)));
%b_v_offset = a_offset*(1:-1/(nPts):0); 
%b_exp = c(t0:t1)-(a(t0:t1)-a_offset); 

firArr(2,t0:t1) = b_exp; 


firNet  = sum(firArr); %A+B; 
%expA    = wdydt-firNet-firArr(2,:); 

ht = mean([firArr(1,:); -1*circshift(firArr(2,:), -iDura)]);  



for t0 = T_OFFSET+1:FIR_LEN-T_OFFSET
    %// forward index the known components of a onto b;  
    a0 = firArr(1,t0); 
    b0 = firArr(2,t0); 
    c0 = wdydt(t0); 
    
    est = c0-b0; 
    
    % ___ Reverse index this as as well; 
    
    
    if est < 0
        1; 
        %est = -est; 
        
    end
    %t0 = t0+1;
    
    
    firArr(1,t0) = est; 
    firArr(2,t0+iDura) = -est; 
    
    % --> Perhaps this should be the average of the double projected
    % regions ...? 
    
    
    %{
    %// t0 will index forward in time from last known over all unknown; 
    a = firArr(1,t0); 
    %a0 = firArr(1,t0); 
    b = firArr(2,t0); 
    ab = a+b; 
    c = wdydt(t0); 
    %if abs(a)+abs(b) < c
    a0 =a ; 
    b0 = b; 
    a1 = firArr(1,t0-iDura); 
    b1 = firArr(2,t0+iDura); 
    if a+b ~= c
        if a == 0 
            a0 = c-b;
            b1 = -a0; 
        elseif b == 0
            b0 = c-a; 
            a1 = -b0; 
        else
            %// imperfect fit; 
            % --> average distance between expected/observed; 
            alp = abs(c/(a+b)); 
            a0 = alp*a; 
            b0 = alp*b; 
        end
    end
    firArr(1,t0) = a0; 
    firArr(2,t0) = b0;
    
    %// sweep forward/backward
    firArr(2,t0+iDura) = b1; 
    firArr(1,t0-iDura) = a1; 
    %}
end
            




N_STD = 10; 
%// windowing parts; 
%w0i = iStart-4*std_len; 
%w1i = iStart+4*std_len; 
w0i = yi_peak-N_STD*std_len; % min thresh --> above
w1i = yi_peak+N_STD*std_len; % min thresh --> below; 

hMaxLen = (w1i-yi_peak); %maximum FIR after peak 

firLen = tau_est+(w1i-w0i); 

%// estimate length of FIR; 
%tau_est = yi_peak - xi_last; 


wt = sig(w0i-tau_est:w1i); 

% --> We can interpret the derivative of the input from the derivative of
% the output; The differential of the step-up + step down function is a
% positive and negative weighted impulse 



%// estimate intial as differential of total signal; 
dwdt = [0, diff( wt) ]/iDura; 

outArr = zeros(iDura, firLen); 
for ii = 1:iDura %// for every dirac
    outArr(ii,ii) = 1; 
    hi = conv(outArr(ii,:), dwdt); 
    hi_2 = hi(1:firLen); % // here we assume response is causal; 
    outArr(ii,:) = hi_2; 
end

figure; 
plot(sig); 
hold on; 

sPos = ceil(length(dwdt)/2); 

xx = conv(ctrl, dwdt); 
x2 = xx(sPos-tau_est:end-sPos+1); 

plot(cumsum(x2)); 


%txy = tfestimate(ctrl, sig); 

%}