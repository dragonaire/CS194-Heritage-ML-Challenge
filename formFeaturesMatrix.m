function features = formFeaturesMatrix(f, range, members, feature_members)
    features = zeros(length(members),range);
    i=1;
    for m=1:length(members)
        while feature_members(i) <= members(m)
            if feature_members(i) == members(m) && f(i) ~= 0
                features(m,f(i)) = features(m,f(i)) + 1;
            end
            i = i + 1;
            if i > length(feature_members)
                break;
            end
        end
    end
end