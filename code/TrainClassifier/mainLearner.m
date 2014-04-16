function [trainPredictions m] = mainLearner(dat,truthValues,classifier,debug_,scoringMethods)
[trainPredictions m] = mainLearner(dat,truthValues,classifier,debug_,scoringMethods)
% main file to call for training data of connectomics challenge
% INPUT
% dat: is Txn dataset, where T = total time steps and n = total neurons 
% scoringMethods: cell array having names of scoringMethods to extract from the dataset.
% truthValues is the ground truth values for network connections nxn matrix
% 
% By default scoringMethods will be set to
% {@computeCrossCorrelation,@computeGTE,@computeIGGini,@computeIGEntropy};

%==========================================================================
% Package: ChaLearn Connectomics Challenge Sample Code
% Source: http://connectomics.chalearn.org
% Authors: Mehreen Saeed
% Date: Jan 2014
% Last modified: NA
% Contact: causality@chalearn.org
% License: GPL v3 see http://www.gnu.org/licenses/
%==========================================================================


%% set the parameters
%the classifier
if nargin<3    classifier = zarbi; end
%debug values
if nargin<4    debug_ = true; end
%scoring methods/coefficients to use for feature extraction
if nargin<5    scoringMethods = {@computeCrossCorrelation,@computeGTE,@computeIGGini,@computeIGEntropy}; end 
% size of data
[T n] = size(dat);

%% ----------------extract features
if debug_
    fprintf('Extracting features ...\n');
end

featureMatrix = extractFeatures(dat,debug_,scoringMethods);


%% ----------------generate the labels as +1/-1 for Zarbi
labels = reshape(full(truthValues),n*n,1);
labels(labels==0)=-1;

%% -----------------train data
if debug_
    fprintf('Done feature extraction...now training ...\n');
end

trainData.X=featureMatrix;
trainData.Y=labels;
[trainPredictions trainModel] = train(classifier,trainData);

%% -----------------set the output values
trainPredictions = trainPredictions.X;

%% -----------------construct m the model
m.scoringMethods = scoringMethods;
m.trainModel = trainModel;

if debug_
    fprintf('Training done ...\n');
end
