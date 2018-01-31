import tensorflow as tf
import h5py
import math
import numpy as np

# Read 
dfd_dataset = h5py.File('datasets/dataset.hdf5', "r")
train_data = np.array(dfd_dataset["train_data"][:], dtype = np.float32) # your train set features
train_label = np.array(dfd_dataset["train_label"][:]) # your train set labels

test_data = np.array(dfd_dataset["test_data"][:], dtype = np.float32) # your test set features
test_label = np.array(dfd_dataset["test_label"][:]) # your test set labels

# Reshape data: data.shape: (flattened image, # of examples)
train_data = train_data.reshape(train_data.shape[0],-1).T
test_data = test_data.reshape(test_data.shape[0],-1).T

# Standardize data
train_data = train_data/255.
test_data = test_data/255.

# Hyperparameters
learning_rate = 0.1
num_epochs = 100
batch_size = 64

# Network Parameters
n_hidden_1 = 512 # 1st layer number of neurons
n_hidden_2 = 256 # 2nd layer number of neurons
num_input = train_data.shape[0] # data input (img shape: 20*20*3)
num_classes = 10 #  total classes (0-9 depth labels)
num_examples = train_data.shape[1]
print_cost = True

# Create place holders for data and label
data = tf.placeholder(dtype = tf.float32, shape = [num_input, None])
label = tf.placeholder(dtype = tf.float32, shape = [num_classes, None])

# Initialize weight and bias tensors, stored in a dictionary called parameters
def initialize_parameters():
    W1 = tf.get_variable("W1", [n_hidden_1,num_input], initializer = tf.contrib.layers.xavier_initializer(seed = 1))
    b1 = tf.get_variable("b1", [n_hidden_1,1], initializer = tf.contrib.layers.xavier_initializer(seed = 1))
    W2 = tf.get_variable("W2", [n_hidden_2,n_hidden_1], initializer = tf.contrib.layers.xavier_initializer(seed = 1))
    b2 = tf.get_variable("b2", [n_hidden_2,1], initializer = tf.contrib.layers.xavier_initializer(seed = 1))
    W3 = tf.get_variable("W3", [num_classes,n_hidden_2], initializer = tf.contrib.layers.xavier_initializer(seed = 1))
    b3 = tf.get_variable("b3", [num_classes,1], initializer = tf.contrib.layers.xavier_initializer(seed = 1))

    parameters = {"W1": W1, "b1": b1,
                  "W2": W2, "b2": b2,
                  "W3": W3, "b3": b3}
    
    return parameters

# convert label to one-shot
def convert_to_one_hot(label, num_classes):
    label = np.eye(num_classes)[label.reshape(-1)].T
    return label

# Creates a list of random batches from (data, label)
def random_batches(data, label, batch_size = 64, seed = 0):

    m = data.shape[1]                  # number of training examples
    batches = []
    np.random.seed(seed)

    # Shuffle (X, Y)
    permutation = list(np.random.permutation(m))
    shuffled_data = data[:, permutation]
    shuffled_label = label[:, permutation].reshape((label.shape[0],m))

    # Partition (shuffled_X, shuffled_Y). Minus the end case.
    num_complete_batches = math.floor(m/batch_size) # number of  batches of size batch_size in your partitionning
    for k in range(0, num_complete_batches):
        batch_data = shuffled_data[:, k * batch_size : k * batch_size + batch_size]
        batch_label = shuffled_label[:, k * batch_size : k * batch_size + batch_size]
        batch = (batch_data, batch_label)
        batches.append(batch)
    
    # Handling the end case (last -batch < batch_size)
    if m % batch_size != 0:
        batch_data = shuffled_data[:, num_complete_batches * batch_size : m]
        batch_label = shuffled_label[:, num_complete_batches * batch_size : m]
        batch = (batch_data, batch_label)
        batches.append(batch)
    
    return batches

# Create fully-connected feedforward model
def fully_connected(data, parameters):

    W1 = parameters['W1']
    b1 = parameters['b1']
    W2 = parameters['W2']
    b2 = parameters['b2']
    W3 = parameters['W3']
    b3 = parameters['b3']
    
    # layer 1: Z1 = W1*data + b1, A1 = relu(Z1)
    Z1 = tf.add(tf.matmul(W1, data), b1)
    A1 = tf.nn.relu(Z1)
    # layer 2: Z2 = W2 * A1 + b2, A2 = relu(Z2)
    Z2 = tf.add(tf.matmul(W2, A1), b2)
    A2 = tf.nn.relu(Z2)
    # layer 3: Z = W3 * A2 + b3
    Z = tf.add(tf.matmul(W3, A2), b3)

    return Z

# Compute cost using the output of the fully-connected layer and the label
def compute_cost(Z, Y):    

    logits = tf.transpose(Z)
    labels = tf.transpose(Y)
    
    cost = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(logits = logits, labels = labels))
    
    return cost

# Create one-hot tensors for labels: label.shape : (num_class, # of examples)
train_label = convert_to_one_hot(train_label, num_classes)
test_label = convert_to_one_hot(test_label, num_classes)

# Construct model
parameters = initialize_parameters()
Z = fully_connected(data, parameters)
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
    correct_prediction = tf.equal(tf.argmax(Z), tf.argmax(label))

    # Calculate accuracy on the test set
    accuracy = tf.reduce_mean(tf.cast(correct_prediction, "float"))

    print ("Train Accuracy:", accuracy.eval({data: train_data, label: train_label}))
    print ("Test Accuracy:", accuracy.eval({data: test_data, label: test_label}))