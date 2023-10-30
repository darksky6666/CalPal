import os

# Define the path to your dataset directory
data_dir = './dataset'  # Replace with your dataset directory

# List subfolders (class labels) in the dataset directory
class_labels = sorted(os.listdir(data_dir))

# Define the path to the tflitelabels.txt file
labels_file_path = 'tflitelabels.txt'

# Write class labels to the tflitelabels.txt file
with open(labels_file_path, 'w') as labels_file:
    labels_file.write("\n".join(class_labels))

print("tflitelabels.txt file has been created with class labels from the dataset.")
