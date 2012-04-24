function bins = extractBins(DIH23,genders23,ages23)
% dedup patients in both Y2 and Y3, 
% then calculate log DIH per trait bin 
% (i.e. gender bins: M/F/none, logDIH<trait>bins is a cell matrix)
% dont double count patients who were in both year 2 and year 3
bins.gender = extractTraitBins(DIH23, genders23, true);
bins.age = extractTraitBins(DIH23, ages23, true);
end