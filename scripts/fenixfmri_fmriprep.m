% Preprocessing of task data using fmriprep and some canlab tools 
% - based on Cocoan's code
% https://github.com/cocoanlab/humanfmri_preproc_bids

% INPUTS
% bids-formatted files (created in fenixfmri_bids.m)


% OUTPUTS
% final files are swdcr 
% nuisance regressors are in nuisance_mat (saved as variable named R, so
% that SPM can read it)

cd(scriptsdir);

%% SETUP (same as fenixfmri_bids.m) ==================================================================
% (1) Set run number, task names, and number of disdaq
func_run_nums = [1 2 3 4 5];
run_n = length(func_run_nums);
func_tasks = {'rest', 'fingertap', 'stroop', 'reading', 'painreg'};

% (2) Name directory and subject code
study_imaging_dir ='/Users/marta/Documents/DATA/FENIX/Imaging'
subj_idx = 101:110; %[10, 24, 27:31]; % [1:34, 43:54] or [2,3,4, 5, 21];
projName = 'F'; % project name
[preproc_subject_dir, subject_code] = make_subject_dir_code(study_imaging_dir, projName,subj_idx);

num_sub = length(subject_code);

%% B. COCOANLAB PREPROC =================================================

% PART B: --------------------
% 3. disdaq & visualization/qc (canlab)
% 4. motion correction (realignment)
% 5. EPI normalization
% 6. Smoothing
% 7. ICA-AROMA
% ----------------------------
d=datetime('now');

%% re-create PREPROC with updates filepaths 
for i=1:num_sub
    a5_posthoc_make_PREPROC(subject_code{1,i}, study_imaging_dir, func_run_nums, func_tasks);
end

for i=1:num_sub
    a6_posthoc_append_PREPROC(subject_code{1,i}, study_imaging_dir, func_run_nums, func_tasks);
end

%% B-1. Make Preprocessed  Directories (in [preprocessed] folder)
humanfmri_b1_preproc_directories(subject_code, study_imaging_dir); %'forced_save', 'no_save'
% creates empty dirs in preprocessed (anat, fmap, func, mean_func, qc_images

%% B-2. Implicit mask and save means (~5 min per subject)
humanfmri_b2_functional_implicitmask_savemean(preproc_subject_dir);
% creates:
% [mean_func], 'mean_beforepreproc_..._.bold.nii' files  for each run. 
% 'implicit_mask.nii' 
% skipped creating .png files in qc_images (commented out canlab_preproc_show_montage, not crucial) 

%% B-3. Spike id (~4 min per subject)
humanfmri_b3_spike_id(preproc_subject_dir);
% creates 'qc_spike_...bold.png' and 'qc_diary...'

%% B-4. Slice timing correction: Skipped due to short TR (460ms)
% tr = .46;
% mbf = 8;
% humanfmri_b4_slice_timing(preproc_subject_dir, tr, mbf);

%% B-5. Motion correction (prepends r) (~35 min per subject) 
cd(scriptsdir)
use_st_corrected_data = false;
use_sbref = true;
humanfmri_b5_motion_correction(preproc_subject_dir, use_st_corrected_data, use_sbref);
% skipped creating .png files in qc_images (commented out canlab_preproc_show_montage, not crucial) 

%% B-6. distortion correction (FSL topup) (prepends dc) (~xx min per subject)
cd(scriptsdir)
epi_enc_dir = 'ap';
use_sbref = true;
humanfmri_b6_distortion_correction(preproc_subject_dir, epi_enc_dir, use_sbref, 'run_num', 1:5)
% skipped creating .png files in qc_images (commented out canlab_preproc_show_montage, not crucial) 

%% B-7. coregistration (spm_check_registration.m) (~ 1 min per subject)
cd(scriptsdir)
use_sbref = true;
%humanfmri_b7_coregistration(preproc_subject_dir, use_sbref);
humanfmri_b7_coregistration(preproc_subject_dir, use_sbref, 'no_check_reg');

%% B-8-1. T1 Segmentation and Normalization (prepends 'w') (~ 22 min per subject)
% Make sure'TPM.nii' is on path (loaded in a2_mc_set_up_paths.m)
cd(scriptsdir)
use_sbref = true;
%humanfmri_b8_normalization(preproc_subject_dir, use_sbref);
humanfmri_b8_normalization(preproc_subject_dir, use_sbref, 'no_check_reg');
% skipped creating .png files in qc_images (commented out canlab_preproc_show_montage, not crucial) 
% done for 1-7

%% B-10. Smoothing (prepends 's') (~14 min per subject)
cd(scriptsdir)
humanfmri_b9_smoothing(preproc_subject_dir, 'fwhm', 6);
% skipped creating .png files in qc_images (commented out canlab_preproc_show_montage, not crucial) 
% done for 1

%% Part C: Check Framewise Displacement and make Nuisance Regressors
% C-1
% humanfmri_c1_move_clean_files

% C-2 (~1 min total)
humanfmri_c2_get_framewise_displacement(preproc_subject_dir)

% C-3 (~4 min per subject)
% makes nuisance regressors per each run in the new 'nuisance_mat' folder. (Done in half hour)
humanfmri_c3_make_nuisance_regressors(preproc_subject_dir)
%make_nuisance_regressors(PREPROC,'regressors',{'24Move','Spike','WM_CSF'})
%make_nuisance_regressors(PREPROC,'img','swr_func_bold_files')




