%%
clc
clear
close all

for p = 1:1
    if p== 1
        pattern = '1x1';
    elseif p == 2
        pattern = '3x3';
    elseif p == 3
        pattern = '3x3cross';
    elseif p == 4
        pattern = 'triangle';
    else
        pattern = 'x';
    end
    
    for c = 2:2
        if c == 1
            root_dir = ['F:\DfD\ScreenCap\20170816ScreenCap\' pattern '\r\r_train234_ff\'];
            net_name = 'convnet_r_train234_ff';
        else
            root_dir = ['F:\DfD\ScreenCap\20170816ScreenCap\' pattern '\b\b_train234_ff\'];
            net_name = 'convnet_b_train234_ff';
        end

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
             fullyConnectedLayer(10)
             reluLayer()
             softmaxLayer()
             classificationLayer()];

        options = trainingOptions('sgdm','MaxEpochs',30,...
            'InitialLearnRate',0.001,...
            'MiniBatchSize',300,...
            'ExecutionEnvironment','gpu',...
            'OutputFcn',@plotTrainingAccuracy);
        
        convnet = trainNetwork(trainDigitData,layers,options);
        save([root_dir net_name '.mat'],'convnet')
    end
end