function [path]=imat_userpath
if isunix
    path='/imat/userfiles/';    
else
    path='\imat\userfiles\';
end

