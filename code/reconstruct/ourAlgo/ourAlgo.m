function score = ourAlgo(F, varargin)

%%% Assign default values
params.fast=1;
params.debug=0;
params = parse_pv_pairs(params,varargin); 

[D, G] = discretizeFluorescenceSignal(F, 'debug', params.debug, 'conditioningLevel', 0.25, 'bins', [-10,0.12,10]);

%disp("D  = ");
%disp(size(D));
newD = D - 1; %we need to do this since it seems to be discretized as 1, 2 instead of 0 - 1

if(params.fast)
	Am = computeAdjMatFast(newD);
else
	Am = computeAdjMat(newD);
endif

%convert node values to binary
%loop through binary matrix and add values to adjacency matrix.
%second threshold to retain only the highly probable links.

weight = sum(sum(Am));
score = Am/weight;
