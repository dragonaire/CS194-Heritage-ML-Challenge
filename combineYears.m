function [ data, members_combined ] = combineYears( members1, members2, data1, data2, overwrite )
%	members1: members included in the first year
%   members2: members included in the second year
%   data1: data from the first year
%   data2: data from the second year
%   overwrite: a flag that allows user to average or overwrite year 1 with
%   year 2
%   data: from both years, with year 2 overwriting year 1 if there's a
%   conflict

members_combined = zeros(length(members1)+length(members2),1);
data = zeros(length(members1)+length(members2),1);
j=1; k=1;
for i=1:length(members1)
    %sprintf('%d, %d, %d, %d\n',i,j,members1(i), members2(j))
    while members1(i) > members2(j)
        %sprintf('skipping %d\n',k)
        members_combined(k) = members2(j);
        if members_combined(k)==0
            'error in combineYears'
            keyboard
        end
        data(k) = data2(j);
        j=j+1; k=k+1;
    end
    if members1(i) == members2(j)
        members_combined(k) = members2(j);
        if overwrite % only use year 2
            data(k) = data2(j);
            j=j+1; k=k+1;
        else % then average them
            data(k) = (data1(i) + data2(j)) / 2;
            j=j+1; k=k+1;
        end
        continue;
    end
    members_combined(k) = members1(i);
    if members_combined(k)==0
        'error in combineYears'
        keyboard
    end
    data(k) = data1(i);
    k=k+1;
end
data = data(1:k-1);
members_combined = members_combined(1:k-1);

end