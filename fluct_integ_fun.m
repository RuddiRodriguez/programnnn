function f = fluct_integ_fun(p,xdata,coefficient_scale_factor)

p(1) = p(1)*1e-07;
p(2) = p(2)*1e-20;

% xdata: is the predictor; REMARK: xdata was formerly qx, which represents the wave
% number
% p(1),p(2): are parameters of the function, which are to be fitted

% f = 86131723981357271686750207030917009197377559875/13803492693581127574869511724554050904902217944340773110325048447598592*xdata^3/ ...
%     (4972140676145015/4503599627370496*p(1)*xdata^2+5489427335664445/4503599627370496*p(2)*xdata^4)^3 ...
%     *(112589990684262400/7098112038896037/xdata*(4972140676145015/4503599627370496*p(1)*xdata^2+5489427335664445/4503599627370496*p(2)*xdata^4) ...
%     +exdatap(-112589990684262400/7098112038896037/xdata*(4972140676145015/4503599627370496*p(1)*xdata^2+5489427335664445/4503599627370496*p(2)*xdata^4))-1) ...
%     +46781576841508965099649462798448872477313283375/3450873173395281893717377931138512726225554486085193277581262111899648*xdata^3 ...
%     /(2278642293337305/562949953421312*p(1)*xdata^2+2305804747575687/140737488355328*p(2)*xdata^4)^3 ...
%     *(22517998136852480/2718217551980133/xdata*(2278642293337305/562949953421312*p(1)*xdata^2+2305804747575687/140737488355328*p(2)*xdata^4) ...
%     +exdatap(-22517998136852480/2718217551980133/xdata*(2278642293337305/562949953421312*p(1)*xdata^2+2305804747575687/140737488355328*p(2)*xdata^4))-1) ...
%     +54275750806007000319552341842596195131041023225/6901746346790563787434755862277025452451108972170386555162524223799296*xdata^3 ... 
%     /(6074490001041099/281474976710656*p(1)*xdata^2+8193319083804227/17592186044416*p(2)*xdata^4)^3*(28147497671065600/7845598099354671/xdata ...
%     *(6074490001041099/281474976710656*p(1)*xdata^2+8193319083804227/17592186044416*p(2)*xdata^4)+exdatap(-28147497671065600/7845598099354671/xdata ...
%     *(6074490001041099/281474976710656*p(1)*xdata^2+8193319083804227/17592186044416*p(2)*xdata^4))-1)+ ...
%     99629978708602951608745794609064503995670102725/220855883097298041197
%     912187592864814478435487109452369765200775161577472*xdata^3 ...
%     /(6281631839615597/70368744177664*p(1)*xdata^2+273801110731667/34359738368*p(2)*xdata^4)^3*(7036874417766400/3989122658160117/xdata ...
%     *(6281631839615597/70368744177664*p(1)*xdata^2+273801110731667/343597
%     38368*p(2)*xdata^4)+exdatap(-7036874417766400/3989122658160117/xdata ...
%     *(6281631839615597/70368744177664*p(1)*xdata^2+273801110731667/34359738368*p(2)*xdata^4))-1)

f  = 86131723981357271686750207030917009197377559875 ./ 13803492693581127574869511724554050904902217944340773110325048447598592  .* xdata  .^ 3 ./ (4972140676145015 ./ 4503599627370496  .* p(1)  .* xdata  .^ 2+5489427335664445 ./ 4503599627370496  .* p(2)  .* xdata  .^ 4)  .^ 3  .* (112589990684262400 ./ 7098112038896037 ./ xdata  .* (4972140676145015 ./ 4503599627370496  .* p(1)  .* xdata  .^ 2+5489427335664445 ./ 4503599627370496  .* p(2)  .* xdata  .^ 4)+exp(-112589990684262400 ./ 7098112038896037 ./ xdata  .* (4972140676145015 ./ 4503599627370496  .* p(1)  .* xdata  .^ 2+5489427335664445 ./ 4503599627370496  .* p(2)  .* xdata  .^ 4))-1)+46781576841508965099649462798448872477313283375 ./ 3450873173395281893717377931138512726225554486085193277581262111899648  .* xdata  .^ 3 ./ (2278642293337305 ./ 562949953421312  .* p(1)  .* xdata  .^ 2+2305804747575687 ./ 140737488355328  .* p(2)  .* xdata  .^ 4)  .^ 3  .* (22517998136852480 ./ 2718217551980133 ./ xdata  .* (2278642293337305 ./ 562949953421312  .* p(1)  .* xdata  .^ 2+2305804747575687 ./ 140737488355328  .* p(2)  .* xdata  .^ 4)+exp(-22517998136852480 ./ 2718217551980133 ./ xdata  .* (2278642293337305 ./ 562949953421312  .* p(1)  .* xdata  .^ 2+2305804747575687 ./ 140737488355328  .* p(2)  .* xdata  .^ 4))-1)+54275750806007000319552341842596195131041023225 ./ 6901746346790563787434755862277025452451108972170386555162524223799296  .* xdata  .^ 3 ./ (6074490001041099 ./ 281474976710656  .* p(1)  .* xdata  .^ 2+8193319083804227 ./ 17592186044416  .* p(2)  .* xdata  .^ 4)  .^ 3  .* (28147497671065600 ./ 7845598099354671 ./ xdata  .* (6074490001041099 ./ 281474976710656  .* p(1)  .* xdata  .^ 2+8193319083804227 ./ 17592186044416  .* p(2)  .* xdata  .^ 4)+exp(-28147497671065600 ./ 7845598099354671 ./ xdata  .* (6074490001041099 ./ 281474976710656  .* p(1)  .* xdata  .^ 2+8193319083804227 ./ 17592186044416  .* p(2)  .* xdata  .^ 4))-1)+99629978708602951608745794609064503995670102725 ./ 220855883097298041197912187592864814478435487109452369765200775161577472  .* xdata  .^ 3 ./ (6281631839615597 ./ 70368744177664  .* p(1)  .* xdata  .^ 2+273801110731667 ./ 34359738368  .* p(2)  .* xdata  .^ 4)  .^ 3  .* (7036874417766400 ./ 3989122658160117 ./ xdata  .* (6281631839615597 ./ 70368744177664  .* p(1)  .* xdata  .^ 2+273801110731667 ./ 34359738368  .* p(2)  .* xdata  .^ 4)+exp(-7036874417766400 ./ 3989122658160117 ./ xdata  .* (6281631839615597 ./ 70368744177664  .* p(1)  .* xdata  .^ 2+273801110731667 ./ 34359738368  .* p(2)  .* xdata  .^ 4))-1);