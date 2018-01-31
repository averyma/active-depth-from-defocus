import tensorflow as tf
import h5py
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

# Training Parameters
learning_rate = 0.001
num_epochs = 100
batch_size = 64

# Network Parameters
conv1_filter = 32 # 1st layer number of filters
conv1_kernel_size = 5 # 1st layer kernel size
conv2_filter = 64 # 2st layer number of filters
conv2_kernel_size = 5 # 2st layer kernel size
conv3_filter = 128 # 3st layer number of filters
conv3_kernel_size = 5 # 3st layer kernel size
dropout = 0.25
num_classes = 10 #  total classes (10 depth labels)
num_examples = train_data.shape[0]
n_H = train_data.shape[1]
n_W = train_data.shape[2]
n_C = train_data.shape[3]
print_cost = True

# Create the neural network
def convnet(x_dict, n_classes, dropout, reuse, is_training):
    
    # Define a scope for reusing the variables
    with tf.variable_scope('ConvNet', reuse=reuse):
        # TF Estimator input is a dict, in case of multiple inputs
        x = x_dict['images']

        # layer 1:
        Z1 = tf.layers.conv2d(x, conv1_filter, conv1_kernel_size, activation=tf.nn.relu)
        # Z1 = tf.layers.max_pooling2d(Z1, 2, 2)

        # layer 2:
        Z2 = tf.layers.conv2d(Z1, conv2_filter, conv2_kernel_size, activation=tf.nn.relu)
        # Z2 = tf.layers.max_pooling2d(Z2, 2, 2)

        # layer 3:
        Z3 = tf.layers.conv2d(Z2, conv3_filter, conv3_kernel_size, activation=tf.nn.relu)
        # Z3 = tf.layers.max_pooling2d(Z3, 2, 2)

        # Flatten the data to a 1-D vector for the fully connected layer
        FC1 = tf.contrib.layers.flatten(Z3)

        # Fully connected layer 
        FC1 = tf.layers.dense(FC1, 1024)

        # Apply Dropout
        D = tf.layers.dropout(FC1, rate=dropout, training=is_training)

        # Output layer, class prediction
        Z = tf.layers.dense(D, n_classes)

    return Z


# Define the model function (following TF Estimator Template)
def model_fn(features, labels, mode):
    # Build the neural network
    # Because Dropout have different behavior at training and prediction time, we
    # need to create 2 distinct computation graphs that still share the same weights.
    logits_train = convnet(features, num_classes, dropout, reuse=False,
                            is_training=True)
    logits_test = convnet(features, num_classes, dropout, reuse=True,
                           is_training=False)

    # Predictions
    pred_classes = tf.argmax(logits_test, axis=1)
    pred_probas = tf.nn.softmax(logits_test)

    # If prediction mode, early return
    if mode == tf.estimator.ModeKeys.PREDICT:
        return tf.estimator.EstimatorSpec(mode, predictions=pred_classes)

    # Define loss and optimizer
    loss_op = tf.reduce_mean(tf.nn.sparse_softmax_cross_entropy_with_logits(
        logits=logits_train, labels=tf.cast(labels, dtype=tf.int32)))
    optimizer = tf.train.AdamOptimizer(learning_rate=learning_rate)
    train_op = optimizer.minimize(loss_op,
                                  global_step=tf.train.get_global_step())

    # Evaluate the accuracy of the model
    acc_op = tf.metrics.accuracy(labels=labels, predictions=pred_classes)

    # TF Estimators requires to return a EstimatorSpec, that specify
    # the different ops for training, evaluating, ...
    estim_specs = tf.estimator.EstimatorSpec(
        mode=mode,
        predictions=pred_classes,
        loss=loss_op,
        train_op=train_op,
        eval_metric_ops={'accuracy': acc_op})

    return estim_specs

# Build the Estimator
model = tf.estimator.Estimator(model_fn)

# Define the input function for training
input_fn = tf.estimator.inputs.numpy_input_fn(
    x={'images': train_data}, y=train_label,
    batch_size=batch_size, num_epochs=None, shuffle=True)
# Train the Model
model.train(input_fn, steps=num_epochs)

# Evaluate the Model
# Define the input function for evaluating
input_fn = tf.estimator.inputs.numpy_input_fn(
    x={'images': test_data}, y=test_label,
    batch_size=batch_size, shuffle=False)
# Use the Estimator 'evaluate' method
e = model.evaluate(input_fn)

print("Testing Accuracy:", e['accuracy'])