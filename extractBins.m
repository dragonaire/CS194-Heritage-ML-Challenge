function bins = extractBins(DIH,genders,ages)
%bins.all = extractSome(DIH.all,genders.all,ages.all);
bins.yr2 = extractSome(DIH.yr2,genders.yr2,ages.yr2);
bins.yr3 = extractSome(DIH.yr3,genders.yr3,ages.yr3);
% dedup patients in both Y2 and Y3, 
% then calculate log DIH per trait bin 
% (i.e. gender bins: M/F/none, logDIH<trait>bins is a cell matrix)
% dont double count patients who were in both year 2 and year 3
bins.comb23 = extractSome(DIH.comb23,genders.comb23,ages.comb23);
end
function subbins = extractSome(DIH,genders,ages)
subbins.gender = extractTraitBins(DIH, genders, true);
subbins.age = extractTraitBins(DIH, ages, true);
end