 
%% prep rois 

% 2 Control ROIs:

% - CT1: posterior temporal 
% - CT2: anterior temporal (pole

% 1 Deactivation ROI: 
% - MPFC - exceptingh inverse correlation with fNIRS signal

% prep spheres of different radii
% 6, 10, 14, 18 mm

cd(scriptscorrdir)

CT1_LPT = [-52 -40 2]; % L posterior temporal (pMTG)

CT2_LPT = [-54 4 -14]; % L temporal pole (aMTG)

% MPFC 
MPFC = [2 62 0]; % mpfc -- maybe not the best ROI?


rois= [-52 -40 2
       -54 4 -14
         2 62 0];


%% Create ROI masks

% load any img in MNI space -- doesn't matter which
img = which('gray_matter_for_roi.img'); 

% 6 mm radius
for i = 1:size(rois,1)
    dat = fmri_data(img);
    
    % make 6mm radius sphere. Our voxels here are 2x2x2
    indx = iimg_xyz2spheres(mm2voxel(rois(i,:),dat.volInfo),dat.volInfo.xyzlist,3);
    
    % save back into img, view to confirm, and write it to file
    dat.dat = indx; %orthviews(dat)
    write(dat, 'fname', sprintf('Control_6mmroi%d.nii',i),'overwrite')
end

% 10 mm radius
for i = 1:size(rois,1)
    dat = fmri_data(img);
    
    % make 10mm radius sphere. Our voxels here are 2x2x2
    indx = iimg_xyz2spheres(mm2voxel(rois(i,:),dat.volInfo),dat.volInfo.xyzlist,5);
    
    % save back into img, view to confirm, and write it to file
    dat.dat = indx; %orthviews(dat)
    write(dat, 'fname', sprintf('Control_10mmroi%d.nii',i),'overwrite')
end

% 14 mm radius
for i = 1:size(rois,1)
    dat = fmri_data(img);
    
    % make 14mm radius sphere. Our voxels here are 2x2x2
    indx = iimg_xyz2spheres(mm2voxel(rois(i,:),dat.volInfo),dat.volInfo.xyzlist,7);
    
    % save back into img, view to confirm, and write it to file
    dat.dat = indx; %orthviews(dat)
    write(dat, 'fname', sprintf('Control_14mmroi%d.nii',i),'overwrite')
end

% 18 mm radius
for i = 1:size(rois,1)
    dat = fmri_data(img);
    
     % make 18mm radius sphere. Our voxels here are 2x2x2
    indx = iimg_xyz2spheres(mm2voxel(rois(i,:),dat.volInfo),dat.volInfo.xyzlist,9);
    
    % save back into img, view to confirm, and write it to file
    dat.dat = indx; %orthviews(dat)
    write(dat, 'fname', sprintf('Control_18mmroi%d.nii',i),'overwrite')
end

! mv Control*mm* rois

