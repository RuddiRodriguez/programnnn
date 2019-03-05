% Performs fast detrended fluctuation analysis on a nonstationary input signal to
% obtain an estimate for the scaling exponent.
%
% Useage:
% [alpha, intervals, flucts] = fastdfa(x)
% [alpha, intervals, flucts] = fastdfa(x, intervals)
% Inputs
%    x          - input signal: must be a row vector
% Optional inputs
%    intervals  - List of sample interval widths at each scale
%                 (If not specified, then a binary subdivision is constructed)
%
% Outputs:
%    alpha      - Estimated scaling exponent
%    intervals  - List of sample interval widths at each scale
%    flucts     - List of fluctuation amplitudes at each scale
%
% (c) 2006 Max Little. If you use this code, please cite:
% M. Little, P. McSharry, I. Moroz, S. Roberts (2006),
% Nonlinear, biophysically-informed speech pathology detection
% in Proceedings of ICASSP 2006, IEEE Publishers: Toulouse, France.

function [alpha, intervals, flucts] = fastdfa(x, varargin)

[xpts, ypts] = fastdfa_core(x, varargin{:});

% Sort the intervals, and produce a log-log straight line fit
datapts   = sortrows([xpts ypts],1);
intervals = datapts(:,1);
flucts    = datapts(:,2);

coeffs    = polyfit(log10(xpts), log10(ypts), 1);
alpha     = coeffs(1);

%plot(ypts,xpts)

% xdata=log10(xpts)
%  ydata=log10(ypts)
  
%    ftype=fittype('a6*x+b6','coefficients',{'a6','b6'});
%  [fresult,gof,output] =fit(log10(xpts), log10(ypts),ftype)
% % [fresult,gof,output] =fit(xdata1,ydata1,ftype);
%   f=feval(fresult,log10(xpts));
  
  
 
figure (1)

plot(log(intervals),log(flucts),'o')
title('flucts-Intervals')

%   figure(1)
  hold on
% % %plot(xdata1,ydata1,'o')
%figure (2)
%   plot(log10(xpts), log10(ypts),'o',log10(xpts),f,'k');
%   title('logflcuts-logIntervals')
%   text(2.4,-2.0,texlabel(['slope=' num2str(fresult.a6)]))
%   ylabel('F(n)')
%   xlabel('n') 