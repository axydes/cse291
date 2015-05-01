function [ cost, grad, pred_prob] = supervised_dnn_cost( theta, ei, data, labels, pred_only)
%SPNETCOSTSLAVE Slave cost function for simple phone net
%   Does all the work of cost / gradient computation

%% default values
po = false;
if exist('pred_only','var')
  po = pred_only;
end;

%% reshape into network
stack = params2stack(theta, ei);
numHidden = numel(ei.layer_sizes) - 1;
hAct = cell(numHidden+1, 1);
gradStack = cell(numHidden+1, 1);
n=size(data,1);


%% forward prop
%%% YOUR CODE HERE %%%
hiddenActivations=sigmoid(data*stack{1,1}.W' + repmat(stack{1,1}.b',n,1));

out=hiddenActivations*stack{2,1}.W';
outBias=repmat(stack{2,1}.b',n,1);
outputs=softmax(out + outBias);
pred_prob=outputs';

%% return here if only predictions desired.
if po
  cost = -1; ceCost = -1; wCost = -1; numCorrect = -1;
  grad = [];  
  return;
end;

%% compute cost
%%% YOUR CODE HERE %%%
cost = softmax_cross_entropy(labels,outputs);

%% compute gradients using backpropagation
%%% YOUR CODE HERE %%%
outDelta = (outputs - labels);
outGrad = outDelta' * hiddenActivations;
gradStack{2,1}.W = outGrad;

gprime=hiddenActivations .* (1-hiddenActivations);
hiddenDelta = outDelta*stack{2,1}.W;
hiddenGrad=(gprime.*hiddenDelta)'*data;
gradStack{1,1}.W = hiddenGrad;

%% compute weight penalty cost and gradient for bias terms
%%% YOUR CODE HERE %%%
outBiasGrad = mean(outDelta);
gradStack{2,1}.b = outBiasGrad';

hiddenBiasGrad = mean(hiddenDelta);
gradStack{1,1}.b = hiddenBiasGrad';

%% reshape gradients into vector
[grad] = stack2params(gradStack);
end



