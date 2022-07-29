 
%% prep rois 

%  ROI selection based on Neurosynth = independent ROIs

%  - corresponding to Neurosynth term 'finger tapping'

% prep spheres of different radii
% 6, 10, 14, 18 mm

cd(scriptscorrdir)

%% Identify ROIs

% SMA -
roi1_ns_sma = [-4 -6 56];   % fnirs result(old) = 27, -4, 68

% S1M1 
roi2_ns_smr = [36 -24 54];
roi3_ns_sml = [-36 -24 54];

% control
roi4_ns_dmpfc = [2 50 18]; 
roi5_ns_prec = [2 -58 46]; 
roi6_ns_mtg = [-58 -32 -8];


% roi1_to_6
rois = [-4 -6 56
    36 -24 54
    -36 -24 54
    2 50 18
    2 -58 46
    -58 -32 -8];

%% Create ROI masks

% load any img in MNI space -- doesn't matter which
img = which('gray_matter_mask.img'); 

% 6 mm radius
for i = 1:size(rois,1)
    dat = fmri_data(img);
    
    % make 6mm radius sphere. Our voxels here are 2x2x2
    indx = iimg_xyz2spheres(mm2voxel(rois(i,:),dat.volInfo),dat.volInfo.xyzlist,3);
    
    % save back into img, view to confirm, and write it to file
    dat.dat = indx; %orthviews(dat)
    write(dat, 'fname', sprintf('EvalFT_6mmroi%d.nii',i),'overwrite')
end

% 10 mm radius
for i = 1:size(rois,1)
    dat = fmri_data(img);
    
    % make 10mm radius sphere. Our voxels here are 2x2x2
    indx = iimg_xyz2spheres(mm2voxel(rois(i,:),dat.volInfo),dat.volInfo.xyzlist,5);
    
    % save back into img, view to confirm, and write it to file
    dat.dat = indx; %orthviews(dat)
    write(dat, 'fname', sprintf('EvalFT_10mmroi%d.nii',i),'overwrite')
end

% 14 mm radius
for i = 1:size(rois,1)
    dat = fmri_data(img);
    
    % make 14mm radius sphere. Our voxels here are 2x2x2
    indx = iimg_xyz2spheres(mm2voxel(rois(i,:),dat.volInfo),dat.volInfo.xyzlist,7);
    
    % save back into img, view to confirm, and write it to file
    dat.dat = indx; %orthviews(dat)
    write(dat, 'fname', sprintf('EvalFT_14mmroi%d.nii',i),'overwrite')
end

% 18 mm radius
for i = 1:size(rois,1)
    dat = fmri_data(img);
    
     % make 18mm radius sphere. Our voxels here are 2x2x2
    indx = iimg_xyz2spheres(mm2voxel(rois(i,:),dat.volInfo),dat.volInfo.xyzlist,9);
    
    % save back into img, view to confirm, and write it to file
    dat.dat = indx; orthviews(dat)
    write(dat, 'fname', sprintf('EvalFT_18mmroi%d.nii',i),'overwrite')
end



