

function [vResidual, vPulse] = subtractVectorHeading(vObs, vHeading, posAct)
%Copyright (c) 2026 Trevor S. Smith [@TrevorShawnSmith]
%    This function is part of TS_Functions and is licensed under the MIT License.
%    (See the LICENSE file in the root repository for full terms.)
%
%% subtractVectorHeading
%
% update for OOP
%
% Assume that vObs is a [N_DIMS x N_OBS] array and vHeading is a [N_DIMS x
% 1] vector 
%
% this is the core kernel for iterative subtraction; 

arguments
    vObs
    vHeading
    posAct = 0; 
end


        Xt = vObs; 
        Vt = vHeading; 
        VM = vmag(Vt);  %Reference vector magnitude             
        FM = vmag(vObs); %Observed (force) vector magnitude; 
        Vt0 = Vt; 

        try
            cosTheta = (Vt'*Xt)./(VM.*FM);      %cosine similarity [ A o B/ |A||B|]
        catch
            cosTheta = (Vt*Xt)./(VM.*FM); 
        end
        if posAct
            % Force ONLY postive activations; 
            cosTheta = max(0, cosTheta); 
        end

        
        VPM = cosTheta.*FM;                     %projected component within the Defined Vector; 
        VDt = Vt0*VPM; 
        %VDt = rowMult(VPM, Vt0);                %Vector heading scaled by in-plane magnitude;  
    
        D0 = Xt - VDt;                          %Remaining unaccounted-for-force            
    
        %{
        % __ Store; 
        pulseArr(dd,:)  = VPM; 
        pulseVect(dd,:) = Vt0; 
        % __ Reset for iteration;       
        Xt = D0; 
        FM = (sum(D0.^2)).^0.5; 
        %}

        vResidual = D0; 
        vPulse = VPM; 

        1; 

end