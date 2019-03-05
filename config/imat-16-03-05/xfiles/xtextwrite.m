function xtextwrite(T,f,d,r,u)
%----------------------------------------------------
% function xtextwrite(T,f,d,r,u)
%----------------------------------------------------
% Write a textmatrix to a file.
%----------------------------------------------------
% Input:
%   T:  matrix
%   f:  filename
%   d:  deblank
%   r:  replace tab by space
%   u:  replace sequential space by one space only
% Output:
%   No output
%----------------------------------------------------
% Example:
%
fp=fopen(f,'w');
[N,M]=size(T);
for n=1:N
        line=char(T(n));
        if d==1
            line=deblank(line);
        end
        if r==1
          sp=isspace(line);
          line(find(sp))=' ';
        end
        if u==1
            token='q';
            tokenline='';
            while ~isempty(token)
              [token,line]=strtok(line);
              tokenline=[tokenline ' ' token];
          end
          line=tokenline;
        end
        linelen=size(line);
        linelen=linelen(2);
        for m=1:linelen
            fprintf(fp,'%c',line(m));
        end
        fprintf(fp,'\n');
    end
    fclose(fp);
end

