close; clear all; clc;

load('fashion_mnist.mat');

X_train = im2double(X_train);
X_test = im2double(X_test);

X_train = reshape(X_train, [60000 28 28 1]);
X_train = permute(X_train, [2 3 4 1]);

X_test = reshape(X_test, [10000 28 28 1]);
X_test = permute(X_test, [2 3 4 1]);

X_valid = X_train(:,:,:,1:5000);
X_train = X_train(:,:,:,5001:end);

y_valid = categorical(y_train(1:5000))';
y_train = categorical(y_train(5001:end))';
y_test = categorical(y_test)';

%%
layers = [imageInputLayer([28 28 1])
    fullyConnectedLayer(100)
    reluLayer
    fullyConnectedLayer(80)
    reluLayer
    fullyConnectedLayer(50)
    reluLayer
    fullyConnectedLayer(20)
    reluLayer
    fullyConnectedLayer(10)
    softmaxLayer
    classificationLayer];

options = trainingOptions('adam',...
    'MaxEpochs',4,...
    'InitialLearnRate', 1.4e-3,...
    'L2Regularization', 5e-4,...
    'ValidationData', {X_valid, y_valid},...
    'Verbose',false,...
    'Plots','training-progress')

net = trainNetwork(X_train, y_train, layers ,options);

%%
%convolutional
layers = [
    imageInputLayer([28 28 1],"Name","imageinput")
    convolution2dLayer([5 5],6,"Name","conv_1","Padding","same")
    tanhLayer("Name","tanh_1")
    averagePooling2dLayer([3 3],"Name","avgpool2d_1","Padding","same","Stride",[2 2])
    convolution2dLayer([5 5],16,"Name","conv_2")
    tanhLayer("Name","tanh_2")
    averagePooling2dLayer([2 2],"Name","avgpool2d_2","Padding","same","Stride",[2 2])
    convolution2dLayer([5 5],120,"Name","conv_3")
    tanhLayer("Name","tanh_3")
    fullyConnectedLayer(84,"Name","fc_1")
    tanhLayer("Name","tanh_4")
    fullyConnectedLayer(10,"Name","fc_2")
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")];

options = trainingOptions('adam',...
    'MaxEpochs',5,...
    'InitialLearnRate', 1.4e-3,...
    'L2Regularization', 5e-4,...
    'ValidationData', {X_valid, y_valid},...
    'Verbose',false,...
    'Plots','training-progress')

net = trainNetwork(X_train, y_train, layers ,options);

%%
y_pred = classify(net,X_test);
figure(3)
plotconfusion(y_test,y_pred);
title("CNN, test data confustion matrix")


