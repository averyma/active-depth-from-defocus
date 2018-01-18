import tensorflow as tf
import numpy as np

# dfd_data dir
root_dir = '/Users/ama/git-repo/active-depth-from-defocus/non_parametric_model/DfD_tf/'
filenames = tf.constant([(root_dir + "%d/%d.png" % (i,j)) for i in range(36,46) for j in range(1,201)])

# create image parser
def input_parser(img_path, label):
    # convert the label to one-hot encoding
    one_hot = tf.one_hot(label, NUM_CLASSES)

    # read the img from file
    img_file = tf.read_file(img_path)
    img_decoded = tf.image.decode_image(img_file, channels=3)

    return img_decoded, one_hot

# create labels
NUM_IMAGES = 200
NUM_CLASSES = 10
label = tf.concat([tf.zeros(NUM_IMAGES,tf.int32),
					tf.multiply(tf.ones(NUM_IMAGES,tf.int32),1),
					tf.multiply(tf.ones(NUM_IMAGES,tf.int32),2),
					tf.multiply(tf.ones(NUM_IMAGES,tf.int32),3),
					tf.multiply(tf.ones(NUM_IMAGES,tf.int32),4),
					tf.multiply(tf.ones(NUM_IMAGES,tf.int32),5),
					tf.multiply(tf.ones(NUM_IMAGES,tf.int32),6),
					tf.multiply(tf.ones(NUM_IMAGES,tf.int32),7),
					tf.multiply(tf.ones(NUM_IMAGES,tf.int32),8),
					tf.multiply(tf.ones(NUM_IMAGES,tf.int32),9)],0)

# create TensorFlow Dataset object
dfd_data = tf.data.Dataset.from_tensor_slices((filenames,label))
dfd_data = dfd_data.map(input_parser)

# create TensorFlow Iterator object
iterator = tf.data.Iterator.from_structure(dfd_data.output_types,
								   dfd_data.output_shapes)
next_element = iterator.get_next()

# create two initialization ops to switch between the datasets
init_op = iterator.make_initializer(dfd_data)


with tf.Session() as sess:
	#initialize the iterator on the data
	sess.run(init_op)
	# get each element of the dataset until the end is reached
	while True:
		try:
			elem = sess.run(next_element)
			# print(elem)
		except tf.errors.OutOfRangeError:
			print("End of dataset.")
			break