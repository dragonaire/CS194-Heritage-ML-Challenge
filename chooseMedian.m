function [targetDIH, err] = chooseMedian(preds,indices,args)
logDIH = args{1};
targetDIH = median(preds(:,indices),2);
err = sqrt(mean((logDIH-log(targetDIH+1)).^2));
%fprintf('err: %f\n',err);
end

