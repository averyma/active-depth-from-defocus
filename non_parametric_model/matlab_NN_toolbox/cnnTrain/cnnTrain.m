%%
clc
clear
close all

%%
root_dir = 'F:\DfD\ScreenCap\20170811ScreenCap\r\r_train234_raw_415to500\';
net_name = 'convnet_r_train234_raw_415to500';
digitData = imageDatastore(root_dir,'IncludeSubfolders',true,'FileExtensions','.png','LabelSource','foldernames')

minSetCount = min(digitData.countEachLabel{:,2})

trainingNumFiles = round(minSetCount*1);
rng(1) % For reproducibility
[trainDigitData,testDigitData] = splitEachLabel(digitData,...
				trainingNumFiles,'randomize');
            
layers = [imageInputLayer([20 20 1])
     convolution2dLayer(5,20)
	 reluLayer()
     convolution2dLayer(5,20)
	 reluLayer()
     convolution2dLayer(5,20)
	 reluLayer()
     fullyConnectedLayer(18)
     reluLayer()
	 softmaxLayer()
	 classificationLayer()];
 
options = trainingOptions('sgdm','MaxEpochs',100,...
	'InitialLearnRate',0.001,...
    'MiniBatchSize',300,...
    'ExecutionEnvironment','gpu',...
    'OutputFcn',@plotTrainingAccuracy);

convnet = trainNetwork(trainDigitData,layers,options);
save([root_dir net_name '.mat'],'convnet')

%%
root_dir = 'F:\DfD\ScreenCap\20170811ScreenCap\r\r_train234_raw_42to50\';
net_name = 'convnet_r_train234_raw_42to50';
digitData = imageDatastore(root_dir,'IncludeSubfolders',true,'FileExtensions','.png','LabelSource','foldernames')

minSetCount = min(digitData.countEachLabel{:,2})

trainingNumFiles = round(minSetCount*1);
rng(1) % For reproducibility
[trainDigitData,testDigitData] = splitEachLabel(digitData,...
				trainingNumFiles,'randomize');
            
layers = [imageInputLayer([20 20 1])
     convolution2dLayer(5,20)
	 reluLayer()
     convolution2dLayer(5,20)
	 reluLayer()
     convolution2dLayer(5,20)
	 reluLayer()
     fullyConnectedLayer(9)
     reluLayer()
	 softmaxLayer()
	 classificationLayer()];
 
options = trainingOptions('sgdm','MaxEpochs',100,...
	'InitialLearnRate',0.001,...
    'MiniBatchSize',300,...
    'ExecutionEnvironment','gpu',...
    'OutputFcn',@plotTrainingAccuracy);

convnet = trainNetwork(trainDigitData,layers,options);
save([root_dir net_name '.mat'],'convnet')


%%
root_dir = 'F:\DfD\ScreenCap\20170811ScreenCap\b\b_train234_raw_42to50\';
net_name = 'convnet_b_train234_raw_42to50';
digitData = imageDatastore(root_dir,'IncludeSubfolders',true,'FileExtensions','.png','LabelSource','foldernames')

minSetCount = min(digitData.countEachLabel{:,2})

trainingNumFiles = round(minSetCount*1);
rng(1) % For reproducibility
[trainDigitData,testDigitData] = splitEachLabel(digitData,...
				trainingNumFiles,'randomize');
            
layers = [imageInputLayer([20 20 1])
     convolution2dLayer(5,20)
	 reluLayer()
     convolution2dLayer(5,20)
	 reluLayer()
     convolution2dLayer(5,20)
	 reluLayer()
     fullyConnectedLayer(9)
     reluLayer()
	 softmaxLayer()
	 classificationLayer()];
 
options = trainingOptions('sgdm','MaxEpochs',100,...
	'InitialLearnRate',0.001,...
    'MiniBatchSize',300,...
    'ExecutionEnvironment','gpu',...
    'OutputFcn',@plotTrainingAccuracy);

convnet = trainNetwork(trainDigitData,layers,options);
save([root_dir net_name '.mat'],'convnet')
