function [DELI,os]=xgetos
%------------------------------------------------------
% function [DELI,os]=xgetos
%------------------------------------------------------
% Return os specific file delimiter and a string 
% telling the operating system.
%------------------------------------------------------
% Input:
%   No input
% Output:
%   DELI:   ux-like '/' and windows '\'
%   os:     ux/win
%------------------------------------------------------
% Example:
%
if isunix
   DELI='/';
   os='ux';
else
    DELI='\';
    os='win';
end