%% Estimate hydrophobicity of amino acid sequence based on values from Wimley & White

%% Initialize amino acid sequences for TCR

epsilonMouseSeq = {'K','N','R','K','A','K','A','K','P','V','T','R','G','T','G',...
    'A','G','S','R','P','R','G','Q','N','K','E','R','P','P','P','V','P',...
    'N','P','D','Y','E','P','I','R','K','G','Q','R','D','L','Y','S','G',...
    'L','N','Q','R','A','V'};
    
zetaMouseSeq =  {'R','A','K','F','S','R','S','A','E','T','A','A','N','L','Q',...
    'D','P','N','Q','L','Y','N','E','L','N','L','G','R','R','E','E','Y',...
    'D','V','L','E','K','K','R','A','R','D','P','E','M','G','G','K','Q',...
    'Q','R','R','R','N','P','Q','E','G','V','Y','N','A','L','Q','K','D',...
    'K','M','A','E','A','Y','S','E','I','G','T','K','G','E','R','R','R',...
    'G','K','G','H','D','G','L','Y','Q','G','L','S','T','A','T','K','D',...
    'T','Y','D','A','L','H','M','Q','T','L','A','P','R'};

zetaHumanSeq = {'R','V','K','F','S','R','S','A','D','A','P','A','Y','Q',...
    'Q','G','Q','N','Q','L','Y','N','E','L','N','L','G','R','R','E','E',...
    'Y','D','V','L','D','K','R','R','G','R','D','P','E','M','G','G','K',...
    'P','Q','R','R','K','N','P','Q','E','G','L','Y','N','E','L','Q','K',...
    'D','K','M','A','E','A','Y','S','E','I','G','M','K','G','E','R','R',...
    'R','G','K','G','H','D','G','L','Y','Q','G','L','S','T','A','T','K',...
    'D','T','Y','D','A','L','H','M','Q','A','L','P','P','R'};


deltaMouseSeq = {};

gammaMouseSeq = {};


%% Find parameters

[zetaLength,zetaY,zetaBasics,zetaHydrophobicity] = sequenceParameters(zetaMouseSeq)
[zetaHumLength,zetaHumY,zetaHumBasics,zetaHumHydrophobicity] = sequenceParameters(zetaHumanSeq)
[epsilonLength,epsilonY,epsilonBasics,epsilonHydrophobicity] = sequenceParameters(epsilonMouseSeq)














%% Create function to find parameters for given sequence

function [seqLength, seqY, seqBasics, seqHydrophobicity] = sequenceParameters(seq)
    %% Initialize amino acid names and abbreviations
    aminoAcidNames = {'Ala','Arg','Asn','Asp','Cys','Gln','Glu','Gly','His','Ile','Leu','Lys','Met','Phe','Pro','Ser','Thr','Trp','Tyr','Val'};
    aminoAcidAbbrev = {'A','R','N','D','C','Q','E','G','H','I','L','K','M','F','P','S','T','W','Y','V'};

    %% Initialize amino acid hydrophobicity from Wimley&White 1996
    aaInterfaceResidue = [-0.17,-0.81,-0.42,-1.23,0.24,-0.58,-2.02,-0.01,-0.17,0.31,0.56,-0.99,0.23,1.13,-0.45,-0.13,-0.14,1.85,0.94,-0.07]; % Wimley & White 1996
    interfacepH = [8,2,8,8,8,8,8,8,8,8,8,2,8,8,8,8,8,8,8,8];

    %% Find sequence length
    
    seqLength = length(seq);
    
    %% Find tyrosine indices

    seqY = find(strcmp(seq,'Y'));

    %% Find basic residue indices

    % zeta
    R = find(strcmp(seq,'R'));
    H = find(strcmp(seq,'H'));
    K = find(strcmp(seq,'K'));

    seqBasics = union(union(R,H),K);

    %% Find hydrophobicity of chain
    
    aaHydro = zeros(1,length(seq));
    for i=1:length(seq)
        aaIndex(i) = find(strcmp(aminoAcidAbbrev,seq{i}));
    end
    
    aaHydrophobicity = aaInterfaceResidue(aaIndex);
    
    kcalpermol2kbt = 1.69;
    KuhnlengthSquared = 9; % estimate amino acid goes 3-4 Kuhn lengths into membrane, then square
    
    seqHydrophobicity = (sum(aaHydrophobicity)/length(seq))*kcalpermol2kbt/KuhnlengthSquared;
    
end









