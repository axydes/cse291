function [ data ] = parseNames( data, is_nimstim )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    n=size(data,1);
    minID=999999;
    maxID=0;
    for i=1:n
        fname=data{i,1};
        id=str2num(fname(1:2));
        data{i,1}=id;
        if id<minID
            minID=id;
        end
        if id>maxID
            maxID=id;
        end
    end
    maxID=maxID-minID+1;
    
%     for i=1:n
%         id = data{i,1}-minID+1;
%         data{i,1} = onehot(id,maxID);
%     end
    
    if is_nimstim
        return
    end

end

