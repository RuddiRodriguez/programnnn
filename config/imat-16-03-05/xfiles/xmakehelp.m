function xmakehelp(title)
%--------------------------------------------------------------------
% function xmakehelp(title)
%--------------------------------------------------------------------
% Make help doc on the current folder.
%--------------------------------------------------------------------
% Input:
%   title:  Title of the document. If not supplied then the title
%           by default is the current path.
% Output:
%   A latex file:  xhelp.tex
%--------------------------------------------------------------------
% Example:
%
if nargin==0
    title=pwd;
end
title=strrep(title,'\','$\backslash$');
files=dir('*.m');
[N M]=size(files);
fp=fopen('xhelp.tex','w');
fprintf(fp,'\\documentclass[9pt]{report}\n');
fprintf(fp,'\\usepackage{color}\n');
fprintf(fp,'\\definecolor{light}{gray}{0.85}\n');
fprintf(fp,'\\begin{document}\n');
fprintf(fp,'\\hline\\newline\\vspace{0.4cm}');
fprintf(fp,'\\noindent Title / Source dir: %s \\newline\\n',title);
fprintf(fp,'\\noindent Date: \\today \\newline');
fprintf(fp,'\\hline\\newline\n');
fprintf(fp,'\\vspace{1cm}\n');
fprintf(fp,'\\noindent\n');
for n=1:N    
    fprintf(fp,'\\normalsize\n');
    fprintf(fp,'\\noindent\\colorbox{light}{\\textbf{%s}}',strrep(char(files(n).name),'_','\_'));
    fprintf(fp,'\\footnotesize\n');
    txt=help(char(files(n).name));
    fprintf(fp,'\\begin{verbatim}\n');
    fprintf(fp,'%s\n',txt);
    fprintf(fp,'\\end{verbatim}\n');
end
fprintf(fp,'\\end{document}\n');
fclose(fp);



