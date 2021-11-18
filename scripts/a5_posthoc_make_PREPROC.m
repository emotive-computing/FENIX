function PREPROC = a5_posthoc_make_PREPROC(subject_code, study_imaging_dir, func_run_nums, tasks)

% The function re-creates PREPROC with updated paths 
%
% :Usage:
% ::
%    subject_dir = humanfmri_a1_make_directories(subject_code, study_imaging_dir, varargin)
%
% :Inputs:
% ::
% 
% - subject_code       the subject id
%                      (e.g., subject_code = {'sub-caps001', 'sub-caps002'});
% - study_imaging_dir  the directory information for the study imaging data
%                      (e.g., study_imaging_dir = '/NAS/data/CAPS2/Imaging')
% - func_run_nums      The run num of functional data directory that you
%                      want to create. If you want to create run01,
%                      run02, func_run_nums should be 1:2
%                      If each subject has different numbers of runs, you
%                      can use cell array 
%                           e.g., func_run_nums{1} = 1:4;
%                                 func_run_nums{2} = 1:2;
%                      
% - func_tasks         Task names or other information 
%                           e.g., func_tasks = {'CAPS', 'ODOR'}
%                      If participants have different orders of the tasks,
%                      you can use the cell array to specify it. 
%                           e.g., func_tasks{1} = {'CAPS', 'ODOR'};
%                                 func_tasks{2} = {'ODOR', 'CAPS'};
%                      If one run has multiple task data, you can use
%                      func_run_nums to specify it. 
%                           e.g., func_run_nums = [1 1 2 2];
%
% * this creates bold and sbref directories for the functional runs. If you
% don't have sbref images, just delete those directories. 
%

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
    
    subject_dir = fullfile(study_imaging_dir, 'raw', subject_codes{subj_i});
    
    % anat directory
    dicomdir{1, 1} = fullfile(subject_dir, 'dicom');
    dicomdir{2, 1} = fullfile(subject_dir, 'dicom', 'anat');
    %for i = 1:2, %mkdir(dicomdir{i}); end
    
    % func directory
    j = 2;
    for i = 1:numel(func_run_nums)
        j = j + 1;
        dicomdir{j, 1} = fullfile(subject_dir, 'dicom', sprintf('func_task-%s_run-%02d_bold', tasks_cell{subj_i}{i}, func_run_nums_cell{subj_i}(i)));
        %mkdir(dicomdir{j});
        
        j = j + 1;
        dicomdir{j, 1} = fullfile(subject_dir, 'dicom', sprintf('func_task-%s_run-%02d_sbref', tasks_cell{subj_i}{i}, func_run_nums_cell{subj_i}(i)));
        %mkdir(dicomdir{j});
    end
    
    % fmap directory
    dicomdir{j+1, 1} = fullfile(subject_dir, 'dicom', 'fmap');
    %mkdir(dicomdir{j+1});
    
    PREPROC.study_imaging_dir = study_imaging_dir;
    PREPROC.study_rawdata_dir = fullfile(study_imaging_dir, 'raw');
    PREPROC.subject_code = subject_codes{subj_i};
    PREPROC.subject_dir = subject_dir;
    PREPROC.dicom_dirs = dicomdir;
    
    
    % specify location of anat_nii and anat_json
    outdir = fullfile(PREPROC.subject_dir, 'anat');
    
    [~, subj_id] = fileparts(PREPROC.subject_dir);
    info.target = [subj_id '_T1w'];
    
    filetype = {'nii', 'json'};
    
    for i = 1:numel(filetype)
        target_file = fullfile(outdir, [info.target '.' filetype{i}]);
        eval(['PREPROC.anat_' filetype{i} '_files = {''' target_file '''};']);
    end

    % specify location of func_nii and func_json
    func_dirs = PREPROC.dicom_dirs(contains(PREPROC.dicom_dirs, 'func_'));
    
    for i = 1:numel(func_dirs)
        [~, func_names{i,1}] = fileparts(func_dirs{i});
    end
    
    outdir = fullfile(subject_dir, 'func');

    [imgdir, subject_id] = fileparts(subject_dir);
    studydir = fileparts(imgdir);
    
    outdisdaqdir = fullfile(studydir, 'disdaq_dcmheaders', subject_id);

    % loop for runs
    for i = 1:numel(func_dirs)
        
        [~, subj_id] = fileparts(PREPROC.subject_dir);
        output_4d_fnames = fullfile(outdir, sprintf('%s_%s', subj_id, func_names{i}(6:end)));
        output_dcmheaders_fnames = fullfile(outdisdaqdir, sprintf('%s_%s', subj_id, func_names{i}(6:end)));
        
        if contains(output_4d_fnames, '_bold')
            PREPROC.func_bold_files{ceil(i/2),1} = filenames([output_4d_fnames '.nii'], 'char');
            PREPROC.func_bold_json_files{ceil(i/2),1} = filenames([output_4d_fnames '.json'], 'char');
        elseif contains(output_4d_fnames, '_sbref')
            PREPROC.func_sbref_files{ceil(i/2),1} = filenames([output_4d_fnames '.nii'], 'char');
            PREPROC.func_sbref_json_files{ceil(i/2),1} = filenames([output_4d_fnames '.json'], 'char');
        end
        
        PREPROC.dicomheader_files{i} = [output_dcmheaders_fnames '_dcmheaders.mat'];
    end
    
end

end