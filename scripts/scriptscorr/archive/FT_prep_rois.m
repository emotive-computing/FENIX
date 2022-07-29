 
%% prep rois 

%  ROI selection based on FNIRS results 

%   - significant Hbr channels: 

%   - corresponding significant FMRI coords
%      - on/near ipsi FNIRS MNI
%      - on/near contra FNIRS MNI 

%  - corresponding Neurosynth 'finger tapping'

% TO CONSIDER: 
%  - corresponding meta-analysis Witt et al. 2008 -- 
%  - atlas roi? 

% 10 mm radius 
% 20 mm radius 

cd(scriptscorrdir)
%% Identify ROIs

% Visual - but only because we have fMRI results RIGHT there
% ------------------------------------------------------------------------

roi1_ch4 = [16 -92 24]; % fnirs coord
roi2_vis = [22 -96 8]; % fmri significant cluster very close to ch4

% Premotor
% ------------------------------------------------------------------------

roi3_ch99 = [27 -4 68] % fnirs coord

% fmri significant clusters in the general somatomotor area, nothing is super close by
% p / n = positive / negative activation
% i / c = ipsilateral / contralateral 

roi4_6ma_pi = [18 2 64];  % SMA, this could be the closest

roi5_6a_pc = [-20 -8 54]; % s1/m1
roi6_6v_pi = [49 8 36];  % motor/pmc
roi7_6a_pc = [-6 -4 56];  % SMA, contra  --- matches Neurosynth peak
roi8_4_nc = [-46 -12 32]; % contra s1/m1 -negative activation

% Neurosynth
% ------------------------------------------------------------------------
% not showing any visual
% not showing any premotor areas, but here are some nearby

% SMA - see above

% S1M1 
roi9_ns_smr = [35 -23 52];
roi10_ns_sml = [-35 -23 52];

% roi1_to_10
rois = [16 -92 24; % fnirs coord
22 -96 8; % fmri significant cluster very close to ch4
27 -4 68; % fnirs coord
18 2 64;  % SMA, this could be the closest
-20 -8 54; % s1/m1
49 8 36;  % motor/pmc
-6 -4 56;  % SMA, contra  --- matches Neurosynth peak
-46 -12 32; % 
35 -23 52;
-35 -23 52];

%% Create ROI masks

% load any img in MNI space -- doesn't matter which
img = which('gray_matter_mask.img'); 

% 10 mm radius
for i = 1:size(rois,1)
    dat = fmri_data(img);
    
    % make 10mm radius sphere. Our voxels here are 2x2x2
    indx = iimg_xyz2spheres(mm2voxel(rois(i,:),dat.volInfo),dat.volInfo.xyzlist,5);
    
    % save back into img, view to confirm, and write it to file
    dat.dat = indx; %orthviews(dat)
    write(dat, 'fname', sprintf('FT10mmroi%d.nii',i),'overwrite')
end

% 20 mm radius
for i = 1:size(rois,1)
    dat = fmri_data(img);
    
    % make 10mm radius sphere. Our voxels here are 2x2x2
    indx = iimg_xyz2spheres(mm2voxel(rois(i,:),dat.volInfo),dat.volInfo.xyzlist,10);
    
    % save back into img, view to confirm, and write it to file
    dat.dat = indx; orthviews(dat)
    write(dat, 'fname', sprintf('FT20mmroi%d.nii',i),'overwrite')
end


%% Extract signal from ROIs


