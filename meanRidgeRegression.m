function [ target,weights ] = meanRidgeRegression(preds, ...
	test_var, test_opt_const, leaderboard_scores, quiz_fraction,indices)
if size(indices,2) > 1
    if size(indices,1) > 1
        disp('ERROR IN meanRidgeRegression');
        return
    end
    indices=indices';
end
rand('seed',1234'); randn('seed',1234);
[m,n] = size(preds);
weights = zeros(length(indices),1);
target = zeros(m,1);
NITERS = 1000;
N = 20;
for i=1:NITERS
    r = randperm(length(indices), N);
    I = indices(r);
    args{1} = test_var;
    args{2} = test_opt_const;
    args{3} = leaderboard_scores;
    args{4} = quiz_fraction;
    [pred,score,w] = ridgeRegression(preds,I,args);
    weights(I) = weights(I) + w;
    target = target + pred;
end
target = target / NITERS;
end
