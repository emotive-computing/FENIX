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


% FNIRS
% -------------------------------------------------------------------------
% preprocessed, bandpass filtered and upsampled by Emily

% find data files
fnirsdatadir = fullfile(basedir, 'fnirs_preprocessed');

load (fullfile(fnirsdatadir,'Hb_Filtered_ftonly_Fixed.mat'));

% description:
% - .probe.link: 226 lines
%              = 113 links = channels x 2 measurements:
%                odd = Hbo, even =  Hbr

% MNI_coordinates_channels.xlsx:
% Not of interest 48 channels
% leaves 65 channels to explore 

% For now, leave all in 

%% Correlation
% -------------------------------------------------------------------------
%
% -------------------------------------------------------------------------
% Within modality
% -------------------------------------------------------------------------

% 
% One subject
F101_hbo = Hb_filtered_ftonly(1,1).data(:,1:2:end);
F101_hbr = Hb_filtered_ftonly(1,1).data(:,2:2:end);
% 
% are Hbo and Hbr anti-correlated?
clear X0 Y0
figtitle = ('hbo_hbr_corr'); create_figure(figtitle);
X0 = F101_hbo;
Y0 = F101_hbr;
[r01, p0, Tstat0] = correlation_fast_series(X0, X0);
[r02, p0, Tstat0] = correlation_fast_series(Y0, Y0);
[r03, p0, Tstat0] = correlation_fast_series(X0, Y0);
subplot (2,2,1); imagesc(r01); colorbar; title ('hbo & hbo');
subplot (2,2,2); imagesc(r02); colorbar; title ('hbr & hbr');
subplot (2,2,3); imagesc(r03); colorbar; title ('hbo & hbr');
plugin_save_figure

% hbr is delayed relative to hbo - should account for delay
% hbo and BOLD are positively correlated
% but hbr and BOLD (negatively correlated) 
% are better matched timing-wise .... ?

clear X0 Y0
figtitle = ('bold_corr'); create_figure(figtitle);
X0 = F101_FT_roi
[r01, p0, Tstat0] = corrcoef(X0);
subplot (2,2,1); imagesc(r01); colorbar; title ('bold & bold');
plugin_save_figure


% -------------------------------------------------------------------------
% Between modalities
% -------------------------------------------------------------------------


% Pearson 
% -------------------------------------------------------------------------
figtitle= ('F101_FT_fnirs'); create_figure(figtitle);
X1 = F101_FT_roi
Y1 = F101_hbo;
[r1, p1, Tstat] = correlation_fast_series(X1, Y1);
subplot(2,1,1);imagesc(r1); colorbar; title ('bold & hbo');

Y2 = F101_hbr;
[r2, p2, Tstat] = correlation_fast_series(X1, Y2);
subplot(2,1,2);imagesc(r2); colorbar; title ('bold & hbr');
plugin_save_figure

% also plot p-values
figtitle= ('F101_FT_fnirs_pvalues'); create_figure(figtitle);
clims = [0 0.06];
subplot(2,1,1);imagesc(p1,clims); colorbar; title ('uncorr. p-values bold & hbo'); 
subplot(2,1,2);imagesc(p2,clims); colorbar; title ('uncorr.p-values bold & hbr'); 
plugin_save_figure


% simpified figure 
% --------------------
% roi1, 2 (visual) - ch4 (visual)
% roi3, 4 (sM) - ch99 (SM)
X11 = F101_FT_roi(:,1:4)
Y22 = F101_hbr(:,[4,99])

figtitle= ('F101_simple_FT_fnirs'); create_figure(figtitle);
[r2, p2, Tstat] = correlation_fast_series(X11, Y22);
subplot(2,2,1);imagesc(r2); colorbar; title ('Pearson r bold & hbr');
clims = [0 0.06]; 
subplot(2,2,2);imagesc(p2,clims); colorbar; title ('p values bold & hbr'); 
plugin_save_figure

subplot(2,2,3)
plot(X11(:,3))
set(gca,'XLim',[0,330])
hold on
plot(Y22(:,2))


subplot(2,2,4)
plot(X11(:,1))
hold on
plot(Y22(:,2))
set(gca,'XLim',[0,330])

plugin_save_figure

figtitle= ('FMRI_fNIRS_timeseries'); create_figure(figtitle);
subplot(2,1,1)
plot(X11(:,3))
set(gca,'XLim',[0,330])
hold on
subplot(2,1,2)
plot(Y22(:,2))
set(gca,'XLim',[0,330])

plugin_save_figure




% r2 =
% 
%    -0.1392   -0.0242
%    -0.1668   -0.1082
%     0.0283   -0.1908
%     0.0852   -0.1986
% 
% p2 =
% 
%     0.0119    0.6628
%     0.0025    0.0509
%     0.6107    0.0005
%     0.1246    0.0003
    
% Granger Causality
% -------------------------------------------------------------------------
% fmri --> fnirs hbo
[h,pValue,stat,cValue] = gctest(X1(:,3),Y1(:,4)) % p = 0.0047
[h,pValue,stat,cValue] = gctest(X1(:,4),Y1(:,4)) % p = 0.008

% fmri --> fnirs hbr
[h,pValue,stat,cValue] = gctest(X1(:,3),Y2(:,4)) % p = 0.0358
[h,pValue,stat,cValue] = gctest(X1(:,4),Y2(:,4)) % p = 0.0152


% fmri --> fnirs hbo, given hbr
[h,pValue,stat,cValue] = gctest(X1(:,3),Y1(:,4),Y2(:,4)) % p = 0.0042


