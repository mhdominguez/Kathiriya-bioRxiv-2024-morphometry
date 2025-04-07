import cv2
import numpy as np
import matplotlib.pyplot as plt
from skimage.measure import label, regionprops
from skimage import io, morphology
from skimage.segmentation import watershed
from scipy.ndimage import distance_transform_edt
import os
import sys

# Get the input image path from the command line
if len(sys.argv) != 2:
    print("Usage: python script.py <image_path>")
    sys.exit(1)

image_path = sys.argv[1]
output_base = os.path.splitext(os.path.basename(image_path))[0]

# Load the image
image = io.imread(image_path)

# Convert to grayscale (if not already)
gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY) if len(image.shape) == 3 else image

# Threshold the image to create a binary mask
_, binary_mask = cv2.threshold(gray_image, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU )

# Perform distance transform
distance = distance_transform_edt(binary_mask)

# Apply Gaussian smoothing to the distance map
smoothed_distance = cv2.GaussianBlur(distance, (5, 5), 0)

# Identify peaks in the distance map
#local_max = morphology.local_maxima(distance)
local_max = morphology.local_maxima(smoothed_distance)
markers = label(local_max)

# Perform watershed segmentation
segmented_image = watershed(-distance, markers, mask=binary_mask)

# Measure properties of the labeled regions
regions = regionprops(segmented_image)

# Initialize list to store area values
areas = []
orientations = []
regions_measured = []

# Fit ellipses and append area to growing list
for region in regions:
    if region.area >= 200 and region.area < 50000:  # Filter out small regions
        # Extract region properties
        y0, x0 = region.centroid
        orientation = region.orientation
        minor_axis_length = region.minor_axis_length
        major_axis_length = region.major_axis_length

        if major_axis_length > 0:
            # Calculate area
            areas.append(region.area)
            regions_measured.append(region)
        
        if not np.isnan(orientation):
            orientations.append(orientation)

# Calculate total pixel count and nuclei density
image_pixel_count = gray_image.shape[0] * gray_image.shape[1]
nuclei_per_kilopixel = (len(areas) / image_pixel_count) * 1000

# Visualize binary mask and segmented image
plt.figure(figsize=(15, 7))

# Original grayscale image
plt.subplot(1, 3, 1)
plt.title("Original Grayscale Image")
plt.imshow(gray_image, cmap='gray')
plt.axis('off')

# Binary mask
plt.subplot(1, 3, 2)
plt.title("Binary Mask")
plt.imshow(binary_mask, cmap='gray')
plt.axis('off')

# Segmented image with areas overlaid
plt.subplot(1, 3, 3)
plt.title("Segmented Image with Area")
plt.imshow(segmented_image, cmap='nipy_spectral')
for region, area in zip(regions_measured, areas):
    if region.area >= 200 and region.area < 50000:
        y0, x0 = region.centroid
        plt.text(x0, y0, f"{area:.0f}", color="white", fontsize=6, ha='center', va='center')
plt.axis('off')

plt.tight_layout()
plt.savefig(f"{output_base}_segmentation.png")
plt.close()

# Plot the results
plt.figure(figsize=(10, 5))
plt.hist(areas, bins=20, color='blue', alpha=0.7)
plt.title('Distribution of Nuclei Areas')
plt.xlabel('Nucleus Area')
plt.ylabel('Frequency')
plt.savefig(f"{output_base}_area_histogram.png")
plt.close()

# Write summary to a text file
with open(f"{output_base}_summary.txt", "w") as summary_file:
    summary_file.write(f"{len(areas)},{nuclei_per_kilopixel:.4f},{np.mean(areas):.4f},{np.mean(orientations):.4f}\n")

print(f"Outputs saved as {output_base}_segmentation.png, {output_base}_area_histogram.png, and {output_base}_summary.txt.")
 
