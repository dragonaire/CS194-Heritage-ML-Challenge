indices = [10,14,26,29,32,33]
names{1} = 'Linear';
names{2} = 'Catvec';
names{3} = 'GBM';
names{4} = 'SVM';
names{5} = 'MARS';
names{6} = 'Factor';
for i=1:length(indices)
  for j=1:length(indices)
    if i==j
      continue
    end
    h=figure
    x=allDIH(:,indices(i));
    y=allDIH(:,indices(j));
    scatter(x,y);
    title(sprintf('%s vs %s', names{i}, names{j}));
    xlabel(names{i}); ylabel(names{j});
    axis([0 3 0 3])
    axis square
    hold on
    plot([0,3],[0,3]);
    print(h, '-dpng', sprintf('images/%d_%d.png',i,j));
  end
end
return
%return
% Linear vs MARS
LINEAR = 10;
MARS = 32;
x=allDIH(:,LINEAR);
y=allDIH(:,MARS);
scatter(x,y);
title('Linear vs MARS');
xlabel('Linear'); ylabel('MARS');
axis([0 3 0 3])
axis square
hold on
plot([0,3],[0,3]);
%return
% Linear vs GBM
LINEAR = 10;
GBM = 26;
x=allDIH(:,LINEAR);
y=allDIH(:,GBM);
scatter(x,y);
title('Linear vs GBM');
xlabel('Linear'); ylabel('GBM');
axis([0 3 0 3])
axis square
hold on
plot([0,3],[0,3]);
%return
% Linear vs catvec
LINEAR = 10;
CATVEC = 14;
x=allDIH(:,LINEAR);
y=allDIH(:,CATVEC);
scatter(x,y);
title('Linear vs Catvec');
xlabel('Linear'); ylabel('Catvec');
axis([0 3 0 3])
axis square
hold on
plot([0,3],[0,3]);
%return
% Linear vs svm
LINEAR = 10;
SVM = 29;
x=allDIH(:,LINEAR);
y=allDIH(:,SVM);
scatter(x,y);
title('Linear vs SVM');
xlabel('Linear'); ylabel('SVM');
axis([0 3 0 3])
axis square
hold on
plot([0,3],[0,3]);
return
