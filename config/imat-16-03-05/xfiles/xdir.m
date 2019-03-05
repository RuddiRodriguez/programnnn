function [files]=xdir(path)
%---------------------------------------------------------
% function [files]=xdir(path)
%---------------------------------------------------------
% List filenames in a specified folder.
%---------------------------------------------------------
% Input:
%   path:   The path where the wanted files are located
% Output:
%   files:  List of filenames in the format of cells
%---------------------------------------------------------
% Examples:
%
structfiles=eval('dir(path)');
[N M]=size(structfiles);
files=[];
for n=1:N
      files=[files; cellstr(structfiles(n).name)];
end

