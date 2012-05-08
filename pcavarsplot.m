function [pca,scores,vars,t2,var_percent,main_pca] = pcavarsplot(trait, traitname)
% PCA on traits (sparse matrix)
% Ex:
% load drugs;
% [pca,scores,vars,t2,var_percent,main_pca] = pcavarplot(drugs.features3_1yr, 'drugs.features3_1yr');
%
% can see that first main_pca (4) components make up 80% of the variance
% to prevent overfitting, can just use those 4 components
%

THRESH_PERCENT = 80;  

[pca,scores,vars,t2] = princomp(trait);
var_percent = 100*vars./sum(vars);

pareto(var_percent);
xlabel('Principal Component');
ylabel('Variance Explained (%)');
title(['PCA percent variance: ' traitname]);

var_cumsum = cumsum(var_percent);

main_pca = find(var_cumsum >= THRESH_PERCENT, 1);

end
