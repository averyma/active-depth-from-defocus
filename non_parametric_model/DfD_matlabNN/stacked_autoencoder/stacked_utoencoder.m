%% load captured images and create input/target variable
train_dir = ['C:\Users\avery\Desktop\DfD\20170412ScreenCap\r\train234_test1\train234\'];

numb_dot = 9651;
inputs = zeros(400,numb_dot*20);
targets = zeros(20,numb_dot*20);

for i =1:20
   folder = [train_dir num2str(380+(i-1)*5) '\'];
   patches = dir([folder '*.png']); 
   for j = 1:numb_dot
       img = im2double(imread([folder patches(j).name]));
       inputs(:,(i-1)*numb_dot+j) = reshape(img',[400,1]);
       ((i-1)*numb_dot+j)/(numb_dot*20)*100
       targets(i,(i-1)*numb_dot+j) = 1;
   end
end

hiddenSize1 = 100;

autoenc1 = trainAutoencoder(inputs,hiddenSize1, ...
    'MaxEpochs',400, ...
    'L2WeightRegularization',0.004, ...
    'SparsityRegularization',4, ...
    'SparsityProportion',0.15, ...
    'ScaleData', false);

feat1 = encode(autoenc1,inputs);

hiddenSize2 = 50;
autoenc2 = trainAutoencoder(feat1,hiddenSize2, ...
    'MaxEpochs',100, ...
    'L2WeightRegularization',0.002, ...
    'SparsityRegularization',4, ...
    'SparsityProportion',0.1, ...
    'ScaleData', false);

feat2 = encode(autoenc2,feat1);
softnet = trainSoftmaxLayer(feat2,inputs,'MaxEpochs',400);

deepnet = stack(autoenc1,autoenc2,softnet);