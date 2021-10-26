% NOTES:
% - standard folders and variable names are created by this script

% Set up paths
% --------------------------------------------------------

% Base directory for whole study/analysis

basedir = '/Volumes/GoogleDrive/My Drive/B_FENIX/Analysis'


cd(basedir)

% datadir = fullfile(basedir, 'data');

datadir = 'Volumes/GoogleDrive/My Drive/B_FENIX/Data'

resultsdir = fullfile(basedir, 'results');
scriptsdir = fullfile(basedir, 'scripts');
figsavedir = fullfile(resultsdir, 'figures');

roidir = fullfile(basedir, 'rois');

if ~exist(resultsdir, 'dir'), mkdir(resultsdir); end
if ~exist(scriptsdir, 'dir'), mkdir(scriptsdir); end
if ~exist(figsavedir, 'dir'), mkdir(figsavedir); end
if ~exist(roidir, 'dir'), mkdir(roidir); end

addpath(scriptsdir)

% You may need this, but now should be in CANlab Private repository
% g = genpath('/Users/tor/Documents/matlab_code_external/spider');
% addpath(g)

% Display helper functions: Called by later scripts

dashes = '----------------------------------------------';
printstr = @(dashes) disp(dashes);
printhdr = @(str) fprintf('%s\n%s\n%s\n', dashes, str, dashes);
