function [states, numValidStates, transitionMatrix, isBound, isDelivered] = generateTMtemplate(PRM_locs)
%GENERATETMTEMPLATE Generate template for transition matrix for formin
%based on an array of PRM locations
% allardlab.com
    %   [states, numValidStates, transitionMatrix, isBound, isDelivered] =
    %   GENERATETMTEMPLATE(PRM_locs) creates empty transition matrix and
    %   various bools based on the number of PRM locations
    %
    %   Inputs:
    %         PRM_locs : array of PRM locations
    %
    %   Outputs:
    %         states           : (mat) ixN matrix with matrix with states, each row is a
    %                            state, each column is a PRM, the values are:
    %                               0- unbound
    %                               1- bound
    %                               2- delivered
    %         numValidStates   : (double) number of states
    %         transitionMatrix : (mat) empty ixi transition matrix 
    %         isBound          : (mat) ixN matrix with matrix of bools, each row is a
    %                            state, each column is a PRM, values are if
    %                            the PRM is bound
    %         isDelivered      : (mat) ixN matrix with matrix of bools, each row is a
    %                            state, each column is a PRM, values are if
    %                            the PRM is delivered
    %
    %       Where N= number of PRMs and i= numValidStates
    %   
    %   See also GETOUTPUTCONTROL, READINMSBFILES, GETSTATEVALS.
    
    % N: Number of binding sites
    N = 2*length(PRM_locs); % assumes there are two identical FH1s
    
    % Number of possible states for a single site
    siteStates = 3; % unbound, bound, delivered

    % Initialize storage for valid states
    validStates = [];
    isBoundList = [];
    isDeliveredList = [];

    % Enumerate all possible states
    totalStates = siteStates^N;
    for i = 0:totalStates-1
        state = dec2base(i, siteStates, N) - '0'; % Convert index to base-3
        
        % Check validity: Only one site can be "delivered"
        if sum(state == 2) <= 1
            validStates = [validStates; state];
            isBoundList = [isBoundList; (state == 1)];
            isDeliveredList = [isDeliveredList; (state == 2)];
        end
    end

    % Store valid states and corresponding properties
    states = validStates;
    isBound = isBoundList;
    isDelivered = isDeliveredList;

    % Initialize the transition matrix for valid states
    numValidStates = size(states, 1);
    transitionMatrix = zeros(numValidStates);

end
