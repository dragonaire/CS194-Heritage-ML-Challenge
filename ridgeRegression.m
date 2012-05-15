function [targetDIH,weights] = ridgeRegression(preds, ...
	test_var, test_opt_const, leaderboard_scores)
% logDIH is from the training year
% m_test is the number of predictions for the target year
m_test = length(preds);
ALPHA = 0.07;%0.0015;
alpha = ALPHA*m_test;
[m,n] = size(preds);

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

targetDIH = preds*weights; %this is in log space.
targetDIH = targetDIH - mean(targetDIH) + test_opt_const;
targetDIH = exp(targetDIH)-1;

end

