function featuresForYear = getFeaturesForYear(claimsForYear,target_members,year_members)
constants
condSpec = claimsForYear.condGroup + SIZE.COND_GROUP*(claimsForYear.specialty-1);
featuresForYear.condSpec = formFeaturesMatrix(condSpec, SIZE.COND_GROUP*SIZE.SPECIALTY,...
    target_members,year_members);
clear condSpec;
condPlace = claimsForYear.condGroup + SIZE.COND_GROUP*(claimsForYear.place-1);
featuresForYear.condPlace = formFeaturesMatrix(condPlace, SIZE.COND_GROUP*SIZE.PLACE,...
    target_members,year_members);
clear condPlace;
specPlace = claimsForYear.specialty + SIZE.SPECIALTY*(claimsForYear.place-1);
featuresForYear.specPlace = formFeaturesMatrix(specPlace, SIZE.SPECIALTY*SIZE.PLACE,...
    target_members,year_members);
clear specPlace;
featuresForYear.nproviders = countUnique(claimsForYear.provider,SIZE.PROVIDER,target_members,year_members);
featuresForYear.nvendors = countUnique(claimsForYear.vendor,SIZE.VENDOR,target_members,year_members);
featuresForYear.npcps = countUnique(claimsForYear.pcp,SIZE.PCP,target_members,year_members);
featuresForYear.nspec = countUnique(claimsForYear.specialty,SIZE.SPECIALTY,target_members,year_members);
featuresForYear.nplace = countUnique(claimsForYear.place,SIZE.PLACE,target_members,year_members);
featuresForYear.nproc = countUnique(claimsForYear.procedure,SIZE.PROCEDURE,target_members,year_members);
featuresForYear.ncond = countUnique(claimsForYear.condGroup,SIZE.COND_GROUP,target_members,year_members);
%featuresForYear.members = formFeaturesMatrix(claimsForYear.members,SIZE.,target_members,year_members);
%featuresForYear.provider = formFeaturesMatrix(claimsForYear.provider,SIZE.,target_members,year_members);
%featuresForYear.vendor = formFeaturesMatrix(claimsForYear.vendor,SIZE.,target_members,year_members);
%featuresForYear.pcp = formFeaturesMatrix(claimsForYear.pcp,SIZE.,target_members,year_members);
%featuresForYear.year =
%formFeaturesMatrix(claimsForYear.year,SIZE.YEAR,target_members,year_member
%s);

featuresForYear.specialty = formFeaturesMatrix(claimsForYear.specialty,SIZE.SPECIALTY,target_members,year_members);
featuresForYear.place = formFeaturesMatrix(claimsForYear.place,SIZE.PLACE,target_members,year_members);
featuresForYear.payDelay = formFeaturesMatrix(claimsForYear.payDelay,SIZE.PAY_DELAY,target_members,year_members);
featuresForYear.LoS = formFeaturesMatrix(claimsForYear.LoS,SIZE.LoS,target_members,year_members);
featuresForYear.DSFS = formFeaturesMatrix(claimsForYear.DSFS,SIZE.DSFS,target_members,year_members);
featuresForYear.condGroup = formFeaturesMatrix(claimsForYear.condGroup,SIZE.COND_GROUP,target_members,year_members);
featuresForYear.charlson = formFeaturesMatrix(claimsForYear.charlson,SIZE.CHARLSON,target_members,year_members);
featuresForYear.procedure = formFeaturesMatrix(claimsForYear.procedure,SIZE.PROCEDURE,target_members,year_members);
featuresForYear.n = full(sum(featuresForYear.place,2)); % chose place because it has smallest dimension

end