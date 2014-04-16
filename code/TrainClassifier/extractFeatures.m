function featureMatrix = extractFeatures(dat,debug_,scoringMethods)
%featureMatrix = extractFeatures(dat,debug_,scoringMethods)
% extract features from connectomics data challenge and store in a training
% matrix
% INPUTS
% dat is Txn array where T=total time steps and n = total neurons 
% scoringMethods: cell array having names of scoringMethods to extract from the dataset.  
% By default scoringMethods will be set to
% {@computeCrossCorrelation,@computeGTE,@computeIGGini,@computeIGEntropy};
% OUTPUT
% featureMatrix of dimensions n^2xtotalFeatures 

%==========================================================================
% Package: ChaLearn Connectomics Challenge Sample Code
% Source: http://connectomics.chalearn.org
% Authors: Mehreen Saeed
% Date: Jan 2014
% Last modified: NA
% Contact: causality@chalearn.org
% License: GPL v3 see http://www.gnu.org/licenses/
%==========================================================================

if nargin < 2
    debug_ = false;
end

if nargin < 3
    scoringMethods = {@computeCrossCorrelation,@computeGTE,@computeIGGini,@computeIGEntropy};
end

totalscoringMethods = length(scoringMethods);
[T n] = size(dat);

featureMatrix = [];

for i=1:1:totalscoringMethods
    if debug_
        fprintf('Computing scores with %s\n', func2str(scoringMethods{i}));
    end
        
    scores = scoringMethods{i}(dat,debug_);
    %scores is an nxn matrix so reshape to 1 column and add to trainData
    featureMatrix = [featureMatrix reshape(full(scores),n*n,1)];
end
