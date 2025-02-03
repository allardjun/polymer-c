using Printf

# Function to run the shell script with given arguments
function runGillespieOnFolder(folder_name::String, num1::Float64, num2::Float64)
    # Path to the shell script
    script_path = "/Users/katiebogue/MATLAB/GitHub/polymer-c/Gillespie/ForminProject/runGillespieOnFolder.sh"
    
    # Construct the command as a string
    command = `bash $script_path $folder_name $num1 $num2`
    
    # Run the command
    run(command)
end