% Assumes p is in log space
function [ p ] = postProcess(p)
constants;
p = min(max(p, MIN_PREDICTION_L), MAX_PREDICTION_L);
return;
CUTOFF = 0.058;
DECAY = 0.7;
p_exp = exp(DECAY*p) * (CUTOFF / exp(DECAY*CUTOFF));
p = min(p,MAX_PREDICTION_L);
p(p<CUTOFF) = p_exp(p<CUTOFF);

%{
ccbias = 0.007125622;
ccslope = 0.9566299;
ccmin = 0.02596347;
ccmax = 1.408656;
cca = 0.9043918;
ccb = 7.510946E-08;
ccc = 0.04633662;

p = min(ccmax, max(ccmin, ccbias + ccslope*p));
p = 0.5*(2*p).^(cca+ccb*p+ccc*p.^p);
%}
end

