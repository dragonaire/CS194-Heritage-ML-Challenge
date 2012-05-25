function [extraf] = getExtraFeatures(f,days,nMissingCols)
    missing = sum(f(:,end-nMissingCols+1:end),2);
    f = f(:,1:end-nMissingCols); %get rid of unknown LoSs
    totaldays = f*days;
    numclaims = sum(f,2);
    ave = totaldays./numclaims;
    ave(numclaims==0) = 0;
    m = size(f,1);
    mins = zeros(m,1);
    maxs = zeros(m,1);
    vars = zeros(m,1);
    missing_but_no_others = zeros(m,1);
    for i=1:m
        if numclaims(i) == 0
            if missing(i) >0 
                missing_but_no_others(i) = 1;
            end
            continue
        end
        ind = find(f(i,:),1,'first');
        mins(i) = days(ind);
        ind = find(f(i,:),1,'last');
        maxs(i) = days(ind);
        vars(i) = mean((f(i,:)-ave(i)).^2);
    end
    %reset some missing data to the averages
    I = find(numclaims > 0);
    medave = median(ave(I));
    medmin = median(mins(I));
    medmax = median(maxs(I));
    medvar = median(vars(I));
    I = find(missing_but_no_others>0);
    ave(I) = medave;
    mins(I) = medmin;
    maxs(I) = medmax;
    vars(I) = medvar;
    extraf = [ave,mins,maxs,sqrt(vars),missing,numclaims,totaldays];
end
