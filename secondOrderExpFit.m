function [Pars_2d] = secondOrderExpFit(x_obs, y_obs, plotOn)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% 2nd-Order Exponential EQ Fitting
%{
Find the optimal parameters to an equation of the form

Y(t) = Y0 + alpha*exp(x*L1) + beta*exp(x*L2); 

Using the input observations of data. Fit equations by minimizing the RMS
error. 

Based off Star Strider's Matlab Exponential Curve-fitting answer: 
https://www.mathworks.com/matlabcentral/answers/429956-how-can-i-fit-an-exponential-curve?s_tid=ta_ans_results

%} 

%// Observed values to fit; 

%{
y_obs = sdoMag'; 
x_obs = postspk_intervals; 
%}
arguments 
    x_obs = []; 
    y_obs = []; 
    plotOn = 0; 
end


y0 = y_obs(1);


%// represent 2nd order decay function as a fundametal object; 
%fcn = @(par,x_obs) (y0 + par(1).*exp(par(2).*x_obs) + par(3).*exp(par(4).*x_obs));
fcn_2d = @(par,x_obs) (par(1) + par(2).*exp(par(3).*x_obs) + par(4).*exp(par(5).*x_obs) );%+ par(5).*exp(par(6).*x_obs));
%fcn = @(par,x_obs) (par(1) + par(2).*exp(par(3).*x_obs) + par(4).*exp(par(5).*x_obs) + par(5).*exp(par(6).*x_obs));
fcn_1d = @(par,x_obs) (par(1) + par(2).*exp(par(3).*x_obs)); 

%fcn_2d0 = @(par,x_obs) (par(1).*exp(par(2).*x_obs) + par(3).*exp(par(4).*x_obs) );%+ par(5).*exp(par(6).*x_obs));

%// Minimize variance between observed/predicted (cumsum to penalize
%initial (higher) values more)
%[Pars, fval, result] = fminsearch(@(par) sum(var(vertcat(y_obs, fcn(par,x_obs)))), [0.1, -0.5, 0.1, -0.5]); 
%[Pars, fval, result] = fminsearch(@(par) sum(cumsum((var(vertcat(y_obs, fcn(par,x_obs)))))), [y0, 0.1, -0.5, 0.1, -0.5, ]); %0.1, -0.5]); 
%[Pars_2d, fval, result] = fminsearch(@(par) sum(cumsum(var([y_obs', fcn_2d(par,x_obs)'],0,2))), [y0, 0.1, -0.5, 0.1, -0.5, ]);
[Pars_2d] = fminsearch(@(par) sum(cumsum(var([y_obs', fcn_2d(par,x_obs)'],0,2))), [y0, 0.1, -0.5, 0.1, -0.5, ]);
%[Pars_2d0]= fminsearch(@(par) sum(cumsum(var([y_obs', fcn_2d0(par,x_obs)'],0,2))), [0.1, -0.5, 0.1, -0.5, ]);

%[Pars_1d, fval]         = fminsearch(@(par) sum(var([y_obs', fcn_1d(par,x_obs)'],0,2)), [y0, 0.1, -0.5,]);        
%[Pars, fval, result] = fminsearch(@(par) sum(var((vertcat(y_obs, fcn(par,x_obs))))), [y0, 0.1, -0.5, 0.1, -0.5, 0.1, -0.5]); 

if plotOn == 1
    figure; 
    %-- Curve-fitting
    subplot(1,2,1)
    hold on
    plot(x_obs, y_obs, 'p'); 
    %plot(x_obs, fcn_1d(Pars_1d,x_obs)); 
    plot(x_obs, fcn_2d(Pars_2d,x_obs)); 
    %plot(x_obs, fcn_2d0(Pars_2d0, x_obs)); 
    %plot(x_obs, (fcn_1d(Pars_2d(1:3), x_obs))); %first exponential
    %plot(x_obs, (fcn_1d(Pars_2d([1,4:5]), x_obs))); %second exponetial
    xlabel("Samples")
    ylabel("Y val")
    title("Second-Order Exponential Curve Fit")
    hold off
    % -- Differentials
    subplot(1,2,2)
    hold on
    plot(x_obs(1:end-1), diff(fcn_2d(Pars_2d,x_obs)));
    plot(x_obs(1:end-1), diff(fcn_1d(Pars_2d(1:3), x_obs)));
    plot(x_obs(1:end-1), diff(fcn_1d(Pars_2d([1,4:5]), x_obs)));
    legend({'net equation', 'exponential 1', 'exponential 2'})
    xlabel("t (sample");
    ylabel("dx/dt");
    title( "dx/dt of Fitted Exponential")
end

end


