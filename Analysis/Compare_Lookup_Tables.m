% COMPARE_LOOKUP_TABLES Compares two lookup tables generated from polymer-c
% and creates heatmaps/plots of the differences (does not work with current
% lookuptable format)
% 
% Need to set variables in the script for the lookup tables, their labels,
% and where to save the output plots.
% 
%   Creates 4 plots:
%       1 - heatmap (rows x columns) of absolute differences between values (saved as .fig)
%       2 - heatmap (rows x columns) of percent differences between values (saved as .fig)
%       3 - scatterplot of absolute differences between values vs. entry
%           index (saved to .pdf in combination with 4)
%       4 - scatterplot of log absolute differences between values vs. entry
%           index (saved to .pdf in combination with 3)
% 
% The first lookup table (Lookup table 1) will be treated as the accepted
% values for the calculation of percent difference/error
%
% Note that the first collumn of the data is not shown in the subtraction
% matrix

clear
clc
close all
%% Set variables
% Lookup table 1 file name
table1 = 'dimer_122.txt'; % 'single1_300.txt' 'double_200.txt' 'dimer_122.txt' 

% Lookup table 1 output label name
lookup1 = 'Original Dimer Lookup Table';

% Lookup table 2 file name
table2 = 'dimer.N122_lookuptable.txt'; % 'single.N300_lookuptable.txt' 'double.N200_lookuptable.txt' 'dimer.N122_lookuptable.txt'

% Lookup table 2 output label name
lookup2 = 'New Dimer Lookup Table';

% Output file location
results_loc = '/Users/Katiebogue/MATLAB/GitHub/Data/polymer-c_data/lookup_tables/Compare';

% Output folder
time= datestr(now, 'yyyy-mm-dd_HH-MM');
time= convertCharsToStrings(time);
output_fol = table1 + "_vs_" + table2 + "_" + time;
pdf_name = "PErrorPlots.pdf";

%% Compare Tables
% read in tables
T1 = dlmread(table1);
T2 = dlmread(table2);

% turn 0s to nans
T1(T1 == 0)= NaN;
T2(T2 == 0)= NaN;

% check that lookup tables are the same size
if size(T1)==size(T2)
else
    error('Lookup tables are not the same size')
end
for i = 1:height(T1)
    for k = 1:length(T1)
        if T1(i,k)==NaN
            if T2(i,k)==NaN
            else
               error('Lookup tables are not the same size')
            end
        else
            if T2(i,k)==NaN
               error('Lookup tables are not the same size')
            end
        end
    end
end

% create matrix of differences
sub_matrix = T1-T2;
abs_diff_matrix = abs(sub_matrix);
perc_error_matrix = abs_diff_matrix./abs(T1);

% Remove first collumn from subtraction matrix
sub_matrix(:,1) = NaN;

%% Create Heatmaps

% Heatmap labels
XLabels=1:length(T1);
CustomXLabels = string(XLabels);

YLabels=1:height(T1);
CustomYLabels = string(YLabels);

Title_track = "Lookup Table Comparison:";

% Replace all but the fifth elements by spaces
CustomXLabels(mod(XLabels,200) ~= 0) = " ";
CustomYLabels(mod(YLabels,50) ~= 0) = " ";

cd(results_loc);
mkdir(output_fol);
cd(output_fol);

% Subtraction
h = heatmap(sub_matrix);
h.GridVisible = 'off';
h.XLabel = 'Collumns';
h.YLabel = 'Rows (N value)';
h.XDisplayLabels = CustomXLabels;
h.YDisplayLabels = CustomYLabels;
Temp_title = Title_track + ' ' + lookup1 + ' minus ' + lookup2;
h.Title = Temp_title;
h.Colormap = cool;

saveas(gcf, 'Sub_heatmap.fig')
 
close all
 
% Percent error
h = heatmap(perc_error_matrix);
h.GridVisible = 'off';
h.XLabel = 'Collumns';
h.YLabel = 'Rows (N value)';
h.XDisplayLabels = CustomXLabels;
h.YDisplayLabels = CustomYLabels;
Temp_title = Title_track + ' ' + 'percent difference between' + lookup1 + ' - ' + lookup2;
h.Title = Temp_title;
h.Colormap = cool;

saveas(gcf, 'PErr_heatmap.fig')

close all

%% Create plots

%percent error
perc_error_vector = reshape(perc_error_matrix, 1, height(perc_error_matrix)*length(perc_error_matrix));
plot(perc_error_vector);
xlabel('Cells');
ylabel('Percent Difference');
title('Lookup Table Comparison- Percent Difference');

% add horizontal line at 0.2%
hold on
yline(0.002, '-','K_{critical}');

% Find Max
perc_error_max = max(perc_error_vector);
[row,col]=find(perc_error_matrix == perc_error_max);

% Label Max
txt = {"\leftarrow Max = " + perc_error_max, "row = " + row, "col = " + col};
text(find(perc_error_vector == perc_error_max), perc_error_max, txt, 'VerticalAlignment', 'cap');

saveas(gcf, append('temp.pdf'))
append_pdfs(pdf_name, append('temp.pdf'))

close all

%create log graph
perc_error_log_vector=log(perc_error_vector);
stem(perc_error_log_vector,'Marker','none');
xlabel('Cells');
ylabel('Percent Difference (log)');
title('Lookup Table Comparison- Percent Difference (log scale)');


% add horizontal line at 0.2%
hold on
yline(log(0.002), '-','K_{critical}');

% Label Max
text(find(perc_error_vector == perc_error_max), log(perc_error_max), txt, 'VerticalAlignment', 'cap');

saveas(gcf, append('temp.pdf'))
append_pdfs(pdf_name, append('temp.pdf'))

close all
delete 'temp.pdf'

