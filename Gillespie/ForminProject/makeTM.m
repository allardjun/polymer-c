saveloc="/Users/katiebogue/MATLAB/GitHub/Data/Gillespie_data";

construct_names={"PA","PB","PC","PD","FH1","PAPD","PBPD","PCPD","PA15","PA15_16","FH115","FH115_16","PA13","PA13_14","PA15PD","PA15PD_16"};

construct_PRM_locs={[104], [63], [42],[25], [25, 42, 63, 104], [25, 104], [25, 63], [25,42], [104],[104],[25, 42, 63, 104],[25, 42, 63, 104],[104],[104],[25, 104],[25, 104]};
construct_PRM_sizes={[12],[14],[7],[5],[5, 7, 14, 12],[5, 12], [5, 14], [5, 7], [15],[16],[5, 7, 14, 15],[5, 7, 14, 16], [13],[14],[5,15],[5,16]};

% set constants
c_PA=0.88;
G=0.5;
k_cap=73.02274;
k_del=0.022909;
r_cap=37896.5784;
r_del=0; % we are considering release instant
k_rel=10^8; %very large to make this step "instant"
r_cap_exp=0.86103;

% choose which prob density to use
prname="Prvec0";

% polymer-c output folder 
fname='/Users/katiebogue/MATLAB/GitHub/Data/polymer-c_data/bni1_msb/double.2024.03.12/BSD35.5.radtype20';

for k=1:length(construct_PRM_sizes)
    % Formin info
    PRM_locs=construct_PRM_locs{k};
    PRM_sizes=construct_PRM_sizes{k};

    [states, numValidStates, transitionMatrix, isBound, isDelivered] = generateTMtemplate(PRM_locs);
    
    [output_mat, output_cell] = readInMSBFiles(fname, states, PRM_locs);
    
    % Get relevent polymer stats
    pocc = getStateVals(output_mat,PRM_locs,"POcclude");
    prvec = getStateVals(output_mat,PRM_locs,prname);
    pocc_0 = getStateVals(output_mat,1,"POcclude");
    
    PRM_sizes2 = [PRM_sizes, PRM_sizes];

    for i=1:numValidStates
        fromstate=states(i,:);
        for j=1:numValidStates
            tostate=states(j,:);
            if sum(fromstate~=tostate)==1 % if only one state has changed, compute the rate (all other transitions are not possible)
                diffPRM=find(fromstate~=tostate);
                if fromstate(diffPRM)==0 % the PRM is unbound at first --> only option is capture
                    if tostate(diffPRM)==1 % unbound --> bound
                        transitionMatrix(i,j)= k_cap * (1-pocc(i,diffPRM)) * c_PA; % CAPTURE
                    end
                elseif fromstate(diffPRM)==1 % the PRM is bound at first --> options are reverse capture or delivery
                    if tostate(diffPRM)==2 % bound --> delivered
                        transitionMatrix(i,j)= k_del * (1-pocc_0(i,((diffPRM>length(PRM_locs))+1))) * G * (1.0e33*(prvec(1,diffPRM))/(27*6.022e23)); % DELIVERY
                    elseif tostate(diffPRM)==0 % bound --> unbound
                        transitionMatrix(i,j)= r_cap * exp(-1 * PRM_sizes2(diffPRM) * r_cap_exp); % REVERSE DELIVERY
                    end
                elseif fromstate(diffPRM)==2 % the PRM is delivered at first --> options are reverse delivery or release
                    if tostate(diffPRM)==1 % delivered --> bound
                        transitionMatrix(i,j)= r_del; % REVERSE DELIVERY 
                    elseif tostate(diffPRM)==0 % delivered --> unbound
                        transitionMatrix(i,j)= k_rel; % RELEASE
                    end
                end
            end
    
        end
    end
    mkdir(fullfile(saveloc,construct_names{k}))
    save(fullfile(saveloc,construct_names{k},"TM.mat"))
    writematrix(states,fullfile(saveloc,construct_names{k},"states.txt"))
    writematrix(transitionMatrix,fullfile(saveloc,construct_names{k},"TM.txt"))
end
