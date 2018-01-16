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

%% create network
net_arch = [20 20 20 20 20];
net5 = patternnet(net_arch); % feedforward with tansig for output layer
% net = feedforward(net_arch); % standard feedforward with pureln for output layer
% net = cascadeforwardnet(net_arch);


%% set up training, validation, testing ratio
net5.divideParam.trainRatio = 70/100;
net5.divideParam.valRatio = 15/100;
net5.divideParam.testRatio = 15/100;

%% Train the Network
[net5,tr] = train(net5,inputs,targets);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% create network
% net_arch = [10 10 10 10 10];
% net1 = patternnet(net_arch); % feedforward with tansig for output layer
% net1.divideParam.trainRatio = 70/100;
% net1.divideParam.valRatio = 15/100;
% net1.divideParam.testRatio = 15/100;
% [net1,tr] = train(net1,inputs,targets);
% 
% net_arch = [30 30 30 30 30];
% net2 = patternnet(net_arch); % feedforward with tansig for output layer
% net2.divideParam.trainRatio = 70/100;
% net2.divideParam.valRatio = 15/100;
% net2.divideParam.testRatio = 15/100;
% [net2,tr] = train(net2,inputs,targets);
% 
% net_arch = [20 20 20];
% net3 = patternnet(net_arch); % feedforward with tansig for output layer
% net3.divideParam.trainRatio = 70/100;
% net3.divideParam.valRatio = 15/100;
% net3.divideParam.testRatio = 15/100;
% [net3,tr] = train(net3,inputs,targets);
% 
% net_arch = [20 20 20 20];
% net4 = patternnet(net_arch); % feedforward with tansig for output layer
% net4.divideParam.trainRatio = 70/100;
% net4.divideParam.valRatio = 15/100;
% net4.divideParam.testRatio = 15/100;
% [net4,tr] = train(net4,inputs,targets);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Test the Network
outputs = net(inputs);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs);

%% View the Network
view(net)
