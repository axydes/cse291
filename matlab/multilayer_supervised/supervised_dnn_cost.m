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
outLayer=numel(ei.layer_sizes);
hAct = cell(numHidden+1, 1);
gradStack = cell(numHidden+1, 1);
n=size(data,1);

%% forward prop
%%% YOUR CODE HERE %%%
if numHidden==0
    out=data*stack{outLayer,1}.W';
    outBias=repmat(stack{outLayer,1}.b',n,1);
    outputs=softmax(out + outBias);
    pred_prob=outputs';
else
    hAct{1}=tanh(data*stack{1,1}.W' + repmat(stack{1,1}.b',n,1));
    for layer=2:numHidden
        hAct{layer}=tanh(hAct{layer-1}*stack{layer,1}.W' + repmat(stack{layer,1}.b',n,1));
    end

    out=hAct{numHidden}*stack{outLayer,1}.W';
    outBias=repmat(stack{outLayer,1}.b',n,1);
    outputs=softmax(out + outBias);
    pred_prob=outputs';
end

%% compute cost
%%% YOUR CODE HERE %%%
cost = softmax_cross_entropy(labels,outputs);

for layer=1:outLayer
    cost = cost + 0.5*ei.lambda*norm(stack{layer,1}.W);
end

%% return here if only predictions desired.
if po
  ceCost = -1; wCost = -1; numCorrect = -1;
  grad = [];  
  return;
end;

%% compute gradients using backpropagation
%%% YOUR CODE HERE %%%
if numHidden==0
    outDelta = (outputs - labels);
    outGrad = outDelta' * data;
else
    outDelta = (outputs - labels);
    outGrad = outDelta' * hAct{numHidden};
end
gradStack{outLayer,1}.W = outGrad + ei.lambda*(stack{outLayer,1}.W);
outBiasGrad = mean(outDelta,1);
gradStack{outLayer,1}.b = outBiasGrad';

for layer=numHidden:-1:1
    gprime=1-(hAct{layer}.^2);
    outDelta = outDelta*stack{layer+1,1}.W;
    
    if layer==1
        ins=data;
    else
        ins=hAct{layer-1};
    end
    hiddenGrad=(gprime.*outDelta)'*ins;
    gradStack{layer,1}.W = hiddenGrad + ei.lambda*(stack{layer,1}.W);

    hiddenBiasGrad = mean(outDelta,1);
    gradStack{layer,1}.b = hiddenBiasGrad';
end


%% reshape gradients into vector
[grad] = stack2params(gradStack);

% minFunc Momentum code, uncomment the below to activate
% persistent old_grad;
% 
% if ~isempty(old_grad)
%     grad = grad + ei.mu*old_grad;
% end
% old_grad = grad;

end



