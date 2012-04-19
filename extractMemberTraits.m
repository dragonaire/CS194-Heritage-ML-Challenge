function [ traits ] = extractMemberTraits( members, subset, all_traits )
%EXTRACTMEMBERTRAITS Summary of this function goes here
%   members: a list of all member ids
%   subset: a subset of the member ids
%   all_traits: vector containing a trait for every member
%   traits: vector containing a trait for every member in subset

traits = zeros(size(subset));
j=1;
for i=1:length(subset)
    while(subset(i) ~= members(j))
        j = j+1;
    end
    traits(i) = all_traits(j);
end

end

