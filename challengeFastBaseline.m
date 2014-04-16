%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%               CHALLENGE FAST BASELINE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Example generating a challenge submission using the @data object.
%%% This example runs faster that challengeMain, but we implemented only
%%% correlation as a reconstruction algorithm so far.
%%%
%%% See also: challengeMain.m
%%% See also: challengeTrain.m
%%% See also: challengeVisualization.m

%==========================================================================
% Package: ChaLearn Connectomics Challenge Sample Code
% Source: http://connectomics.chalearn.org
% Author: Javier Orlandi, Mehreen Saeed, Isabelle Guyon
% Date: Jan 2014
% Last modified: 01/30/2014
% Contact: causality@chalearn.org
% License: GPL v3 see http://www.gnu.org/licenses/
%==========================================================================

clear all;
close all;

%% Begin -- User defined options --
challengeFolder = [pwd filesep];
dataDirectory = [challengeFolder 'data'];
submissionDirectory = [challengeFolder 'results']; % Where ready-to-submit result files are found
networkIdNames = {'mockvalid', 'mocktest'};        % IMPORTANT: these are the base names of your data files in the data directory
concatenateScores = 1; % 1 if all scores from various networks are appended to the same file (for each method)
scoringMethod = 'Correlation'; % Just this one for now...
% End -- User defined options --

addpath(genpath(challengeFolder));
if ~exist(submissionDirectory,'dir') mkdir(submissionDirectory); end
the_date = datestr(now, 'yyyymmddTHHMMSS');
scoreFile = [submissionDirectory filesep scoringMethod '_' sprintf('%s_', networkIdNames{:}) the_date '.csv'];

%% Loop over all networks you want to process 
filenames = cell(length(networkIdNames),1);
for k=1:length(networkIdNames)
    mydata = data(dataDirectory, networkIdNames{k}); % Load the data
    score(mydata, scoringMethod); 
    fn = write_score(mydata, submissionDirectory, scoringMethod); % Save the predictions in Kaggle format
    filenames{k} = fn{1};
end

if concatenateScores
    concatenateFiles(filenames, scoreFile);
end

MSG = 'Challenge solved.';
disp([datestr(now, 'HH:MM:SS'), ' ', MSG]);