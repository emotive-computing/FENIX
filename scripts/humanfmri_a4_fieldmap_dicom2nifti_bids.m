function PREPROC = humanfmri_a4_fieldmap_dicom2nifti_bids(subject_code, study_imaging_dir)

% This function saves the dicom files (subject_dir/dicoms/fmap/*) into 
% nifti files in the fmap directory (subject_dir/fmap/sub-, e.g., r01). 
%
% :Usage:
% ::
%    PREPROC = humanfmri_a4_fieldmap_dicom2nifti_bids(subject_code, study_imaging_dir)
%
% :Input:
% 
% - subject_code    the subject id
%                   (e.g., subject_code = {'sub-caps001', 'sub-caps002'});
% - study_imaging_dir  the directory information for the study imaging data
%                      (e.g., study_imaging_dir = '/NAS/data/CAPS2/Imaging')
%
% :Output(PREPROC):
% ::
%     PREPROC.fmap_nii_files
%
% ..
%     Author and copyright information:
%
%     Copyright (C) Nov 2017  Choong-Wan Woo
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
% ..


if ~iscell(subject_code)
    subject_codes{1} = subject_code;
else
    subject_codes = subject_code;
end


for subj_i = 1:numel(subject_codes)
    
    subject_dir = fullfile(study_imaging_dir, 'raw', subject_codes{subj_i});
    
    PREPROC = save_load_PREPROC(subject_dir, 'load'); % load PREPROC
    
    fmap_dir = filenames(fullfile(PREPROC.dicom_dirs{1}, 'fmap*'), 'char', 'absolute');
    
    % set the directory
    outdir = fullfile(subject_dir, 'fmap');
    if ~exist(outdir, 'dir'), mkdir(outdir); end
    
    [imgdir, subject_id] = fileparts(subject_dir);
    studydir = fileparts(imgdir);
    
    outdisdaqdir = fullfile(studydir, 'disdaq_dcmheaders', subject_id);
    
    cd(fmap_dir);
    
    dicom_imgs = filenames('*/SerieMR*', 'absolute');
    
    % renamed to match my own files: 
    
    % Don't read this too fast!! First line is DOES NOT CONTAIN! 
    dicom_imgs_ap = dicom_imgs(~contains(dicom_imgs, 'polarity_invert_to_pa'));
    dicom_imgs_pa = dicom_imgs(contains(dicom_imgs, 'polarity_invert_to_pa'));
    
    % Examples: 
%     dicom_imgs_ap =
%     {'/Users/marta/Documents/DATA/FENIX/Imaging/raw/sub-F101/dicom/fmap/fenix_distortion_corr_32ch_ap_0007/SerieMR-0007-0001-1.dcm'}
%     {'/Users/marta/Documents/DATA/FENIX/Imaging/raw/sub-F101/dicom/fmap/fenix_distortion_corr_32ch_ap_0007/SerieMR-0007-0002-1.dcm'}
%     
%     dicom_imgs_pa =
%     {'/Users/marta/Documents/DATA/FENIX/Imaging/raw/sub-F101/dicom/fmap/fenix_distortion_corr_32ch_ap_polarity_invert_to_pa_0008/SerieMR-0008-0001-1.dcm'}
%     {'/Users/marta/Documents/DATA/FENIX/Imaging/raw/sub-F101/dicom/fmap/fenix_distortion_corr_32ch_ap_polarity_invert_to_pa_0008/SerieMR-0008-0002-1.dcm'}

    
    %% PA
    dicm2nii(dicom_imgs_pa, outdir, 4, 'save_json');
    out = load(fullfile(outdir, 'dcmHeaders.mat'));
    f = fields(out.h);
    
    cd(outdir);
    nifti_3d = filenames([f{1} '*.nii']);
    
    [~, subj_id] = fileparts(PREPROC.subject_dir);
    output_4d_fnames = fullfile(outdir, sprintf('%s_dir-pa_epi', subj_id));
    
    disp('Converting 3d images to 4d images...')
    spm_file_merge(nifti_3d, [output_4d_fnames '.nii']);
    
    delete(fullfile(outdir, [f{1} '*nii']))
    
    % == change the json file name and save PREPROC
    movefile(fullfile(outdir, [f{1} '.json']), [output_4d_fnames '.json']);
    
    %% AP
    dicm2nii(dicom_imgs_ap, outdir, 4, 'save_json');
    out = load(fullfile(outdir, 'dcmHeaders.mat'));
    f = fields(out.h);
    
    nifti_3d = filenames([f{2} '*.nii']);
    
    [~, subj_id] = fileparts(PREPROC.subject_dir);
    output_4d_fnames = fullfile(outdir, sprintf('%s_dir-ap_epi', subj_id));
    
    disp('Converting 3d images to 4d images...')
    spm_file_merge(nifti_3d, [output_4d_fnames '.nii']);
    
    delete(fullfile(outdir, [f{2} '*nii']))
    
    % == change the json file name and save PREPROC
    movefile(fullfile(outdir, [f{2} '.json']), [output_4d_fnames '.json']);
    
    PREPROC.fmap_nii_files = filenames('sub*dir*.nii', 'absolute', 'char');
    
    h = out.h;
    
    output_dcmheaders_fnames = fullfile(outdisdaqdir, sprintf('%s_fmap', subj_id));
    save([output_dcmheaders_fnames '_dcmheaders.mat'], 'h');
    delete(fullfile(outdir, 'dcmHeaders.mat'));
    
    save_load_PREPROC(subject_dir, 'save', PREPROC); % save PREPROC
    disp('Done')
end

end