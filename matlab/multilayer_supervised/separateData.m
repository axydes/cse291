function [ data_train,labels_train,data_test,labels_test ] = separateData( inCells, inData )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

  n=length(inCells);
  I = randperm(n);
  labels=zeros(n,size(inCells{1,1},1));
  data=zeros(n,size(inData,2));
  for i=1:n
    labels(i,:)=inCells{I(i),1};
    data(i,:)=inData(I(i));
  end
  
  stop=round(length(data)/3);
  data_test=data(1:stop,:);
  labels_test=labels(1:stop,:);
  data_train=data(stop:end,:);
  labels_train=labels(stop:end,:);

end

