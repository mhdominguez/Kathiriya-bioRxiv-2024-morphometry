import sys
import pandas as pd
import numpy as np

# Get the input image path from the command line
if len(sys.argv) != 2:
    print("Usage: python script.py <csv_path>")
    sys.exit(1)

csv_path = sys.argv[1]
#output_base = os.path.splitext(os.path.basename(image_path))[0]

# Load the CSV file
df = pd.read_csv(csv_path)

# Convert the 'Length' column to numeric, and do not drop any NaN values
lengths = pd.to_numeric(df['Length'], errors='coerce').values
group_input = df['Group']

# Initialize lists to store results
major_axis_lengths = []
eccentricities = []
areas = []
groups = []

# Process each pair of odd and even rows
for i in range(0, len(lengths), 2):
    if not group_input[i] == group_input[i+1]:
        continue

    if np.isnan(lengths[i]):
        continue
        
    major_axis = max(lengths[i], lengths[i + 1])  # Major axis is the longer length
    minor_axis = min(lengths[i], lengths[i + 1])  # Minor axis is the shorter length
    
    # Calculate eccentricity (using major and minor axes)
    eccentricity = np.sqrt(1 - (minor_axis ** 2 / major_axis ** 2))
    
    # Calculate area of the ellipse
    area = np.pi * major_axis * minor_axis
    
    # Append results to lists
    major_axis_lengths.append(major_axis)
    eccentricities.append(eccentricity)
    areas.append(area)
    groups.append(group_input[i])

# Create a new DataFrame with the results
results_df = pd.DataFrame({
    'Group': groups,    
    'Major Axis Length': major_axis_lengths,
    'Eccentricity': eccentricities,
    'Area': areas
})

# Write results to a new CSV file
results_df.to_csv("processed_ellipses.csv", index=False)

print("Processing complete. Results saved to 'processed_ellipses.csv'") 
