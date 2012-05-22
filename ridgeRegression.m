function [targetDIH,weights] = ridgeRegression(preds, ...
	test_var, test_opt_const, leaderboard_scores, quiz_fraction)
% m_test is the number of predictions for the target year
m_test = length(preds);
ALPHA = 0.0008;%0.0015;
alpha = ALPHA*m_test;
[m,n] = size(preds);

% preds is in day space so change it to log space
preds = log(preds+1);
Xmeans = repmat(mean(preds),m,1);
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
with_overfit = sqrt(predicted_mse + 2*dof/(quiz_fraction*m));

disp(sprintf('predicted_mse: %f, with overfitting: %f, DOF %f', predicted_rmse,with_overfit,dof));


targetDIH = exp(targetDIH)-1;
end
