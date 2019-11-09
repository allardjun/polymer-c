%% Function to find inverse of hill curve 
% Find approximate x value for given y value

function [hillcoeffEst, KA_Est, HillCoeffMaxSlope,HillCoeffMaxSlope_std,kinaseIntrinsicRatePlot,slope, slope_fit] = computeHillCoeff(model,constant,spacing, kinaseIntrinsicRate, avgSteadyState) 
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
    switch model
        case 10
            switch(constant)
                case 0
                    domainStart = find(log10(kinaseIntrinsicRate) < 1.5,1, 'first');
                    domainEnd = find(log10(kinaseIntrinsicRate) < -0.0,1, 'first');
                case 1
                    domainStart = find(log10(kinaseIntrinsicRate) < 0.5,1, 'first');
                    domainEnd = find(log10(kinaseIntrinsicRate) < -0.4,1, 'first');
            end

        case 20
            switch(spacing)
                case 0
                    switch constant
                        case 0
                            % for constant:
                            % use domain on right of axis
                            domainStart = find(log10(kinaseIntrinsicRate) < 2.5,1,'first');
                            domainEnd = find(log10(kinaseIntrinsicRate) < 1,1,'first');
                            if( isempty(domainStart) || isempty(domainEnd) )
                                disp('Warning: domain index extends past domain!');
                            end
                        case 1
                            % for prefactor:
                            domainStart = find(log10(kinaseIntrinsicRate) < 0.5,1,'first');
                            domainEnd = find(log10(kinaseIntrinsicRate) < -1,1,'first');
                    end
                case 1
                    domainStart = 1;
                    domainEnd = length(kinaseIntrinsicRate);
                    disp("Warning: no bounds set for EvenSite spacing!");
                    
                case 2
                    switch constant
                        case 0
                            % for constant:
                            % use domain on right of axis
                            domainStart = find(log10(kinaseIntrinsicRate) < 3,1,'first');
                            domainEnd = find(log10(kinaseIntrinsicRate) < 1,1,'first');
                            if( isempty(domainStart) || isempty(domainEnd) )
                                disp('Warning: domain index extends past domain!');
                            end
                        case 1
                            % for prefactor:
                            domainStart = find(log10(kinaseIntrinsicRate) < 1,1,'first');
                            domainEnd = find(log10(kinaseIntrinsicRate) < -0.5,1,'first');
                    end
            end
    end
    
    %diffy = diff(movmean(log10((avgSteadyState(domainStart:domainEnd))./(1-avgSteadyState(domainStart:domainEnd))),3));
    %diffy = diff((log10((avgSteadyState(domainStart:domainEnd))./(1-avgSteadyState(domainStart:domainEnd)))));
   
    diffy = diff(log10((avgSteadyState(domainStart:domainEnd))./(1-avgSteadyState(domainStart:domainEnd))));
    diffx = diff(log10(kinaseIntrinsicRate(domainStart:domainEnd)));
    slope = diffy./diffx;
    
    % fit slopes to cubic
    fit = polyfit(log10(kinaseIntrinsicRate(domainStart+1:domainEnd)),slope,3);
    slope_fit = polyval(fit,log10(kinaseIntrinsicRate(domainStart+1:domainEnd)));
    
    % calculate sum of squared residuals and rmse
    SSR = sum((slope_fit-slope).^2)
    slope_rmse = sqrt(SSR./length(slope))

    HillCoeffMaxSlope = max(slope_fit);
    HillCoeffMaxSlope_std = slope_rmse;


    kinaseIntrinsicRatePlot = log10(kinaseIntrinsicRate(domainStart+1:domainEnd));

    
    
end
