function rms = calculateRMS(target)
% calculate RMS against Y3 DIH
% using HHP's prediction error formula
% given a predicted target Y3 DIH

% reorder predicted Y3 DIH to original Y3 DIH 
target.DIH(target.memberids_i) = target.DIH;

% read in actual DIH file for Y3
fid = fopen('DaysInHospital_Y3.csv','rt');
C = textscan(fid,'%f %f %f','Delimiter',',','CollectOutput',1);
fclose(fid);
DIH = C{1}(:,3);
n = length(DIH);

% calculate RMS
rms = sqrt(1/n)*norm(target.DIH - DIH);
