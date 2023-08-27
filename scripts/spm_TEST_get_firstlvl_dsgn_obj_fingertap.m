
% this file returns first level DSGN objects (see
% canlab_glm_single_subject('dsgninfo') for details on object properties)
% for QC of paingen prodicaine and control scans
function DSGN = get_firstlvl_dsgn_obj_fingertap()
    
    % INPUT DATA ---------------------------------------------------------- %
    DSGN.metadata = "FENIX fingertap: GLM first level analysis";
    DSGN.modeldir = '/Users/mace2098/DATA/FENIX/Imaging_test/firstlvl/fingertap'; % dir to store firslvl results

    DSGN.funcnames = {'func/w*fingertap*.nii'}; % smoothed preproc files
    DSGN.subjects = {};
    fnames = dir('/Users/mace2098/DATA/FENIX/Imaging_test/preprocessed/sub*'); % get subject names w/ subject data 
    
    for i = 1:length(fnames)
        this_f = fnames(i);
        runs = dir([this_f.folder, '/', this_f.name, '/func/w*fingertap*.nii']);
        DSGN.subjects = [DSGN.subjects, [this_f.folder, '/', this_f.name]]; % cell array of subject directories (absolute paths)
    end
    
    
    % SET PARAMETERS ------------------------------------------------------ %
    DSGN.concatenation = {}; % default 
    DSGN.allowmissingfunc = true; % default 
    
    DSGN.tr = 0.46; % repetition time in seconds 
    DSGN.hpf = 180; % Tor recommends (SPM default of 128 might be too short to capture pain)
    DSGN.ar1 = false; % Tor insists :) - algorithm pools across the whole brain and does not perform well in some situations
    DSGN.notimemod = true; % am not expecting linear trends over time 
    DSGN.singletrials = {{}}; % not doing single trial analysis

    % slice-timing related stuff can be kept at SPM default for our sequence
    % (multiband w/o slice-timing correction)
    DSGN.fmri_t = 16; % default
    DSGN.fmri_t0 = 1; % default 
    
    % MODELING ------------------------------------------------------------ %
    DSGN.conditions = {{'tap_on'}}; % other 
    
    % will specify contrast in 2nd level (equals beta_0001)

    DSGN.multireg = '../../nuisance_mat/nuisance_run2.mat'; % things regressed out during preproc
    
    DSGN.modelingfilesdir = 'spm_modeling';
   
    DSGN.allowmissingcondfiles = true
end

