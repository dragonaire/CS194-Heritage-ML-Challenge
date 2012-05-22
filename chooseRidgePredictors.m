function [ set ] = chooseRidgePredictors(preds, ...
	test_var, test_opt_const, leaderboard_scores, quiz_fraction,have)
if size(have,2) > 1
    if size(have,1) > 1
        disp('ERROR IN chooseRidgePredictors');
        return
    end
    have=have';
end
% Greedily add predictors
prev_best = inf;
cur_best = 1e10;
set = [];
while cur_best<prev_best
    prev_best = cur_best;
    cur_best = 1e10;
    cur_i = 0;
    for i=have
        if length(unique([set;i])) == length(set)
            continue
        end
        [x,y,z,cur] = ridgeRegression(preds(:,[set;i]),test_var,test_opt_const,...
            leaderboard_scores([set;i]),quiz_fraction);
        if cur<cur_best
            cur_best=cur;
            cur_i = i;
        end
    end
    if(cur_i == 0)
        break
    end
    set = [set;cur_i];
end

% Greedily remove predictors
prev_best2 = inf;
cur_best2 = 1e10;
set2 = have;
while cur_best2<prev_best2
    prev_best2 = cur_best2;
    cur_best2 = 1e10;
    cur_i = 0;
    for i=1:length(set2)
        [x,y,z,cur] = ridgeRegression(preds(:,[set2(1:i-1);set2(i+1:end)]),test_var,test_opt_const,...
            leaderboard_scores([set2(1:i-1);set2(i+1:end)]),quiz_fraction);
        if cur<cur_best2
            cur_best2=cur;
            cur_i = i;
        end
    end
    if(cur_i == 0)
        break
    end
    set2 = [set2(1:cur_i-1);set2(cur_i+1:end)];
end
% return the better sets
fprintf('best 1: %f, best 2: %f\n',min(cur_best,prev_best),min(cur_best2,prev_best2));
set'
set2'
if cur_best>cur_best2
    set=set2;
end
end