function PREPROC = a6_posthoc_append_PREPROC(subject_code, study_imaging_dir, func_run_nums, tasks)

% The function appends to PREPROC in /preprocessed  


if ~iscell(subject_code)
    subject_codes{1} = subject_code;
    tasks_cell{1} = tasks;
    func_run_nums_cell{1} = func_run_nums;
else
    subject_codes = subject_code;
    
    if ischar(tasks) % if tasks is char
        for subj_i = 1:numel(subject_codes)
            tasks_cell{subj_i} = tasks; 
        end
    elseif numel(subject_codes) ~= numel(tasks) % tasks is cell, but multiple tasks
        for subj_i = 1:numel(subject_codes)
            tasks_cell{subj_i} = tasks; 
        end
    else % if tasks is cell and each cell for each subject
        tasks_cell = tasks;
    end
    
    if ~iscell(func_run_nums) % if func_run_nums is not in the cell
        for subj_i = 1:numel(subject_codes)
            func_run_nums_cell{subj_i} = func_run_nums;
        end
    end
end

for subj_i = 1:numel(subject_codes)
    
    subject_dir = fullfile(study_imaging_dir, 'preprocessed', subject_codes{subj_i});
   
    PREPROC = save_load_PREPROC(subject_dir, 'load'); % load PREPROC

    fmap_dir = filenames(fullfile(PREPROC.dicom_dirs{1}, 'fmap*'), 'char', 'absolute');
    
    % set the directory
    raw_dir = fullfile(study_imaging_dir, 'raw', subject_codes{subj_i});
   
    outdir = fullfile(raw_dir, 'fmap');

    [imgdir, subject_id] = fileparts(subject_dir);
    studydir = fileparts(imgdir);
   
    cd(outdir);
    PREPROC.fmap_nii_files = filenames('sub*dir*.nii', 'absolute', 'char');
    
    save_load_PREPROC(subject_dir, 'save', PREPROC); % save PREPROC
    disp('Done')
    
end

end