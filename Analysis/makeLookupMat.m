function makeLookupMat(folder,orgType,output_file)
%MAKELOOKUPMAT Generate lookuptable struct as a .mat file
% allardlab.com
    %   MAKELOOKUPMAT(folder,orgType,output_file) creates and saves a .mat 
    %   file (output_file) with a lookuptable object generated from output
    %   files in folder
    %
    %
    %   Inputs:
    %         folder      : (string) full path to input folder
    %         orgType     : folder structure organization
    %                       0 - every file in the folder is an output file
    %                       1 - folder/run.*/ output file
    %                           + other files
    %                       2 - folder contains multiple folders of type 1
    %                           structure
    %         output_file : (string) full path to output .mat file
    %   
    %   See also GETOUTPUTCONTROL
    arguments
        folder string
        orgType double {mustBeMember(orgType,[0,1,2])}
        output_file string
    end
    
    lookuptable=struct;
    if orgType == 0
        files=dir(fullfile(folder,'*.txt'));
        for i=1:length(files)
            addentry(files(i).name,folder);
        end
    elseif orgType == 1 || orgType==2
        if orgType==2
            files=dir(fullfile(folder,'*','run.*'));
        else
            files=dir(fullfile(folder,'run.*'));
        end
        for i=1:length(files)
            subfolder=strcat(files(i).folder,"/",files(i).name);
            subfiles=dir(fullfile(subfolder,'output_*.txt'));
            if isempty(subfiles)
                subfiles=dir(fullfile(subfolder,'live_output_*.txt'));
                if isempty(subfiles)
                    error("No valid output file found in %s\nThere are no files that match output_*.txt or live_output_*.txt",subfolder)
                else
                    valid_converted_live=[];
                    valid_fnames=[];
                    for j=1:length(subfiles)
                        fname=subfiles(j).name;
                        if contains(fname,'last_modern.txt')
                            valid_converted_live=[valid_converted_live;fname];
                        else
                            valid_fnames=[valid_fnames;fname];
                        end
                    end
                    if isempty(valid_converted_live)
                        if size(valid_fnames)~=1
                            error("Multiple live_output_*.txt files that do not end in last_modern.txt found in %s",subfolder)
                        else
                            addentry(valid_fnames,subfolder);
                        end
                    elseif size(valid_converted_live)~=1
                        error("Multiple live_output_*.last_modern.txt files found in %s",subfolder)
                    else
                        addentry(valid_converted_live,subfolder);
                    end
                end
            else
                valid_fnames=[];
                for j=1:length(subfiles)
                    fname=subfiles(j).name;
                    if ~contains(fname,'legacy')
                        valid_fnames=[valid_fnames; fname];
                    end
                end
                if isempty(valid_fnames)
                    error("No valid output file found in %s\nAll output_*.txt files contain the word 'legacy'",subfolder)
                elseif size(valid_fnames)~=1
                    error("Multiple valid output file names found in %s\nEnsure that legacy outputs contain the word 'legacy'",subfolder)
                else
                    addentry(valid_fnames,subfolder);
                end
            end
        end
    end

    save(output_file,"lookuptable",'-mat')
    
    function addentry(fname,path)
        path=strcat(path,"/");
        sub_struct = getOutputControl(fname,input_file_path=path);
        lookuptable.(sub_struct.type).(strcat("N",num2str(sub_struct.N(1)))) = sub_struct;
    end

end