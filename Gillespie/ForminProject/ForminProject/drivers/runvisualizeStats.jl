using ForminProject

fname="/Users/katiebogue/MATLAB/GitHub/Data/polymer-c_data/bni1_msb/double.2024.03.12/BSD35.5.radtype20"

outDict=ForminProject.makeOutputDict(fname)

data_matrix1, x1, y1, z1=ForminProject.visualizeStats(outDict, "Prvec0")
data_matrix2, x2, y2, z2=ForminProject.visualizeStats(outDict, "POcclude")