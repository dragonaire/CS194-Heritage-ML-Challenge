function [b, p, e] = bagging(ntrees, minleaf)

% TODO: run with much larger value of ntrees in parallel

% newer versions of matlab have this:
% rng(1945, 'twister');
% s = RandStream('mt19937ar','Seed',0);
% RandStream.setGlobalStream(s);

load members;
load drugs; load lab; load claims;

% X = [ages.yr3, genders.yr3, ...
%     drugs.features3_1yr, lab.features3_1yr, ...
%     claims.f3.condGroup, claims.f3.procedure, ...
%     claims.f3.LoS, claims.f3.charlson, ...
%     claims.f3.specialty, claims.f3.place, ...
%     claims.f3.DSFS];
X = [ages.yr3, genders.yr3, ...
    drugs.features3_1yr, lab.features3_1yr, ...
    claims.f3.condGroup, claims.f3.procedure, ...
    claims.f3.specialty, claims.f3.place];
X = full(X);

Y = logDIH.yr3;

% ntrees = 2000;
% minleaf = 10;
b = TreeBagger(ntrees,X,Y,'method','regression','OOBPred','on','minleaf',minleaf);
p = oobPredict(b);
e = oobError(b);
    
% leaf = 0:100:2000;
% leaf = [5 10 30 50 leaf(2:end)];
% nleaf = length(leaf);
% col = 'rgbcmy';
% figure(1);
% for i = 1:nleaf
%     b = TreeBagger(50,X,Y,'method','r','oobpred','on',...
% 			'cat',16:25,'minleaf',leaf(i));
%     plot(oobError(b),col(i));
%     hold on;
% end
% xlabel('Number of Grown Trees');
% ylabel('Mean Squared Error');
% legend({'1' '5' '10' '20' '50' '100'},'Location','NorthEast');
% hold off;

% ntrees = 2000;
% minleaf = 10;

% for graphing
%{
max = 20;
ntrees = 1:max;
minleaf = 10;
TB = cell(1,max);
P = zeros(71435,max);
E = cell(1,max);
for i = 1:max
    b = TreeBagger(i,X,Y,'method','regression','OOBPred','on','minleaf',minleaf);
    p = oobPredict(b);
    P(:,i) = p;
    e = oobError(b);
    E{i} = e;
    TB{i} = b;
end
save('tb.mat','TB','P','E','ntrees','minleaf');    
    
figure,
plot(E{6});
xlabel('Number of Grown Trees');
ylabel('Out-of-Bag Mean Squared Error');
title('Bagging on features with ntrees=20, minleaf=10');
%} 

% figure(3);
% bar(TB.OOBPermutedVarDeltaError);
% xlabel('Feature Number');
% ylabel('Out-Of-Bag Feature Importance');
% idxvar = find(b.OOBPermutedVarDeltaError>0.65);

