function [ emoInt ] = getEmotionInt( emoStr )
%getEmotionInt string parsing emotion label to integer

    switch(emoStr)
        case 'AN'
            emoInt = 1;
        case 'DI'
            emoInt = 2;
        case 'HA'
            emoInt = 3;
        case 'SP'
            emoInt = 4;
        case 'SA'
            emoInt = 5;
        case 'FE'
            emoInt = 6;
        otherwise
            warning('Unexpected emotion string.')
    end

end

