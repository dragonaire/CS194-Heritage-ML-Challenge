function [ counts ] = parseMonthCounts( data )
% data is a cell array of strings
% counts is a float vector
counts = 1*strcmp(data,'0- 1 month') + ...
    2*strcmp(data,'1- 2 months') + ...
    3*strcmp(data,'2- 3 months') + ...
    4*strcmp(data,'3- 4 months') + ...
    5*strcmp(data,'4- 5 months') + ...
    6*strcmp(data,'5- 6 months') + ...
    7*strcmp(data,'6- 7 months') + ...
    8*strcmp(data,'7- 8 months') + ...
    9*strcmp(data,'8- 9 months') + ...
    10*strcmp(data,'9-10 months') + ...
    11*strcmp(data,'10-11 months') + ...
    12*strcmp(data,'11-12 months') + ...
    13*strcmp(data,'');
end

