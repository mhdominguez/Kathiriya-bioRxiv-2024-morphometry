#!/bin/bash


random_roi() {

	# Input image file
	input_image=$1
	
	# Output image file
	output_image=$2
	
	# Get the dimensions of the input image
	image_width=$(identify -format "%w" "$input_image")
	image_height=$(identify -format "%h" "$input_image")
	
	# Set the crop size (120x120)
	crop_width=120
	crop_height=120
	
	# Ensure the random crop coordinates are within bounds
	max_x=$((image_width - crop_width))
	max_y=$((image_height - crop_height))
	
	# Generate random coordinates for the top-left corner of the crop region
	random_x=$((RANDOM % max_x))
	random_y=$((RANDOM % max_y))
	
	# Use ImageMagick's convert command to crop the image
	convert "$input_image" -crop "${crop_width}x${crop_height}+${random_x}+${random_y}" "$output_image"
	
	#echo "Random crop saved to $output_image"


}

# Create a subfolder if it doesn't exist
mkdir -p ../random_gifs

# Get the current directory name
current_dir=$(basename "$PWD")

# Output text file to store the original and random names
output_file="gif_rename_list.txt"

# Clear the output file if it exists from previous runs
#> "$output_file"

# Loop through each .gif file in the current directory
for gif_file in *.gif; do
    # Check if the file exists to avoid errors if no .gif files are found
    if [ -e "$gif_file" ]; then
        # Generate a random 8-character name (letters and numbers)
        random_name=$(cat /dev/urandom | tr -dc 'A-Za-z0-9' | head -c 8)

        # Copy the .gif file to the random_gifs subfolder with the new random name
        #cp "$gif_file" "../random_gifs/$random_name.gif"
        random_roi "$gif_file" "../random_gifs/$random_name.gif"

        # Write the original and random names to the output file
        echo "$current_dir/$gif_file -> $random_name.gif" >> "../random_gifs/$output_file"
    fi
done

echo "Process complete. The list of original and random names has been written to '$output_file'."
