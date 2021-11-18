% THIS SCRIPT ADDS PATHS TO REPOS, SPM, USEFUL OTHER CODE

%% check for updates!
% in terminal
% cd /Applications/Canlab/
% git pull each repo

%% add Python interpreter - 3.5
% created a conda snake with python 3.5 env 
%addpath('/Anaconda3/envs/snakes/bin');

%% add repositories + help_examples
% MAIN REPO
addpath(genpath('/Applications/Canlab/CanlabCore/'));

% OTHER REPOS 
addpath(genpath('/Applications/Canlab/CANlab_help_examples/'));
addpath(genpath('/Applications/Canlab/MasksPrivate/Masks_private'));
addpath(genpath('/Applications/Canlab/Neuroimaging_Pattern_Masks'));
addpath(genpath('/Applications/Canlab/MediationToolbox')); % for RB_empirical_bayes_params ...
addpath(genpath('/Applications/Canlab/Canlab_MKDA_MetaAnalysis'));
addpath(genpath('/Applications/Canlab/ROI_masks_and_parcellations')); % copied from Tor's shared Gdrive folder
addpath(genpath('/Applications/Canlab/2017_kragel_mfc_generalizability_natneurosci/')); 
addpath(genpath('/Applications/Canlab/RobustToolbox/'));
addpath(genpath('/Applications/aal')); 
addpath(genpath('/Applications/Canlab/CanlabPrivate/'));

% Lukas 
addpath(genpath('/Applications/Canlab/proj-emosymp/'));

%% also add 
% add Wani's core repo
addpath(genpath('/Applications/Canlab/cocoanCORE/'));
% Wani's BIDS and preprocessing pipeline
addpath(genpath('/Applications/Canlab/humanfmri_preproc_bids/'));

% I need wanii's version of dicm2nii:
which dicm2nii

%% add anne urai's plotting tools
addpath(genpath('/Applications/Canlab/Tools'));

% add wani's repo
addpath(genpath('/Applications/Canlab/cocoanCORE'));

%% add gm mask
masksdir = fullfile(basedir, 'masks');
addpath (genpath(masksdir))
which ('gm_mask.nii');


%% add modified scripts
% 
% modcanlabdir = fullfile(scriptsdir, 'modified_canlabcore_scripts');
% addpath (genpath(modcanlabdir))

which plugin_save_figure
fprintf ('IT PROBABLY DOES NOT SAVE PNG SO ENFORCE BELOW \n');
%edit plugin_save_figure.m
f_ext='.png';

%% for masked contrasts 
%% add ROI masks 
addpath(genpath('/Users/marta/Google Drive/ROI_masks_and_parcellations/'));
% addpath(genpath('/Users/martaceko/Downloads/ROI_masks_and_parcellations/Parcellation_images_for_studies'));

%% add spm12
% BUT NOT WITH SUBFOLDERS!
% for now, add spm12 version depending on matlab version

if version('-release') == '2019a' | '2020b' ;
   addpath /Applications/spm12; 
   fprintf ('running native spm12 with MATLAB 2019a or 2020b \n');
elseif version('-release') ~= '2019a';
    addpath /Applications/Canlab/spm12  % currently canlab-spm12 not functional; wrong MEX file?
    fprintf ('running Canlab spm12 \n');
end

fprintf ('To confirm, which spm am I running? \n');
which spm

%% add TPM map for normalization 
addpath /Applications/spm12/tpm/    

%% check that jsondecode is on path (MATLAB 2016B and later) 
which jsondecode
%built-in (/Applications/MATLAB_R2016b.app/toolbox/matlab/external/interfaces/json/jsondecode)
which imrect
%/Applications/MATLAB_R2016b.app/toolbox/images/imuitools/imrect.m  % imrect constructor

% use default nanvar if spm's throws an error (but should be fine wih spm 12) 
%addpath /Applications/MATLAB_R2015b.app/toolbox/stats/stats/

