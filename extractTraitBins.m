function allBins = extractTraitBins(table, trait, logtrue)

num_bins = max(trait) - min(trait) + 1;
allBins = cell(num_bins,1);
if (logtrue) 
    for i = 1:num_bins
        allBins{i,1} = log(table(trait==i)+1);
    end
else 
    for i = 1:num_bins
        allBins{i,1} = table(trait==i);
    end
end
