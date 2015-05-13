function [ data_train,labels_train,data_test,labels_test,minID,maxID,newmaxID,newminID ] = separateData( inCells, inData )
%separateData create train/test datasets

    n=length(inCells);
    labels=zeros(n,size(inCells{1,1},1));

    data=inData;
    for i=1:n
        label=inCells{i,1};
        labels(i,:)=label;
    end
    maxID=max(labels);
    minID=min(labels);
    newmaxID=maxID-minID+1;
    newminID=1;

    labels = labels-minID+1;

    labelIdxs = zeros(newmaxID,round(n/newmaxID));
    labelCnt = ones(newmaxID,1);
    for i=1:n
        label=labels(i);
        labelIdxs(label,labelCnt(label)) = i;
        labelCnt(label) = labelCnt(label)+1;
    end
    
    labelIdxs=labelIdxs(:,randperm(size(labelIdxs,2)));
    testIdxs = labelIdxs(:,1:4);
    testIdxs = testIdxs(:);
    testIdxs = testIdxs(testIdxs~=0);
    
    trainIdxs = labelIdxs(:,5:end);
    trainIdxs = trainIdxs(:);
    trainIdxs = trainIdxs(trainIdxs~=0);
    
    data_test = data(testIdxs,:);
    labels_test = labels(testIdxs,:);
    
    data_train = data(trainIdxs,:);
    labels_train = labels(trainIdxs,:);

end

