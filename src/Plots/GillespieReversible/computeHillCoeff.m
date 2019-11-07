%% Function to find inverse of hill curve 
% Find approximate x value for given y value

function [hillcoeffEst, KA_Est, HillCoeffMaxSlope, kinaseIntrinsicRatePlot,slope] = computeHillCoeff(constant, kinaseIntrinsicRate, avgSteadyState) 
    %% Find 0.1 and 0.9 x values for estimating Hill coefficient
    % This is super ugly - clean this up - better variable names etc
    
    i11 = find((avgSteadyState)-0.1<0,1,'first');
    i12 = find((avgSteadyState)-0.1>0,1,'last');
    x11 = kinaseIntrinsicRate(i11);
    x12 = kinaseIntrinsicRate(i12);
    slope1 = ((avgSteadyState(i11))-(avgSteadyState(i12)))/(kinaseIntrinsicRate(i11)-kinaseIntrinsicRate(i12));
    
    i91 = find((avgSteadyState)-0.9<0,1,'first');
    i92 = find((avgSteadyState)-0.9>0,1,'last');
    x91 = kinaseIntrinsicRate(i91);
    x92 = kinaseIntrinsicRate(i92);
    slope9 = ((avgSteadyState(i91))-(avgSteadyState(i92)))/(kinaseIntrinsicRate(i91)-kinaseIntrinsicRate(i92));
    
    x1 = (0.1-(avgSteadyState(i11)))/slope1 + x11;
    x9 = (0.9-(avgSteadyState(i91)))/slope9 + x91;
    
    hillcoeffEst = log10(81)/(log10(x9/x1));
 
    %% Find KA
    
    i51 = find((avgSteadyState)-0.5<0,1,'first');
    i52 = find((avgSteadyState)-0.5>0,1,'last');
    x51 = kinaseIntrinsicRate(i51);
    x52 = kinaseIntrinsicRate(i52);
    slope5 = ((avgSteadyState(i51))-(avgSteadyState(i52)))/(kinaseIntrinsicRate(i51)-kinaseIntrinsicRate(i52));
    
    KA_Est = (0.5-(avgSteadyState(i51)))/slope5 + x51;
   
    %% MAX LOG SLOPE Hill Coeff Estimate
    start_ind = find(log10(kinaseIntrinsicRate) < 2,1, 'first');
    end_ind = find(log10(kinaseIntrinsicRate) < -2,1, 'first');
    
    switch (constant)
        case 0 
            %diffy = diff(movmean(log10((avgSteadyState(41:81))./(1-avgSteadyState(41:81))),3));
            diffy = diff((log10((avgSteadyState(start_ind:end_ind))./(1-avgSteadyState(start_ind:end_ind)))));
            diffx = diff(log10(kinaseIntrinsicRate(start_ind:end_ind)));
            %slope = diffy./diffx;
            slope = movmean(diffy./diffx,4);
            HillCoeffMaxSlope = max(slope);
            
            kinaseIntrinsicRatePlot = log10(kinaseIntrinsicRate(start_ind+1:end_ind));
        case 1
            %diffy = diff(movmean(log10((avgSteadyState(45:end-20))./(1-avgSteadyState(45:end-20))),3));
            diffy = diff((log10((avgSteadyState(start_ind:end_ind))./(1-avgSteadyState(start_ind:end_ind)))));
            diffx = diff(log10(kinaseIntrinsicRate(start_ind:end_ind)));
            slope = movmean(diffy./diffx,4);
            HillCoeffMaxSlope = max(slope);
            
            kinaseIntrinsicRatePlot = log10(kinaseIntrinsicRate(start_ind+1:end_ind));
        case 2
            %diffy = diff(movmean(log10((avgSteadyState(45:end))./(1-avgSteadyState(45:end))),3));
            diffy = diff((log10((avgSteadyState(start_ind:end_ind))./(1-avgSteadyState(start_ind:end_ind)))));
            diffx = diff(log10(kinaseIntrinsicRate(start_ind:end_ind)));
            slope = movmean(diffy./diffx,4);
            HillCoeffMaxSlope = max(slope);
            
            kinaseIntrinsicRatePlot = log10(kinaseIntrinsicRate(start_ind+1:end_ind));
    end
    
    
end
