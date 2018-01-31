import tensorflow as tf
import h5py
import math
import numpy as np

# Read 
dfd_dataset = h5py.File('datasets/dataset.hdf5', "r")
train_data = np.array(dfd_dataset["train_data"][:], dtype = np.float32)
train_label = np.array(dfd_dataset["train_label"][:])

test_data = np.array(dfd_dataset["test_data"][:], dtype = np.float32)
test_label = np.array(dfd_dataset["test_label"][:])

# Standardize data
train_data = train_data/255.
test_data = test_data/255.

# Hyperparameters
learning_rate = 0.001
num_epochs = 10
batch_size = 64

# Network Parameters
conv1_filter = 32 # 1st layer number of filters
conv1_kernel_size = 5 # 1st layer kernel size
conv2_filter = 64 # 2st layer number of filters
conv2_kernel_size = 5 # 2st layer kernel size
conv3_filter = 128 # 3st layer number of filters
conv3_kernel_size = 5 # 3st layer kernel size
dropout = 0.25
num_classes = 10 #  total classes (0-9 depth labels)
num_examples = train_data.shape[0]
n_H = train_data.shape[1]
n_W = train_data.shape[2]
n_C = train_data.shape[3]
print_cost = True

# Create place holders for data and label
data = tf.placeholder(dtype = tf.float32, shape = [None, n_H, n_W, n_C])
label = tf.placeholder(dtype = tf.float32, shape = [None, num_classes])

# Initialize weight and bias tensors, stored in a dictionary called parameters
def initialize_parameters():

    W1 = tf.get_variable("W1", [conv1_kernel_size, 
                                conv1_kernel_size, 
                                n_C,
                                conv1_filter], 
                                initializer = tf.contrib.layers.xavier_initializer(seed = 1))
    W2 = tf.get_variable("W2", [conv2_kernel_size, 
                                conv2_kernel_size, 
                                conv1_filter,
                                conv2_filter], 
                                initializer = tf.contrib.layers.xavier_initializer(seed = 1))
    W3 = tf.get_variable("W3", [conv3_kernel_size, 
                                conv3_kernel_size, 
                                conv2_filter,
                                conv3_filter], 
                                initializer = tf.contrib.layers.xavier_initializer(seed = 1))

    parameters = {"W1": W1,
                  "W2": W2,
                  "W3": W3}
    
    return parameters

# convert label to one-shot
def convert_to_one_hot(label, num_classes):

    label = np.eye(num_classes)[label.reshape(-1)].T
    return label

# Creates a list of random batches from (data, label)
def random_batches(data, label, batch_size = 64, seed = 0):

    m = data.shape[0]                  # number of training examples
    batches = []
    np.random.seed(seed)
    
    # Step 1: Shuffle (X, Y)
    permutation = list(np.random.permutation(m))
    shuffled_data = data[permutation,:,:,:]
    shuffled_label = label[permutation,:]

    # Step 2: Partition (shuffled_X, shuffled_Y). Minus the end case.
    num_complete_batches = math.floor(m/batch_size) # number of mini batches of size mini_batch_size in your partitionning
    for k in range(0, num_complete_batches):
        batch_data = shuffled_data[k * batch_size : k * batch_size + batch_size,:,:,:]
        batch_label = shuffled_label[k * batch_size : k * batch_size + batch_size,:]
        batch = (batch_data, batch_label)
        batches.append(batch)
    
    # Handling the end case (last mini-batch < mini_batch_size)
    if m % batch_size != 0:
        batch_data = shuffled_data[num_complete_batches * batch_size : m,:,:,:]
        batch_label = shuffled_label[num_complete_batches * batch_size : m,:]
        batch = (batch_data, batch_label)
        batches.append(batch)
    
    return batches

# Create fully-connected feedforward model
def convnet(data, parameters):

    W1 = parameters['W1']
    W2 = parameters['W2']
    W3 = parameters['W3']
    
    # layer 1:
    Z1 = tf.nn.conv2d(data, W1, strides = [1,1,1,1], padding = 'SAME')
    A1 = tf.nn.relu(Z1)
    # layer 2: 
    Z2 = tf.nn.conv2d(A1, W2, strides = [1,1,1,1], padding = 'SAME')
    A2 = tf.nn.relu(Z2)
    # layer 3:
    Z3 = tf.nn.conv2d(A2, W3, strides = [1,1,1,1], padding = 'SAME')
    A3 = tf.nn.relu(Z3)
    # Flatten the data to a 1-D vector for the fully connected layer
    FC1 = tf.contrib.layers.flatten(A3)
    # Fully connected layer
    FC1 = tf.layers.dense(FC1, 1024)
    # Apply dropout
    D = tf.layers.dropout(FC1, rate=dropout)
    # Output layer, class prediction
    Z = tf.layers.dense(D, num_classes)

    return Z

# Compute cost using the output of the fully-connected layer and the label
def compute_cost(Z, label):    

    cost = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(logits = Z, labels = label))
    
    return cost

# Create one-hot tensors for labels: label.shape : (# of examples, num_class)
train_label = convert_to_one_hot(train_label, num_classes).T
test_label = convert_to_one_hot(test_label, num_classes).T

# Construct model
parameters = initialize_parameters()
Z = convnet(data, parameters)
cost = compute_cost(Z, label)
optimizer = tf.train.AdamOptimizer(learning_rate = learning_rate).minimize(cost)

# Initialize all the variables
init = tf.global_variables_initializer()

# Start the session
with tf.Session() as sess:
        
    # Run the initialization
    sess.run(init)

    # Do the training loop
    for epoch in range(num_epochs):

        epoch_cost = 0.
        num_batches = int(num_examples / batch_size)
        batches = random_batches(train_data, train_label, batch_size, seed = epoch)

        for batch in batches:

            # Select a batch
            (batch_data, batch_label) = batch
            
            _ , batch_cost = sess.run([optimizer, cost], feed_dict={data: batch_data, label: batch_label})
            epoch_cost += batch_cost / num_batches

        # Print the cost every epoch
        if print_cost == True and epoch % 1 == 0:
            print ("Cost after epoch %i: %f" % (epoch, epoch_cost))

    # Calculate the correct predictions
    correct_prediction = tf.equal(tf.argmax(Z,1), tf.argmax(label,1))

    # Calculate accuracy on the test set
    accuracy = tf.reduce_mean(tf.cast(correct_prediction, "float"))

    print ("Train Accuracy:", accuracy.eval({data: train_data, label: train_label}))
    print ("Test Accuracy:", accuracy.eval({data: test_data, label: test_label}))