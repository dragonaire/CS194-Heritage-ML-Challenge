rng(1945, 'twister');
load drugs; load lab; load claims;
X = [ages.yr3, genders.yr3, ...
    drugs.features3_1yr, lab.features3_1yr, ...
    claims.f3.condGroup, claims.f3.procedure, ...
    claims.f3.LoS, claims.f3.charlson, ...
    claims.f3.specialty, claims.f3.place ];
Y = logDIH.yr3;

leaf = 0:100:2000;
leaf = [5 10 30 50 leaf(2:end)];
nleaf = length(leaf);
col = 'rgbcmy';
figure(1);
for i = 1:nleaf
    b = TreeBagger(50,X,Y,'method','r','oobpred','on',...
			'cat',16:25,'minleaf',leaf(i));
    plot(oobError(b),col(i));
    hold on;
end
xlabel('Number of Grown Trees');
ylabel('Mean Squared Error');
legend({'1' '5' '10' '20' '50' '100'},'Location','NorthEast');
hold off;

ntrees = 100;
TB = TreeBagger(ntrees,X,Y,'method','regression','OOBPred','on','minleaf',);
figure(2);
plot(oobError(b));
xlabel('Number of Grown Trees');
ylabel('Out-of-Bag Mean Squared Error');

figure(3);
bar(b.OOBPermutedVarDeltaError);
xlabel('Feature Number');
ylabel('Out-Of-Bag Feature Importance');
idxvar = find(b.OOBPermutedVarDeltaError>0.65);

