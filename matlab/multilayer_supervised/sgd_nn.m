function [ theta, losses, stop_point ] = sgd_nn( funObj, theta, maxIters, X, y, ei, batchSize, X_val, y_val )
%sgd Performs stochastic gradient descent (mini-batch if desired)

fprintf('Iter\tLearning Rate\tLoss\tAvg Loss\tVal Loss\tAvg Val Loss\n');
alpha=ei.alpha;

oldG = zeros(size(theta));
avgLoss = 0;
oldAvgLoss = avgLoss;
oldLoss=9e99;
oldValLoss=9e99;
avgValLoss=0;
oldAvgValLoss=0;

minTheta=theta;
minLoss = 9e99;
stop_point = maxIters;

for i=1:maxIters    
    n = size(X,1); %# samples    
    
    for j=1:batchSize:n
        idxs=randi(n,batchSize,1);
        
        batchData = X(idxs,:);
        
        %Partial obscuration regularization
        dropped=randi([0,1],size(batchData));
        batchData = dropped.*batchData*2;
        
        [f,g] = funObj(theta, ei, batchData, y(idxs,:), false);

        %Update thetas
        thetaUp = g.*alpha + ei.mu*oldG;
        theta = theta - thetaUp;
        oldG = thetaUp;
    end
    
    if exist('X_val','var')
        %this means we're running on POFA dataset and have a
        %holdout/validation set
        [fVal,~] = funObj(theta, ei, X_val, y_val, false);
        if fVal < minLoss
            minLoss = fVal;
            minTheta = theta;
        end
        
        if avgValLoss == 0
            avgValLoss = fVal;
            oldAvgValLoss = fVal;
        else
            avgValLoss = avgValLoss*.995 + .005*fVal;
        end
        
        %Early stopping
        if i > 500 && avgValLoss > oldAvgValLoss
            fprintf('Iter: %d. Avg Val Error went up, stopping.\n',i);
            fprintf('%d\t%f\t%f\t%f\t%f\t%f\n',i,alpha,f,avgLoss,fVal,avgValLoss);
            stop_point = i;
            break;
        end
        oldAvgValLoss = avgValLoss;
    end
    
    if mod(i,10) == 0        
        [f,~] = funObj(theta, ei, X, y, false);
        if f < minLoss
            minLoss = f;
            minTheta = theta;
        end
        
        if avgLoss == 0
            avgLoss = f;
            oldAvgLoss = f;
        else
            avgLoss = avgLoss*.9 + .1*f;
        end

        %lower learning rate
        if avgLoss>oldAvgLoss
            alpha = alpha*.9;
        end        
        oldAvgLoss = avgLoss;
        oldLoss = f;
        losses(i) = f;

        %track loss
        fprintf('%d\t%f\t%f\t%f\t%f\t%f\n',i,alpha,f,avgLoss,f,avgLoss);
    end

end

theta = minTheta;

end

