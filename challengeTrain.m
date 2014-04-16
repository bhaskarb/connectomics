%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% CHALLENGE TRAIN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Example of a Challenge submission by applying a classifier for learning. 
%%% Loads the provided fluorescence file and extracts features based on various
%%% co-efficients and applies a simple linear classifier. 
%%%
%%% See also: challengeMain.m
%%% See also: challengeFastBaseline.m
%%% See also: challengeVisualization.m

%==========================================================================
% Package: ChaLearn Connectomics Challenge Sample Code
% Source: http://connectomics.chalearn.org
% Authors: Javier Orlandi, Mehreen Saeed, Isabelle Guyon
% Date: Jan 2014
% Last modified: 01/30/2014
% Contact: causality@chalearn.org
% License: GPL v3 see http://www.gnu.org/licenses/
%==========================================================================

clear all;
clear all;

%% Begin -- User defined options --
challengeFolder = [pwd filesep];
dataDirectory = [challengeFolder 'data'];
submissionDirectory = [challengeFolder 'results'];
modelDirectory = [challengeFolder 'models'];
trainNetworkID = 'mocktrain'; % IMPORTANT: these are the base names of your data files in the data directory
testNetworkIDs =  {'mockvalid', 'mocktest'}; % Test networks eventually.
testNetworkIDs =  {}; % No test networks.
    concatenateScores = 1;           % 1 if all scores from various networks are appended to the same file (for each method)
debug_ = false;
% End -- User defined options --

%% Initializations
addpath(genpath(challengeFolder));
if ~exist(submissionDirectory,'dir') mkdir(submissionDirectory); end
if ~exist(modelDirectory,'dir') mkdir(modelDirectory); end
extension='.txt';
the_date = datestr(now, 'yyyymmddTHHMMSS');
logfile = [submissionDirectory filesep 'logfile.txt'];
flog=fopen(logfile, 'a');
fprintf('==========================================================\n');
fprintf('\n ChaLearn connectomics challenge, sample code version %s\n', this_version);
fprintf(' Date and time started: %s\n', the_date);
fprintf(' Saving AUC results in %s\n\n', logfile);
fprintf('==========================================================\n\n');

%% TRAINING

% Load the Fluorescence signal of training data
trainingFile = [dataDirectory filesep 'fluorescence_' trainNetworkID extension];
trainingData = load_data(trainingFile);
 
% Load the network truth values
trainNetworkFile = [dataDirectory filesep 'network_' trainNetworkID extension];
if ~exist(trainNetworkFile,'file')
    fprintf('Ground truth values not found.\n');
    return
end
trainNetwork = readNetworkScores(trainNetworkFile);

% Perform training with a basic method: 
% Extract features such as GTE, cross-correlation, etc., 
% then train a simple univariate linear classifier (analogous to naive Bayes)
tic
fprintf('Training the classifier...\n');
[trainPredictions, Model] = mainLearner(trainingData, trainNetwork);
fprintf('Done training\n');
training_time = toc

% Save the trained model in model folder
fprintf('Saving the trained model...\n');
modelFile = [modelDirectory filesep 'model_' trainNetworkID];
save(modelFile, 'Model');

% Compute the AUC on the training set
fprintf('Computing training ROC curve...\n');
h = figure('Name', [trainNetworkID ' ROC curve']);
[AUC, FPR, TPR, TPRatMark, raw] = computeROC(trainNetwork, trainPredictions, 'plot', h);
resuFile = [submissionDirectory filesep 'TrainedPredictor_' trainNetworkID '_' the_date];
saveas(h, resuFile, 'png');
fprintf('\n==> AUC on training Set: %5.4f\n\n', AUC);
fprintf(flog, '\n%s\tTrainedPredictor\t%s\t%5.4f\t', the_date, trainNetworkID , AUC);

%% TESTING (eventually)
scoreFile = [submissionDirectory filesep 'trainedPredictor_' sprintf('%s_', testNetworkIDs{:}) the_date];
for k=1:length(testNetworkIDs)
    testNetworkID = testNetworkIDs{k};
    
    % Load the Fluorescence signal of test data
    testFile = [dataDirectory filesep 'fluorescence_' testNetworkID extension];
    testData = load_data(testFile);

    % Find the scores on the test set
    fprintf('Computing prediction scores...\n');
    testPredictions =  mainPredictor(testData, Model, debug_);

    % Write the scores on the test to the submission directory, ready to be submitted
    resuFile = [submissionDirectory filesep 'trainedPredictor_' testNetworkID '_' the_date];
    if ~concatenateScores, scoreFile = resuFile; end
    fprintf('Writing %s\n', scoreFile);
    writeNetworkScoresInCSV(scoreFile, testPredictions, testNetworkID);

    % Compute the AUC on the test set, if the truth values are available
    % Load the network truth values
    testNetworkFile = [dataDirectory filesep 'network_' testNetworkID extension];
    if exist(testNetworkFile,'file')
        testNetwork = readNetworkScores(testNetworkFile);
        fprintf('Computing test ROC curve...\n');
        h = figure('Name', [testNetworkID ' ROC curve']);
        [AUC, FPR, TPR, TPRatMark, raw] = computeROC(testNetwork, testPredictions, 'plot', h);
        saveas(h, resuFile, 'png');
        fprintf('\n==> AUC on test Set: %5.4f\n\n', AUC);
        fprintf(flog, '%s\t%5.4f\t%5.0f', testNetworkID, AUC, training_time);
    end
end

fclose all;
MSG = 'Challenge Train script done.';
disp([datestr(now, 'HH:MM:SS'), ' ', MSG]);