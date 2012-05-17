function [logDIH, DIH, members] = readTargetDIH(filename)

fid = fopen(filename,'rt');
C = textscan(fid,'%f %f %f','Delimiter',',','CollectOutput',1,'headerLines',1);
fclose(fid);

members = C{1}(:,1);
DIH = C{1}(:,3);
logDIH = log(DIH+1);

end