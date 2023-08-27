 
%% prep task rois 

%  ROI selection based on Neurosynth = independent ROIs

%  FT: midSMA, Left S1M1, Right S1M1 

% STROOP: dACC, Left S1M1, Right S1M1, Left dLPFC

% PAIN: dACC, Left S1M1, Right S1M1, Left S2, Right S2

% prep spheres of different radii
% 6, 10, 14, 18 mm

cd(scriptscorrdir)

%% Identify ROIs - peak MNI coords ns association test 

roi1_SMA = [-4 -6 56];  % SMA
roi2_LS1M1 = [-36 -24 54]; % L S1M1
roi3_RS1M1 = [38 -20 52]; % R S1M1
roi4_dACC = [4 22 36] % ACC 
roi5_LDLPFC = [-58 2 32]; % L DLPFC 
roi6_LS2 = [-58 -22 20]; 
roi7_RS2 = [60 -22 20];

% roi1_to_7
rois = [-4 -6 56  % SMA
        -36 -24 54 % L S1M1
        38 -20 52 % R S1M1
        4 22 36 % ACC 
        -58 2 32 % L DLPFC 
        -58 -22 20 
        60 -22 20];


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
    write(dat, 'fname', sprintf('Task_6mmroi%d.nii',i),'overwrite')
end

% 10 mm radius
for i = 1:size(rois,1)
    dat = fmri_data(img);
    
    % make 10mm radius sphere. Our voxels here are 2x2x2
    indx = iimg_xyz2spheres(mm2voxel(rois(i,:),dat.volInfo),dat.volInfo.xyzlist,5);
    
    % save back into img, view to confirm, and write it to file
    dat.dat = indx; %orthviews(dat)
    write(dat, 'fname', sprintf('Task_10mmroi%d.nii',i),'overwrite')
end

% 14 mm radius
for i = 1:size(rois,1)
    dat = fmri_data(img);
    
    % make 14mm radius sphere. Our voxels here are 2x2x2
    indx = iimg_xyz2spheres(mm2voxel(rois(i,:),dat.volInfo),dat.volInfo.xyzlist,7);
    
    % save back into img, view to confirm, and write it to file
    dat.dat = indx; %orthviews(dat)
    write(dat, 'fname', sprintf('Task_14mmroi%d.nii',i),'overwrite')
end

% 18 mm radius
for i = 1:size(rois,1)
    dat = fmri_data(img);
    
     % make 18mm radius sphere. Our voxels here are 2x2x2
    indx = iimg_xyz2spheres(mm2voxel(rois(i,:),dat.volInfo),dat.volInfo.xyzlist,9);
    
    % save back into img, view to confirm, and write it to file
    dat.dat = indx; &orthviews(dat)
    write(dat, 'fname', sprintf('Task_18mmroi%d.nii',i),'overwrite')
end

! mv Task*mm* rois

