% BIDS formatting based on Cocoan's code
% https://github.com/cocoanlab/humanfmri_preproc_bids

cd(scriptsdir)

%% SETUP ==================================================================
% (1) Set run number, task names, and number of disdaq
func_run_nums = [1 2 3 4 5];
run_n = length(func_run_nums);
func_tasks = {'rest', 'fingertap', 'stroop', 'reading', 'painreg'};

% for now, set to discard 18 volumes, but check before actually discarding
% (in fenixfmri_fmriprep)
disdaq_n = 0; %repmat(18, 1, run_n); %(number of TR, 1, number of run);

% (2) Name directory and subject code
study_imaging_dir ='/Users/marta/Documents/DATA/FENIX/Imaging'
subj_idx = 101:110; %[10, 24, 27:31]; % [1:34, 43:54] or [2,3,4, 5, 21];
projName = 'F'; % project name
[preproc_subject_dir, subject_code] = make_subject_dir_code(study_imaging_dir, projName,subj_idx);

num_sub = length(subject_code);

%% A. BIDS dicom to nifti =================================================
% PART A: --------------------
% 1. directories
% 2. dicom to nifti: bids
% 3. bids validation
% ----------------------------

%% A-1. Make & move directories

% Make 
for i=1:num_sub
    humanfmri_a1_make_directories(subject_code{1,i}, study_imaging_dir, func_run_nums, func_tasks);
end

% Move
cd(scriptsdir)
for i = 2:num_sub
    move_dicom_to_raw(subject_code{1,i}, study_imaging_dir, run_n);
    cd(scriptsdir)
end

%% A-2. Dicom to nifti: structural and functional

% IMPORTANT: using cocoan's lab version of dicm2nii! 
% which dicm2nii should be: /Applications/Canlab/humanfmri_preproc_bids/external/dicm2nii/dicm2nii.m

% NOTE: You can combine A-2.1-3 into one loop, I split it because I was debugging 
% -------------------------------------------------------------------------------------------------------

% A-2.1. Dicom to nifti: anat(T1)
% -----------------------------------------------------
d=datetime('now');
cd(scriptsdir)

% ~ 6 seconds per subject
for i=1:num_sub
    humanfmri_a2_structural_dicom2nifti_bids(subject_code{1,i}, study_imaging_dir);
    cd(scriptsdir)
end

% A-2.2. Dicom to nifti: functionals
% -----------------------------------------------------

% Note: this step will save 2 files: 
% one is the trimmed functional (removing disdaq volumes)
% the other one is disdaq volumes only; saved in the disdaq_dcmheaders dir) 

d=datetime('now');
cd(scriptsdir)

% takes ~10 min per subject
for i = 1:num_sub
    %humanfmri_a3_functional_dicom2nifti_bids(subject_code, study_imaging_dir, disdaq_n);
    humanfmri_a3_functional_dicom2nifti_bids(subject_code{1,i}, study_imaging_dir, disdaq_n, 'no_check_disdaq');
    cd(scriptsdir)
end  
% FAILED FOR F105 painreg - 2 runs instead of one (restarted task), did not copy properly to 'raw';
% SOLVED: re-copied correct file (1402 dicoms) _ SBref into 'dicoms',re-ran dicom 2 nifti

% A-2.3. Dicom to nifti: fmap(Distortion correction)
% -----------------------------------------------------
d=datetime('now');
cd(scriptsdir);

for i = 1:num_sub  
    %humanfmri_a4_fieldmap_dicom2nifti_bids(subject_code, study_imaging_dir);
    humanfmri_a4_fieldmap_dicom2nifti_bids(subject_code, study_imaging_dir);
    cd(scriptsdir)
end

% ORIGINAL FILE SIZES (BEFORE DISDAQ):  
% rest          - 652
% fingertap     - 326
% stroop        - 588
% reading       - 1292
% painreg       - 1402

% F101 has mismatched durations of rest (782) and reading (1286)
% F102 has mismatched duration of reading (1280)

% A-3 BIDS-validator
% -----------------------------------------------------
% http://incf.github.io/bids-validator/ in chrome
% ---> naming structure for anat/,  func/ is correct
% ---> some errors becuase I have more subfolders than BIDS expects (e.g., dicoms) 
