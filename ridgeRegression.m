function [targetDIH,with_overfit,weights,predicted_rmse] = ridgeRegression(preds, ...
	indices, args)%test_var, test_opt_const, leaderboard_scores, quiz_fraction)
preds=preds(:,indices);
test_var=args{1};
test_opt_const=args{2};
leaderboard_scores=args{3}(indices);
quiz_fraction=args{4};
% m_test is the number of predictions for the target year
[m_test,n] = size(preds);
ALPHA = 0.01;%0.0015;
alpha = ALPHA*m_test;

% preds is in day space so change it to log space
preds = log(preds+1);
Xmeans = repmat(mean(preds),m_test,1);
X = preds - Xmeans;

% See http://www.netflixprize.com/assets/GrandPrize2009_BPC_BigChaos.pdf Section 7
test_mse = (leaderboard_scores.^2);
term1 = m_test*test_var;
term2 = sum(X.^2)';
term3 = -m_test*test_mse;

xTy = 0.5*(term1+term2+term3);
A = X'*X + alpha*eye(n);
weights = A \ xTy;

% normalize the weights to sum to 1. Are we supposed to do this?
%total = sum(weights);
%weights = weights / total;

targetDIH = preds*weights; %this is in log space.
% Re-center the predictions around the target mean. Are we supposed to do this?
targetDIH = targetDIH - mean(targetDIH) + test_opt_const;

% Effective degrees of freedom
dof = trace2(X,(A\X'));

predicted_mse = weights'*(test_mse-var(X)') + ...
    test_var*(1-sum(weights)) + ...
    var(targetDIH);
predicted_rmse = sqrt(predicted_mse);
with_overfit = sqrt(predicted_mse + 2*dof/(quiz_fraction*m_test));

%fprintf('predicted_mse: %f, with overfitting: %f, DOF %f\n', predicted_rmse,with_overfit,dof);


targetDIH = exp(targetDIH)-1;
end
