function [ data_train,labels_train,data_test,labels_test,data_val,labels_val,...
    maxID,maxLabel,testActor,valActor ] = separatePofaData( inCells, inData, testActor )
%separatePofaData create train/val/test datasets for the POFA exercise

    n=length(inCells);
    labels=zeros(n,size(inCells{1,1},1));
    actors=zeros(n,size(inCells{1,1},1));

    data=inData;
    for i=1:n
        labels(i,:)=inCells{i,1};
        actors(i)=inCells{i,3};
    end

    maxLabel=max(labels);
    maxID=max(actors);
    
    actorIdxs = zeros(maxID,round(n/maxID));
    actorCnt = ones(maxID,1);
    for i=1:n
        act=actors(i);
        actorIdxs(act,actorCnt(act)) = i;
        actorCnt(act) = actorCnt(act)+1;
    end
    
%     testActor = randi(14);
    valActor = randi(14);
    while valActor==testActor
        valActor = randi(14);
    end
    
    testIdxs = actorIdxs(testActor,:);
    testIdxs = testIdxs(:);
    testIdxs = testIdxs(testIdxs~=0);
    
    valIdxs = actorIdxs(valActor,:);
    valIdxs = valIdxs(:);
    valIdxs = valIdxs(valIdxs~=0);
    
    if testActor<valActor
        trainIdxs = actorIdxs(1:testActor-1,:);
        trainIdxs2 = actorIdxs(testActor+1:valActor-1,:);
        trainIdxs3 = actorIdxs(valActor+1:end,:);
    else
        trainIdxs = actorIdxs(1:valActor-1,:);
        trainIdxs2 = actorIdxs(valActor+1:testActor-1,:);
        trainIdxs3 = actorIdxs(testActor+1:end,:);
    end
    
    trainIdxs = trainIdxs(:);
    trainIdxs2 = trainIdxs2(:);
    trainIdxs3 = trainIdxs3(:);
    trainIdxs = vertcat(trainIdxs,trainIdxs2,trainIdxs3);
    trainIdxs = trainIdxs(trainIdxs~=0);
    
    data_test = data(testIdxs,:);
    labels_test = labels(testIdxs,:);
    
    data_val = data(valIdxs,:);
    labels_val = labels(valIdxs,:);
    
    data_train = data(trainIdxs,:);
    labels_train = labels(trainIdxs,:);

end

