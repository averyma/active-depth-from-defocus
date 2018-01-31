import tensorflow as tf
import h5py
import numpy as np

# Read 
dfd_dataset = h5py.File('datasets/dataset.hdf5', "r")
train_data = np.array(dfd_dataset["train_data"][:], dtype = np.float32) # your train set features
train_label = np.array(dfd_dataset["train_label"][:]) # your train set labels

test_data = np.array(dfd_dataset["test_data"][:], dtype = np.float32) # your test set features
test_label = np.array(dfd_dataset["test_label"][:]) # your test set labels

# Reshape data
train_data = train_data.reshape(train_data.shape[0],-1)
test_data = test_data.reshape(test_data.shape[0],-1)

# Standardize data
train_data = train_data/255.
test_data = test_data/255.

# Parameters
learning_rate = 0.01
num_epochs = 10
batch_size = 64

# Network Parameters
n_hidden_1 = 512 # 1st layer number of neurons
n_hidden_2 = 256 # 2nd layer number of neurons
num_input = train_data.shape[1] # data input (img shape: 20*20*3)
num_classes = 10 #  total classes (10 depth labels)

# Define the neural network
def fully_connected(x_dict):
    # TF Estimator input is a dict, in case of multiple inputs
    x = x_dict['images']
    # Hidden fully connected layer1
    layer_1 = tf.layers.dense(x, n_hidden_1)
    # Hidden fully connected layer2
    layer_2 = tf.layers.dense(layer_1, n_hidden_2)
    # Output fully connected layer with a neuron for each class
    out_layer = tf.layers.dense(layer_2, num_classes)
    return out_layer

# Define the model function (following TF Estimator Template)
def model_fn(features, labels, mode):
    # Build the neural network
    logits = fully_connected(features)

    # Predictions
    pred_classes = tf.argmax(logits, axis=1)
    pred_probas = tf.nn.softmax(logits)

    # If prediction mode, early return
    if mode == tf.estimator.ModeKeys.PREDICT:
        return tf.estimator.EstimatorSpec(mode, predictions=pred_classes)

        # Define loss and optimizer
    loss_op = tf.reduce_mean(tf.nn.sparse_softmax_cross_entropy_with_logits(
        logits=logits, labels=tf.cast(labels, dtype=tf.int32)))
    optimizer = tf.train.GradientDescentOptimizer(learning_rate=learning_rate)
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