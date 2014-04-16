function predictions = trainedPredictor(dat, modelfile, debug_)
% predictions = trainedPredictor(dat, modelfile, debug_)
%%% main file to call for generating test predictions of connectomics challenge
%%% INPUT
%%% dat: is Txn dataset, where T = total time steps and n = total neurons
%%% n should be the same as given when training data
%%% modelfile: name of a .mat saved model.
%%% classifierModel has fields:
%%% scoringMethods: coefficients computed to generate features
%%% trainingModel: contains the details of the classifier used
%%% OUTPUT
%%% predictions on dat.  returned as an nxn matrix whose (i,j)th entry
%%% indictes the strength of connection from neuron i to neuron j

%==========================================================================
% Package: ChaLearn Connectomics Challenge Sample Code
% Source: http://connectomics.chalearn.org
% Authors: Mehreen Saeed
% Date: Jan 2014
% Last modified: NA
% Contact: causality@chalearn.org
% License: GPL v3 see http://www.gnu.org/licenses/
%==========================================================================

if nargin<3    debug_ = false; end
[T n] = size(dat);

classifierModel = load(modelfile);
classifierModel = classifierModel.Model;

%% extract features
featureMatrix = extractFeatures(dat,debug_,classifierModel.scoringMethods);
%% make predictions on given data
testData.X=featureMatrix;
testData.Y=[];
predictions = test(classifierModel.trainModel,testData);
%%turn the predictions into an nxn matrix 
predictions = predictions.X;
predictions = reshape(predictions,n,n);
