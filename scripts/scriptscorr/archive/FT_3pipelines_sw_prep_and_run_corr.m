%% Load preprocessed data 

cd(scriptscorrdir)
% FMRI
% -------------------------------------------------------------------------
% preproc w/ fmriprep, smoothed
% high pass filter smoothed data - 180s = 0.005 Hz
% denoised: ventricles and WM signal removed using canonical masks 
% winsorized

load(fullfile(basedir,'denoised/sub-F101_swdcr_cleaned_hpf.mat'));

% Extract dat_denoised signals from rois (created in prep_rois_fingertap.m))
for i = 1:10
    roi{i} = which (sprintf('FT10mmroi%d.nii',i));
    roi_ex(i) = extract_roi_averages(dat_denoised, roi{i});
    F101_FT_roi(:,i) = roi_ex(i).dat;
end


%% FNIRS pipeline 1 
% -------------------------------------------------------------------------
% find data files
fnirsdatadir = fullfile(basedir, 'fnirs_preprocessed');
load (fullfile(fnirsdatadir,'Hb_Filtered_Pipeline1.mat'));

F101_hbo = Hb_filtered_ft(1,1).data(:,1:2:end);
F101_hbr = Hb_filtered_ft(1,1).data(:,2:2:end);

% Pearson 
% -------------------------------------------------------------------------
figtitle= ('F101_FT_pipe1_fnirs_fmri'); create_figure(figtitle);
X1 = F101_FT_roi(1:308,:); % crop to fit fnirs time-series (omit last fixation)
Y1 = F101_hbo;
[r1, p1, Tstat] = correlation_fast_series(X1, Y1);
subplot(4,2,1);imagesc(r1); colorbar; title ('F101 pipe1 bold & hbo');

Y2 = F101_hbr;
[r2, p2, Tstat] = correlation_fast_series(X1, Y2);
subplot(4,2,2);imagesc(r2); colorbar; title ('F101 pipe1 bold & hbr');

clims = [0 0.1];
subplot(4,2,3);imagesc(p1,clims); colorbar; title ('uncorr. p-values bold & hbo'); 
subplot(4,2,4);imagesc(p2,clims); colorbar; title ('uncorr. p-values bold & hbr'); 

Y1trim = F101_hbo(:,[13 26 35:41 63:68 87:89 99:101]); % somatomotor channels 
[r3, p3, Tstat] = correlation_fast_series(X1, Y1trim);
subplot(4,2,5);imagesc(r3); colorbar; title ('F101 pipe1 bold & hbo somatomotor');

Y2trim = F101_hbr(:,[13 26 35:41 63:68 87:89 99:101]);
[r4, p4, Tstat] = correlation_fast_series(X1, Y2trim);
subplot(4,2,6);imagesc(r4); colorbar; title ('F101 pipe1 bold & hbr somatomotor');

clims = [0 0.1];
subplot(4,2,7);imagesc(p3,clims); colorbar; title ('uncorr. p-values bold & hbo'); 
subplot(4,2,8);imagesc(p4,clims); colorbar; title ('uncorr. p-values bold & hbr'); 

plugin_save_figure


clear('Hb_filtered_ft');

%%
% FNIRS pipeline 2
% -------------------------------------------------------------------------
% find data files
load (fullfile(fnirsdatadir,'Hb_Filtered_Pipeline2.mat'));

F101_hbo = Hb_filtered_ft(1,1).data(:,1:2:end);
F101_hbr = Hb_filtered_ft(1,1).data(:,2:2:end);

% Pearson 
% -------------------------------------------------------------------------
figtitle= ('F101_FT_pipe2_fnirs_fmri'); create_figure(figtitle);
X1 = F101_FT_roi(1:308,:); % crop to fit fnirs time-series (omit last fixation)
Y1 = F101_hbo;
[r1, p1, Tstat] = correlation_fast_series(X1, Y1);
subplot(4,2,1);imagesc(r1); colorbar; title ('F101 pipe2 bold & hbo');

Y2 = F101_hbr;
[r2, p2, Tstat] = correlation_fast_series(X1, Y2);
subplot(4,2,2);imagesc(r2); colorbar; title ('F101 pipe2 bold & hbr');

clims = [0 0.1];Hb_filtered_ft
subplot(4,2,3);imagesc(p1,clims); colorbar; title ('uncorr. p-values bold & hbo'); 
subplot(4,2,4);imagesc(p2,clims); colorbar; title ('uncorr. p-values bold & hbr'); 

Y1trim = F101_hbo(:,[13 26 35:41 63:68 87:89 99:101]); % somatomotor channels 
[r3, p3, Tstat] = correlation_fast_series(X1, Y1trim);
subplot(4,2,5);imagesc(r3); colorbar; title ('F101 pipe2 bold & hbo somatomotor');

Y2trim = F101_hbr(:,[13 26 35:41 63:68 87:89 99:101]);
[r4, p4, Tstat] = correlation_fast_series(X1, Y2trim);
subplot(4,2,6);imagesc(r4); colorbar; title ('F101 pipe2 bold & hbr somatomotor');

clims = [0 0.1];
subplot(4,2,7);imagesc(p3,clims); colorbar; title ('uncorr. p-values bold & hbo'); 
subplot(4,2,8);imagesc(p4,clims); colorbar; title ('uncorr. p-values bold & hbr'); 

plugin_save_figure

clear('Hb_filtered_ft');


%%
% FNIRS pipeline 3
% -------------------------------------------------------------------------
% find data files
load (fullfile(fnirsdatadir,'Hb_Filtered_Pipeline3.mat'));

F101_hbo = Hb_filtered_ft(1,1).data(:,1:2:end);
F101_hbr = Hb_filtered_ft(1,1).data(:,2:2:end);

% Pearson 
% -------------------------------------------------------------------------
figtitle= ('F101_FT_pipe3_fnirs_fmri'); create_figure(figtitle);
X1 = F101_FT_roi(1:308,:); % crop to fit fnirs time-series (omit last fixation)
Y1 = F101_hbo;
[r1, p1, Tstat] = correlation_fast_series(X1, Y1);
subplot(4,2,1);imagesc(r1); colorbar; title ('F101 pipe3 bold & hbo');

Y2 = F101_hbr;
[r2, p2, Tstat] = correlation_fast_series(X1, Y2);
subplot(4,2,2);imagesc(r2); colorbar; title ('F101 pipe3 bold & hbr');

clims = [0 0.1];Hb_filtered_ft
subplot(4,2,3);imagesc(p1,clims); colorbar; title ('uncorr. p-values bold & hbo'); 
subplot(4,2,4);imagesc(p2,clims); colorbar; title ('uncorr. p-values bold & hbr'); 

Y1trim = F101_hbo(:,[13 26 35:41 63:68 87:89 99:101]); % somatomotor channels 
[r3, p3, Tstat] = correlation_fast_series(X1, Y1trim);
subplot(4,2,5);imagesc(r3); colorbar; title ('F101 pipe3 bold & hbo somatomotor');

Y2trim = F101_hbr(:,[13 26 35:41 63:68 87:89 99:101]);
[r4, p4, Tstat] = correlation_fast_series(X1, Y2trim);
subplot(4,2,6);imagesc(r4); colorbar; title ('F101 pipe3 bold & hbr somatomotor');

clims = [0 0.1];
subplot(4,2,7);imagesc(p3,clims); colorbar; title ('uncorr. p-values bold & hbo'); 
subplot(4,2,8);imagesc(p4,clims); colorbar; title ('uncorr. p-values bold & hbr'); 

plugin_save_figure

clear('Hb_filtered_ft');
 