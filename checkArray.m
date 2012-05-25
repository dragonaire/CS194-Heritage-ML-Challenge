function [offending_indices ] = checkArray( a,range )
offending_indices=[];
for i=range
    if length(find(a==i)) == 0
        sprintf('No entries with value %d found\n',i)
        offending_indices=[offending_indices;i];
    end
end
end