 
%% prep rois 

%  ROI selection based on Neurosynth = independent ROIs

%  - corresponding to Neurosynth term 'stroop

% prep spheres of different radii
% 6, 10, 14, 18 mm

cd(scriptscorrdir)

%% Identify ROIs

roi1_stroop = [4 22 38];  % ACC 
roi2_stroop = [-40 6 32]; % L DLPFC1
roi3_stroop = [-42 20 28]; % L DLPFC2
roi4_stroop = [40 8 32];  % R DLPFC 
roi5_stroop = [-30 -56 48]; % L SPL
roi6_stroop = [30 -56 48]; % R SPL

rois = [4 22 38 
    -40 6 32 
    -42 20 28 
    40 8 32  
    -30 -56 48 
    30 -56 48];

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
    write(dat, 'fname', sprintf('Stroop_6mmroi%d.nii',i),'overwrite')
end

% 10 mm radius
for i = 1:size(rois,1)
    dat = fmri_data(img);
    
    % make 10mm radius sphere. Our voxels here are 2x2x2
    indx = iimg_xyz2spheres(mm2voxel(rois(i,:),dat.volInfo),dat.volInfo.xyzlist,5);
    
    % save back into img, view to confirm, and write it to file
    dat.dat = indx; %orthviews(dat)
    write(dat, 'fname', sprintf('Stroop_10mmroi%d.nii',i),'overwrite')
end

% 14 mm radius
for i = 1:size(rois,1)
    dat = fmri_data(img);
    
    % make 14mm radius sphere. Our voxels here are 2x2x2
    indx = iimg_xyz2spheres(mm2voxel(rois(i,:),dat.volInfo),dat.volInfo.xyzlist,7);
    
    % save back into img, view to confirm, and write it to file
    dat.dat = indx; %orthviews(dat)
    write(dat, 'fname', sprintf('Stroop_14mmroi%d.nii',i),'overwrite')
end

% 18 mm radius
for i = 1:size(rois,1)
    dat = fmri_data(img);
    
     % make 18mm radius sphere. Our voxels here are 2x2x2
    indx = iimg_xyz2spheres(mm2voxel(rois(i,:),dat.volInfo),dat.volInfo.xyzlist,9);
    
    % save back into img, view to confirm, and write it to file
    dat.dat = indx; orthviews(dat)
    write(dat, 'fname', sprintf('Stroop_18mmroi%d.nii',i),'overwrite')
end



