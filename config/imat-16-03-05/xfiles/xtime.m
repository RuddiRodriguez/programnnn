function [tdiff,h,m,s]=xtime(t1,t2,p)
%-----------------------------------------------------------------
% function [tdiff,h,m,s]=xtime(t1,t2,p)
%-----------------------------------------------------------------
% Convert matlab start and end time to a period i hours,
% minutes and seconds.
% Input:
%   t1:     Time (start)
%   t2:     Time (end)
%   p:      A time period
% Output:
%   h: hours
%   m: minutes
%   s: seconds
% Usage:
% Either t1 and t2 is specified
% or t1=t2=[] and instead the period is specified.
%-----------------------------------------------------------------
% Example:
%
if nargin==3
    tdiff=p;
else
    tsec1=t1(6)+t1(5)*60+t1(4)*60*60;
    tsec2=t2(6)+t2(5)*60+t2(4)*60*60;
    tdiff=tsec2-tsec1;    
end
h=floor(tdiff/60/60);
m=floor((tdiff-h*60*60)/60);
s=floor((tdiff-h*60*60-m*60));




