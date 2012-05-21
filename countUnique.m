function counts = countUnique(f, range, members, feature_members)
    m = size(members,1);
    counts = zeros(m,1);
    features = formFeaturesMatrix(f, range, members, feature_members);
    for i=1:m
        if mod(i,10000) == 0
            fprintf('countUnique: %d\n',i);
        end
        counts(i) = nnz(features(i,:));
    end
end
%{
function counts = countUnique(f, range, members, feature_members)
    m = size(f,1);
    counts = zeros(m,1);
    a=1; b=a+99;
    while a < m
        features = formFeaturesMatrix(f, range, members, feature_members(a:b));
        for i=1:m
            counts(i) = nnz(features(i,:));
        end
        a=b+1; b=a+99;
    end
end
%}