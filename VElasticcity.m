function v = ve(d, bead radius, freq type, plot results);
% VE computes the viscoelastic moduli from the computed MSD
%
% 3DFM function
% specificnrheologynmsd
% last modified 11/20/08
%
% ve computes the viscoelastic moduli from mean?square
% displacement data using the algorithm outlined in Mason's
% 2000 Rheologica Acta paper. The output structure of ve
% contains four members: raw (which contains data for each
% individual tracker/bead), mean (contains means across
% trackers/beads), and error (contains standard error
% (stdev/sqrt(N) about the mean value, and N (the number of
% trackers/beads in the dataset.
%
% [v] = ve(d, bead radius, freq type, plot results);
%
% where "d" is the output structure of video msd.
% "bead radius" is in [m].
% "freq type" is 'f' for [Hz] (default)
% 'w' for [rad/s]
% "plot results" plots a figure if 'y' (default)
%
if (nargin < 3) j j isempty(freq type)
freq type = 'f';
end
if (nargin < 2) j j isempty(bead radius)
bead radius = 0.5e?6;
end
if (nargin < 1) j j isempty(d)
error('no data struct found');
end
k = 1.3806e:23;
T = 298;
msd = d.msd;
tau = d.tau;
% N corresponds to the number of trackers at each tau
N = d.n(1:end:1);
A = tau(1:end:1,:);
22
B = tau(2:end,:);
C = msd(1:end:1,:);
D = msd(2:end,:);
alpha = log10(D./C)./log10(B./A);
MYgamma = gamma(1 + alpha);
% gamma = 0.457*(1+alpha).ˆ2?1.36*(1+alpha)+1.9;
% because of the first?difference equation used to compute
% alpha, we must delete the last row of f, tau, and
% msd values.
msd = msd(1:end:1,:);
tau = tau(1:end:1,:);
% get frequencies all worked out from timing (tau)
f = 1 ./ tau;
w = 2*pi*f;
% compute shear and viscosity
gstar = (2/3) * (k*T) ./ ...
(pi * bead radius .* msd .* MYgamma);
gp = gstar .* cos(pi/2 .* alpha);
gpp= gstar .* sin(pi/2 .* alpha);
nstar = gstar .* tau;
np = gpp .* tau;
npp= gp .* tau;
%
% setup the output structure
%
v.raw.f = f;
v.raw.w = w;
v.raw.tau = tau;
v.raw.msd = msd;
v.raw.alpha = alpha;
v.raw.gamma = MYgamma;
v.raw.gstar = gstar;
v.raw.gp = gp;
v.raw.gpp = gpp;
v.raw.nstar = nstar;
v.raw.np = np;
v.raw.npp = npp;
v.mean.f = nanmean(f,2);
v.mean.w = nanmean(w,2);
v.mean.tau = nanmean(tau,2);
v.mean.msd = nanmean(msd,2);
v.mean.alpha = nanmean(alpha,2);
23
v.mean.gamma = nanmean(MYgamma,2);
v.mean.gstar = nanmean(gstar,2);
v.mean.gp = nanmean(gp,2);
v.mean.gpp = nanmean(gpp,2);
v.mean.nstar = nanmean(nstar,2);
v.mean.np = nanmean(np,2);
v.mean.npp = nanmean(npp,2);
v.error.f = nanstd(f,[],2) ./ sqrt(N);
v.error.w = nanstd(w,[],2) ./ sqrt(N);
v.error.tau = nanstd(tau,[],2) ./ sqrt(N);
v.error.msd = nanstd(msd,[],2) ./ sqrt(N);
v.error.alpha = nanstd(alpha,[],2) ./ sqrt(N);
v.error.gamma = nanstd(MYgamma,[],2) ./ sqrt(N);
v.error.gstar = nanstd(gstar,[],2) ./ sqrt(N);
v.error.gp = nanstd(gp,[],2) ./ sqrt(N);
v.error.gpp = nanstd(gpp,[],2) ./ sqrt(N);
v.error.nstar = nanstd(nstar,[],2) ./ sqrt(N);
v.error.np = nanstd(np,[],2) ./ sqrt(N);
v.error.npp = nanstd(npp,[],2) ./ sqrt(N);
v.n = N;
% plot output
if (nargin < 4) j j ...
isempty(plot results) j j ...
strncmp(plot results,'y',1)
fig1 = figure; fig2 = figure;
plot ve(v, freq type, fig1, 'Gg');
plot ve(v, freq type, fig2, 'Nn');
end;
2