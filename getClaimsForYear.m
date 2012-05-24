function claimsForYear = getClaimsForYear(claims,yr)
claimsForYear.members = claims.members(yr);
claimsForYear.provider = claims.provider(yr);
claimsForYear.vendor = claims.vendor(yr);
claimsForYear.pcp = claims.pcp(yr);
%claimsForYear.year = claims.year(yr);
claimsForYear.specialty = claims.specialty(yr);
claimsForYear.place = claims.place(yr);
claimsForYear.payDelay = claims.payDelay(yr);
claimsForYear.LoS = claims.LoS(yr);
claimsForYear.DSFS = claims.DSFS(yr);
claimsForYear.condGroup = claims.condGroup(yr);
claimsForYear.charlson = claims.charlson(yr);
claimsForYear.procedure = claims.procedure(yr);
end