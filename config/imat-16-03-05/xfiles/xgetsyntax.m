function [syntax,errormessage]=xgetsyntax(names)
%------------------------------------------------------------------
% function [syntax,errormessage]=xgetsyntax(names)
%------------------------------------------------------------------
% Generates the syntax of a set of names
%------------------------------------------------------------------
% Input:
%   names:  a matrix of strings containing the names
% Output:
%   syntax: the syntax, a string of 's' and 'n'
%------------------------------------------------------------------
% Example:
%  names = '2abcd8nm'
%          '2q3y'
%  => syntax = 'nsns'
%
% Symbols '-'; '+'; '='; '_'; '.' are treated as strings and
% Both upper and lower case is allowed but not distinguised.
% Other chars are NOT allowed !!!
%
letters=[         'a'; 'b'; 'c'; 'd'; 'e'; 'f'; 'g'; 'h'; 'i'; 'j'; 'k'; 'l'; 'm'; 'n'; 'o'; 'p'; 'q'; 'r'; 's'; 't'; 'u'; 'v'; 'w'; 'x'; 'y'; 'z'];
letters=[letters; 'A'; 'B'; 'C'; 'D'; 'E'; 'F'; 'G'; 'H'; 'I'; 'J'; 'K'; 'L'; 'M'; 'N'; 'O'; 'P'; 'Q'; 'R'; 'S'; 'T'; 'U'; 'V';'W'; 'X'; 'Y'; 'Z'];
letters=[letters; '-'; '+'; '='; '_'; '.'];
integers=['0'; '1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9';];
errormessage=0;
[N M]=size(names);
curcatsyntax=[];
syntaxes=[];
syntax=[];
for n=1:N
    curcatsyntax=[];
    cur=char(names(n,:));
    [DD MM]=size(cur);
    last=0;
    for m=1:MM
        
        if sum(cur(m)==letters)
            if last==2 || last==0
                curcatsyntax=[curcatsyntax 's'];
            end
            last=1;
        end
        
        if sum(cur(m)==integers)
            if last==1 || last==0
                curcatsyntax=[curcatsyntax 'n'];
            end
            last=2;
        end               
    end
    syntaxes=[syntaxes;cellstr(curcatsyntax)];
end

cur=char(syntaxes(1,:));
error=0;
for n=2:N
    if sum(cur=='s')==sum(char(syntaxes(n,:))=='s') && sum(cur=='n')==sum(char(syntaxes(n,:))=='n')
        if ~all(cur==char(syntaxes(n,:)))
            error=1;
            break;
        end
    else
        error=1;
        break;
    end
end
if error==0
    syntax=syntaxes(1,:);
else
    errormessage='Names do not have the same syntax.';
end



