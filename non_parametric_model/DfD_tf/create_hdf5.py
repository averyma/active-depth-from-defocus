from random import shuffle
import glob
import numpy as np
import h5py
import cv2

#### Load iamges and create labels ####
# shuffle the addresses before saving
shuffle_data = True  
# address to where you want to save the hdf5 file
hdf5_path = 'datasets/dataset.hdf5'  

# initialize two empty arrays to store img path and their corresponding labels
img_path = []
labels = []

for depth in range(36,46):
	# read addresses and labels from the folder
	curr_dir = 'images/' + str(depth) + '/*.png'
	curr_addrs = glob.glob(curr_dir)

	# create current label
	curr_labels = np.ones(len(curr_addrs)) * (depth - 36)
	
	# extend to the end of the list
	img_path.extend(curr_addrs)
	labels.extend(curr_labels)

# to shuffle data
if shuffle_data:
    c = list(zip(img_path, labels))
    shuffle(c)
    img_path, labels = zip(*c)

# Divide the hata into 70% train, 30% test
train_path = img_path[0:int(0.7*len(img_path))]
train_labels = labels[0:int(0.7*len(labels))]
test_path = img_path[int(0.7*len(img_path)):]
test_labels = labels[int(0.7*len(labels)):]


#### Create HDF5 file ####
train_shape = (len(train_path), 20, 20, 3)
test_shape = (len(test_path), 20, 20, 3)

# open a hdf5 file and create earrays
hdf5_file = h5py.File(hdf5_path, mode = 'w')
hdf5_file.create_dataset("train_img", train_shape, np.int8)
hdf5_file.create_dataset("test_img", test_shape, np.int8)
hdf5_file.create_dataset("train_mean", train_shape[1:], np.float32)

hdf5_file.create_dataset("train_labels", (len(train_path),), np.int8)
hdf5_file["train_labels"][...] = train_labels
hdf5_file.create_dataset("test_labels", (len(test_path),), np.int8)
hdf5_file["test_labels"][...] = test_labels


#### load/save images ####
# a numpy array to save the mean of the images
mean = np.zeros(train_shape[1:], np.float32)
# loop over train addresses
for i in range(len(train_path)):
    # print how many images are saved every 1000 images
    if i % 1000 == 0 and i > 1:
        print 'Train data: {}/{}'.format(i, len(train_path))
    # read an image and resize to (224, 224)
    # cv2 load images as BGR, convert it to RGB
    curr_path = train_path[i]
    img = cv2.imread(curr_path)
    # img = cv2.resize(img, (20, 20), interpolation=cv2.INTER_CUBIC)
    # img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    # add any image pre-processing here
    # save the image and calculate the mean so far
    hdf5_file["train_img"][i, ...] = img[None]
    mean += img / float(len(train_labels))
# loop over test addresses
for i in range(len(test_path)):
    # print how many images are saved every 1000 images
    if i % 1000 == 0 and i > 1:
        print 'Test data: {}/{}'.format(i, len(test_path))
    # read an image and resize to (224, 224)
    # cv2 load images as BGR, convert it to RGB
    curr_path = test_path[i]
    img = cv2.imread(curr_path)
    # img = cv2.resize(img, (20, 20), interpolation=cv2.INTER_CUBIC)
    # img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    # add any image pre-processing here
    # save the image
    hdf5_file["test_img"][i, ...] = img[None]
# save the mean and close the hdf5 file
hdf5_file["train_mean"][...] = mean
hdf5_file.close()