function [ data ] = parseNames( data, is_nimstim )
%parseNames parse image file string to get labels

    n=size(data,1);
    if is_nimstim
        for i=1:n
            fname=data{i,1};
            id=str2num(fname(1:2));
            data{i,1}=id;
        end
    else
        for i=1:n
            fname=data{i,1};
            label=getEmotionInt(fname(5:6));
            data{i,1}=label;
            data{i,3}=getActorInt(fname(1:2));
            data{i,4}=fname;
        end
    end

end

