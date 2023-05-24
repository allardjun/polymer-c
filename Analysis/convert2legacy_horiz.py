# convert output from vertical format to legacy horizontal format

def extract_last_entries(input_file, output_file):
    try:
        with open(input_file, 'r') as file:
            entries = [line.strip().split()[-1] for line in file]

        with open(output_file, 'w') as file:
            file.write(' '.join(entries))

        print(f"Successfully created {output_file} with last entries.")
    except FileNotFoundError:
        print(f"Input file '{input_file}' not found.")
    except Exception as e:
        print(f"An error occurred: {e}")


# Usage example
input_file_path = '../src/PolymerCode/outputTest2.txt'
output_file_path = 'legacy_output.txt'
extract_last_entries(input_file_path, output_file_path)
