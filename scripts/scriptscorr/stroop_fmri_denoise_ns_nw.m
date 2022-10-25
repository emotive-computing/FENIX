
%% DENOISING OF NON-SMOOTHED DATA, DO NOT WINSORIZE
% high pass filter smoothed data - 180s = 0.005 Hz
% remove ventricles and WM signal (vw) using canonical masks 

outdir = fullfile(basedir, 'denoised_stroop'); % '/Users/marta/Documents/B_VRP/Analysis_FMRI/results'
repodir = '/Applications/Canlab/OLP4CBP';


imgs = filenames(fullfile(preprocdir, 'sub-*', 'func', 'wdcr*03_bold*.nii'), 'char'); 
subjn = size(imgs,1); % N = 10 

%
for i=1:subjn
    
    subject_dir = fileparts(fileparts(imgs(i,:))); % there might be a better way
  
    [~, subj] = fileparts(subject_dir);
    
    fprintf('\n\n******************************************************\n');
    fprintf('Working on subject: %s\n', subj);
    fprintf('******************************************************\n');
    
    % load data
    dat = fmri_data(imgs(i,:));
    
    % get nuisance
    nuisance_file = fullfile(subject_dir, 'nuisance_mat/nuisance_run3.mat'); 
    % run 1 = rest, run 2 = fingertap, run 3 = stroop, 
    % run 4 = reading, run 5 = pain(reg)

    load(nuisance_file);
    run_n = 1; 
    dat.covariates = R
    
    TR = 0.46;
    %DSGN.hpf = 180 = 0.005 Hz
    
    % main part
    dat_denoised_ns_nw = canlab_connectivity_preproc(dat, 'vw', 'hpf', [0.005], TR, 'no_plots');

    fname = fullfile(outdir, [subj '_wdcr_cleaned_nw_hpf.mat']);
    save(fname, 'dat_denoised_ns_nw', '-v7.3');
end

%%






