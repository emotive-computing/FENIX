
% this file returns first level DSGN objects (see
% canlab_glm_single_subject('dsgninfo') for details on object properties)
% for QC of paingen prodicaine and control scans
function DSGN = get_firstlvl_dsgn_obj_reading()
    
    % INPUT DATA ---------------------------------------------------------- %
    DSGN.metadata = "FENIX reading: GLM first level analysis";
    DSGN.modeldir = '/Users/marta/Documents/DATA/FENIX/Imaging/firstlvl/reading'; % dir to store firslvl results
    
    DSGN.funcnames = {'func/sw*reading*.nii'}; % smoothed preproc files
    DSGN.subjects = {};
    fnames = dir('/Users/marta/Documents/DATA/FENIX/Imaging/preprocessed/sub*'); % get subject names w/ subject data 
    
    for i = 1:length(fnames)
        this_f = fnames(i);
        runs = dir([this_f.folder, '/', this_f.name, '/func/sw*reading*.nii']);
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
    DSGN.conditions = {{'reading1','reading2','video_affect', ...
        'rating_mood','rating_mw','questions1','questions2'}}; % other 
    
    DSGN.contrasts = {{{'reading1'},{'reading2'},{'video_affect'},{'rating_mood'},{'rating_mw'},{'questions1'},{'questions2'}}
                      {{'reading1'},{'reading2'},{'video_affect'},{'rating_mood'},{'rating_mw'},{'questions1'},{'questions2'}}
                      {{'reading1'},{'reading2'},{'video_affect'},{'rating_mood'},{'rating_mw'},{'questions1'},{'questions2'}}
                      {{'reading1'},{'reading2'},{'video_affect'},{'rating_mood'},{'rating_mw'},{'questions1'},{'questions2'}}};
                  
    DSGN.contrastweights = {[1 0 0 0 0 0 0], ...
                            [0 1 0 0 0 0 0], ...
                            [-1 1 0 0 0 0 0], ...
                            [0 0 1 0 0 0 0]};
    
    DSGN.contrastnames = {'read_neutral','read_affect','read_affect_min_read_neutral' ...
        'video_affect'}; 
    
    % will specify contrasts in 2nd level

    DSGN.multireg = '../../nuisance_mat/nuisance_run4.mat'; % things regressed out during preproc
    
    DSGN.modelingfilesdir = 'spm_modeling';
   
    DSGN.allowmissingcondfiles = true
end

