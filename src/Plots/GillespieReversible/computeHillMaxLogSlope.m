%% Function to find inverse of hill curve 
% Find approximate x value for given y value

function [HillCoeffMaxSlope,HillCoeffMaxSlope_std,kinaseIntrinsicRatePlot,slope, slope_fit] = computeHillMaxLogSlope(model,constant,spacing, kinaseIntrinsicRate, avgSteadyState) 

    %% MAX LOG SLOPE Hill Coeff Estimate
    % set domain based on model
    switch model
        case 10 % local stiffening
            switch(constant)
                case 0 % constant dephos
                    domainStart = find(log10(kinaseIntrinsicRate) < 1.5,1, 'first');
                    domainEnd = find(log10(kinaseIntrinsicRate) < -0.0,1, 'first');
                case 1 % steric dephos
                    domainStart = find(log10(kinaseIntrinsicRate) < 0.5,1, 'first');
                    domainEnd = find(log10(kinaseIntrinsicRate) < -0.4,1, 'first');
            end

        case 20 % membrane association
            switch(spacing)
                case 0 % CD3 Zeta
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
                case 1 % Evenly spaced CD3 Zeta
                    domainStart = 1;
                    domainEnd = length(kinaseIntrinsicRate);
                    disp("Warning: no bounds set for EvenSite spacing!");
                    
                case 2 % CD3 Epsilon
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
    
    % compute slope
    diffy = diff(log10((avgSteadyState(domainStart:domainEnd))./(1-avgSteadyState(domainStart:domainEnd))));
    diffx = diff(log10(kinaseIntrinsicRate(domainStart:domainEnd)));
    slope = diffy./diffx;
    
    % previous, alternate methods
    %diffy = diff(movmean(log10((avgSteadyState(domainStart:domainEnd))./(1-avgSteadyState(domainStart:domainEnd))),3));
    %diffy = diff((log10((avgSteadyState(domainStart:domainEnd))./(1-avgSteadyState(domainStart:domainEnd)))));
   
    % fit slopes to cubic
    fit = polyfit(log10(kinaseIntrinsicRate(domainStart+1:domainEnd)),slope,3);
    slope_fit = polyval(fit,log10(kinaseIntrinsicRate(domainStart+1:domainEnd)));
    
    % calculate sum of squared residuals and rmse
    SSR = sum((slope_fit-slope).^2)
    slope_rmse = sqrt(SSR./length(slope))

    % set max slope and error
    HillCoeffMaxSlope = max(slope_fit);
    HillCoeffMaxSlope_std = slope_rmse;

    % return domain of slope
    kinaseIntrinsicRatePlot = log10(kinaseIntrinsicRate(domainStart+1:domainEnd));

end
