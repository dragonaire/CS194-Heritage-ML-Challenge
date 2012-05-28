function [ set ] = choosePredictors(fh,preds,indices,varargin)
if size(indices,2) > 1
    if size(indices,1) > 1
        disp('ERROR IN chooseRidgePredictors');
        return
    end
    indices=indices';
end
% Greedily add predictors
prev_best = inf;
cur_best = 1e10;
set = [];
while cur_best<prev_best
    prev_best = cur_best;
    cur_best = 1e10;
    cur_i = 0;
    for i=indices
        if length(unique([set;i])) == length(set)
            continue
        end
        [x,cur] = fh(preds,[set;i],varargin);
        if cur<prev_best && cur<cur_best
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
set2 = indices;
while cur_best2<prev_best2
    prev_best2 = cur_best2;
    cur_best2 = 1e10;
    cur_i = 0;
    for i=1:length(set2)
        tmpset = [set2(1:i-1);set2(i+1:end)]';
        [x,cur] = fh(preds,tmpset,varargin);
        if cur<prev_best2 && cur<cur_best2
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
if min(cur_best,prev_best)>min(cur_best2,prev_best2)
    set=set2;
end
end