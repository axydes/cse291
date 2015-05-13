function [ actInt ] = getActorInt( actStr )
%getActorInt string parsing Actor label to integer

    switch(actStr)
        case 'aa'
            actInt = 1;
        case 'cc'
            actInt = 2;
        case 'em'
            actInt = 3;
        case 'gs'
            actInt = 4;
        case 'jb'
            actInt = 5;
        case 'jj'
            actInt = 6;
        case 'jm'
            actInt = 7;
        case 'mf'
            actInt = 8;
        case 'mo'
            actInt = 9;
        case 'nr'
            actInt = 10;
        case 'pe'
            actInt = 11;
        case 'pf'
            actInt = 12;
        case 'sw'
            actInt = 13;
        case 'wf'
            actInt = 14;
        otherwise
            error('Unexpected actor string.')
    end

end

