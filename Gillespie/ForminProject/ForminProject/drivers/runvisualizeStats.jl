using Revise, ForminProject, Plots

fname1="/Users/katiebogue/MATLAB/GitHub/Data/polymer-c_data/bni1_msb/double.2024.03.12/BSD35.5.radtype20"
fname2 = "/Users/katiebogue/MATLAB/GitHub/Data/polymer-c_data/bni1_msb_16.666actin_real/double.2025.19.02/BSD35.5.radtype20"
fname3 = "/Users/katiebogue/MATLAB/GitHub/Data/polymer-c_data/bni1_msb_40actin/double.2025.24.02/BSD35.5.radtype20"

saveloc="/Users/katiebogue/MATLAB/GitHub/Data/polymer-c_data/polymerstats_compareactinsize"

out1= ForminProject.barvisuals(fname1,"", saveloc)
out2= ForminProject.barvisuals(fname2, "large actin 16.666",saveloc)
out3= ForminProject.barvisuals(fname3, "larger actin 40", saveloc)


# ForminProject.scattervisuals(fname1, "", saveloc)
# ForminProject.scattervisuals(fname2, "large actin 16.666", saveloc)
# ForminProject.scattervisuals(fname3, "larger actin 40", saveloc)

