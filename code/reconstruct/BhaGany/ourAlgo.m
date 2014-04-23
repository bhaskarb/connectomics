function score = ourAlgo(F, arg)

disp("F = ");
%disp(F);

disp("arg = ");
disp(arg);

if nargin<3,
    debug_ = false; 
end

[D, G] = discretizeFluorescenceSignal(F, 'debug', debug_, 'conditioningLevel', 0.25, 'bins', [-10,0.12,10]);

disp("D  = ");
disp(size(D));

Am = computeAdjMat(D);

%convert node values to binary
%loop through binary matrix and add values to adjacency matrix.
%second threshold to retain only the highly probable links.

weight = sum(sum(Am))
probA = Am/weight
return probA
