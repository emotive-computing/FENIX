% BIDSing and preprocessing based on Wani's code

cd(scriptsdir)

%% SETUP ==================================================================
% (1) Set run number, task names, and number of disdaq
func_run_nums = [1 2 3 4 5];
run_n = length(func_run_nums);
func_tasks = {'rest', 'fingertap', 'stroop', 'reading', 'painreg'};

% for now, set to discard 18 volumes, but check before discarding
disdaq_n = repmat(18, 1, run_n); %(number of TR, 1, number of run);

% (2) Name directory and subject code
study_imaging_dir = '/Volumes/GoogleDrive/My Drive/B_FENIX/Data/FMRI/Imaging/';
subj_idx = 101:110; %[10, 24, 27:31]; % [1:34, 43:54] or [2,3,4, 5, 21];
projName = 'F'; % project name
[preproc_subject_dir, subject_code] = make_subject_dir_code(study_imaging_dir, projName,subj_idx);

num_sub = length(subject_code);

%% A. BIDS dicom to nifti =================================================
% PART A: --------------------
% 1. dicom to nifti: bids
% 2. bids validation
% ----------------------------

%% A-1. Make directories
for i=1:num_sub
    humanfmri_a1_make_directories(subject_code{1,i}, study_imaging_dir, func_run_nums, func_tasks);
end

%% Move Directories
cd(scriptsdir)
for i = 1:num_sub
    move_dicom_to_raw(subject_code{1,i}, study_imaging_dir, run_n);
    cd(scriptsdir)
end

%% A-2. Dicom to nifti: structural and functional

% IMPORTANT: using cocoan's lab version of dicm2nii! 
% which dicm2nii should be: /Applications/Canlab/humanfmri_preproc_bids/external/dicm2nii/dicm2nii.m

d=datetime('now');
cd(scriptsdir)

for i=1:num_sub
    % A-2. Dicom to nifti: anat(T1)
    humanfmri_a2_structural_dicom2nifti_bids(subject_code{1,i}, study_imaging_dir);

end

%% 
d=datetime('now');
cd(scriptsdir)
for i = 1% :num_sub
    % A-3. Dicom to nifti: functional(Run 1-5)
    
    %humanfmri_a3_functional_dicom2nifti_bids(subject_code, study_imaging_dir, disdaq_n);
    humanfmri_a3_functional_dicom2nifti_bids(subject_code{1,i}, study_imaging_dir, disdaq_n, 'no_check_disdaq');
  
    % A-4. Dicom to nifti: fmap(Distortion correction)
    
    %humanfmri_a4_fieldmap_dicom2nifti_bids(subject_code, study_imaging_dir);
    humanfmri_a4_fieldmap_dicom2nifti_bids(subject_code{1,i}, study_imaging_dir);
    
    d=[d datetime('now')];
end




