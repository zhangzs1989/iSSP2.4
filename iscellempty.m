function [locempty,loc] = iscellempty(celldata) 
% 判断cell数组中[]元素的位置和非空元素的位置
% by zhangzs,2020/04/12
n=length(celldata);
m=1;k=1;
for i = 1:length(celldata)
   if isempty(celldata{i})
      locempty(m)=i;
      m = m+1;
   else
      loc(k)=i;
      k = k+1;
   end    
end
if ~exist('locempty')
   locempty = nan; 
end
if ~exist('loc')
loc = []; 
end
end