% call getLogTraits.m after readDIH.m (which gives DIH#_memberids, DIH#)

% get DIH by trait and year
% fill in missing 
DIH_genders2 = extractMemberTraits( members, DIH2_memberids, genders );
DIH_genders3 = extractMemberTraits( members, DIH3_memberids, genders );
DIH_ages2 = extractMemberTraits( members, DIH2_memberids, ages );
DIH_ages3 = extractMemberTraits( members, DIH3_memberids, ages );

% dedup patients in both Y2 and Y3, 
% then calculate log DIH per trait bin 
% (i.e. gender bins: M/F/none, logDIH<trait>bins is a cell matrix)
% dont double count patients who were in both year 2 and year 3
[ DIH_genders, ~ ] = ...
    combineYears( DIH2_memberids, DIH3_memberids, DIH_genders2, DIH_genders3, true );
[ DIH23, ~ ] = combineYears( DIH2_memberids, DIH3_memberids, DIH2, DIH3, false );
logDIHgenderbins = extractTraitBins(DIH23, DIH_genders, logtrue);

[ DIH_ages, ~ ] = ...
    combineYears( DIH2_memberids, DIH3_memberids, DIH_ages2, DIH_ages3, true );
[ DIH23, DIH_members ] = combineYears( DIH2_memberids, DIH3_memberids, DIH2, DIH3, false );
logDIHagebins = extractTraitBins(DIH23, DIH_ages, logtrue);

