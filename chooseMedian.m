function [targetDIH, err] = chooseMedian(preds,indices,args)
logDIH = args{1};
targetDIH = median(preds(:,indices),2);
err = sqrt(mean((logDIH-log(targetDIH+1)).^2));
%fprintf('num %d, err: %f\n',length(indices),err);
end

