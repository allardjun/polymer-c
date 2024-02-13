function output_struct = getOutputControl(input_fname,saveTF,NameValueArgs)
%GETOUTPUTCONTROL Read a vertical ASCII file of output values generated 
% by outputControl.c and convert to a Matlab struct object
% allardlab.com
    %   output_struct= GETOUTPUTCONTROL(input_fname) generates Matlab 
    %   struct based on input file (in current directory)
    %
    %   output_struct= GETOUTPUTCONTROL(input_fname,saveTF) generates 
    %   Matlab struct based on input file (in current directory) and saves 
    %   a .mat file with the struct if saveTF is true
    %
    %   output_struct= GETOUTPUTCONTROL(input_fname,Value) generates Matlab 
    %   struct based on input file (in current directory) with specified 
    %   parameters set using one or more name-value pair arguments
    %
    %   output_struct= GETOUTPUTCONTROL(input_fname,saveTF,Value) generates 
    %   Matlab struct based on input file (in current directory) with 
    %   specified parameters set using one or more name-value pair 
    %   arguments and saves a .mat file with the struct if saveTF is true
    %
    %   Inputs:
    %         input_fname : (string) .txt output file to parse
    %         saveTF      : [optional] (bool) determines whether a .mat 
    %                       file with the output struct object is saved 
    %                       (default=0)
    %         Value       : [optional] name-value pairs; specificed as
    %                       ValueName=argument
    %                     input_file_path : (string) path to input file (if
    %                                       not in current directory)
    %                     output_file_path: (string) path to output file 
    %                                       (if not in current directory)
    %                     output_fname    : (string) name of output file,
    %                                       must be .mat 
    %                                       (default = 'input_fname'.mat)
    %                     tempdir         : (string) path to folder to
    %                                       store temp files 
    %                                       (deafult="/tmp/")
    %   note: it is assumed that nt is the first entry
    %   Output is the struct object
    %   See also MAKELOOKUPMAT
arguments
    input_fname string
    saveTF {mustBeNumericOrLogical}=0
    NameValueArgs.input_file_path string=""
    NameValueArgs.output_file_path string=""
    NameValueArgs.output_fname string = strcat(input_fname,".mat")
    NameValueArgs.tempdir string ="/tmp/"
end
    
    full_input_file= strcat(NameValueArgs.input_file_path,input_fname);
    full_temp_file=strcat(NameValueArgs.tempdir,input_fname);
    
    % sort lines in the file using bash 
    % create temp files
    command = sprintf('tail -r %s | awk ''!flag; /nt/{flag = 1};'' | tail -r | sort > "%s.sorted"', full_input_file,full_temp_file); % gets last output (for live scripts) and sorts lines
    system(command);
    command = sprintf( 'sed ''s/\\[[^]]*\\]//g'' %s.sorted > %s.sorted.nosquare', full_temp_file, full_temp_file); % removes brackets []
    system(command);
    
    
    MAXDIM = 1000; % maximum assumed dimension of any particular key, used for memory allocation. The code should still work for larger sizes, but suffer slower performance.
    
    fileID = fopen(strcat(full_temp_file,'.sorted.nosquare'), 'r');
    if fileID == -1
        filename=strcat(full_temp_file,'.sorted.nosquare');
        error(strcat('Cannot open file: ', filename));
    end
    
    
    % temporary storage for a particular key while it's being filled
    matrix_during_filling = zeros(MAXDIM,MAXDIM);
    
    %disp(fgetl(fileID))
    tline = strtrim(fgetl(fileID));
    while ischar(tline)
        is_unread_line = 1; 
        lineData = strsplit(tline); % delimit the line by spaces
        lineData=lineData(~cellfun('isempty',lineData)); % remove empty cells
        key = lineData{1};
        
    
        if (numel(lineData) == 2 && ~isempty(lineData{2})) % simple single value per run
            value = str2num(lineData{2});
        elseif(numel(lineData) == 3 && ~isempty(lineData{3}) && is_unread_line==1) % interpret the 2nd entry as indexing the filament
            coordinate1 = str2num(lineData{2})+1; % go from C's zero-indexing to Matlab's 1-indexing
            
            matrix_during_filling(coordinate1) = str2num(lineData{3});
    
            maxCoordinate1=coordinate1;
            while is_unread_line == 1 && ischar(tline)
                tline = fgetl(fileID);
                if ischar(tline)
                    lineData = strsplit(tline); % delimit the line by spaces
                    if strcmp(lineData{1},key)
                        coordinate1 = str2num(lineData{2})+1; % go from C's zero-indexing to Matlab's 1-indexing
                        if coordinate1>maxCoordinate1 
                            maxCoordinate1=coordinate1; 
                        end
                        matrix_during_filling(1,coordinate1) = str2num(lineData{3});
                    else
                       is_unread_line = 0;
                    end
                end
            end
    
            % make shrunken matrix for values
            value = matrix_during_filling(1,1:maxCoordinate1);
    
        elseif (numel(lineData) == 4 && ~isempty(lineData{4}) && is_unread_line==1) % interpret the 3rd entry as indexing the site
            coordinate1 = str2num(lineData{2})+1; % go from C's zero-indexing to Matlab's 1-indexing
            coordinate2 = str2num(lineData{3})+1; 
            matrix_during_filling(coordinate1,coordinate2) = str2num(lineData{4});
            maxCoordinate1=coordinate1;
            maxCoordinate2=coordinate2;
            while is_unread_line == 1 && ischar(tline)
                tline = fgetl(fileID);
                if ischar(tline)
                    lineData = strsplit(tline); % delimit the line by spaces
                    if strcmp(lineData{1},key)
                        coordinate1 = str2num(lineData{2})+1; % go from C's zero-indexing to Matlab's 1-indexing
                        coordinate2 = str2num(lineData{3})+1;
                        if coordinate1>maxCoordinate1 
                            maxCoordinate1=coordinate1; 
                        end
                        if coordinate2>maxCoordinate2 
                            maxCoordinate2=coordinate2; 
                        end
                        matrix_during_filling(coordinate1,coordinate2) = str2num(lineData{4});
                    else
                        is_unread_line = 0;
                    end
                end
            end
            % make shrunken matrix for values
            value = matrix_during_filling(1:maxCoordinate1, 1:maxCoordinate2);
        end
    
        if ~contains(key,"-")
            if ~exist("output_struct", "var")
                output_struct = struct(key,value);
            else
                output_struct.(key)=value;
            end
        end
    
        if (is_unread_line && ischar(tline)) 
            tline = fgetl(fileID); 
        end
    
    end
    if output_struct.NFil==1
        output_struct.type="single";
    elseif output_struct.NFil==2
        if output_struct.kdimer==0
            output_struct.type="double";
        else
            output_struct.type="dimer";
        end
    end

    fclose(fileID);
    
    if saveTF
        % save output structure variable to a .mat file
        save(fullfile(NameValueArgs.output_file_path,NameValueArgs.output_fname),"output_struct",'-mat')
    end


    % delete temp sorted files
    command = sprintf('rm "%s.sorted" ',full_temp_file);
    system(command);
    command = sprintf('rm %s.sorted.nosquare',full_temp_file);
    system(command);

end