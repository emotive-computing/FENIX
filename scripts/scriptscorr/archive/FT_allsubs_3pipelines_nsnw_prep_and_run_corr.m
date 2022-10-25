%% Load preprocessed data 

cd(scriptscorrdir)
% FMRI
% -------------------------------------------------------------------------
% preproc w/ fmriprep, not smoothed
% high pass filter data - 180s = 0.005 Hz

subj=filenames(fullfile(basedir,'denoised/sub-F*_wdcr_cleaned_nw_hpf.mat'));

for n = 1:size(subj)

    load(subj{n});
    dat{n} = dat_denoised_ns_nw
    
    % Extract dat_denoised signals from rois (created in prep_rois_fingertap.m))
    for i = 1:10 % rois
        roi10{i} = which (sprintf('FT10mmroi%d.nii',i));
        roi_ex10(i) = extract_roi_averages(dat{n},roi10{i});
        FT_roi10(:,i,n) = roi_ex10(i).dat; % 326 x 10 x 10
    end
    
    for i = 1:10 % rois
        roi20{i} = which (sprintf('FT20mmroi%d.nii',i));
        roi_ex20(i) = extract_roi_averages(dat{n},roi20{i});
        FT_roi20(:,i,n) = roi_ex20(i).dat; % 326 x 10 x 10
    end
end

FT_roi = [FT_roi10 FT_roi20]
% 326 x 20 x 10

%% FNIRS pipeline 1 
% -------------------------------------------------------------------------
% find data files
fnirsdatadir = fullfile(basedir, 'fnirs_preprocessed');
load (fullfile(fnirsdatadir,'Hb_Filtered_Pipeline1.mat'));

% subj 9's data is too large
Hb_filtered_ft(1,9).data = Hb_filtered_ft(1,9).data(1:308,:);


% (1,n)
for m=1:size(Hb_filtered_ft,2)
    hbo(:,:,m) = Hb_filtered_ft(1,m).data(:,1:2:end);
    hbr(:,:,m) = Hb_filtered_ft(1,m).data(:,2:2:end);
end

% Pearson 
% -------------------------------------------------------------------------

clear pipe1_* 

for n = 1:10
    
    figtitle = (['subj_',num2str(n),'_FT_pipe1_nsnw_fnirs_fmri']); create_figure(figtitle);
    X1 = FT_roi(1:308,:,n); % crop to fit fnirs time-series (omit last fixation)
    Y1 = hbo(:,:,n);
    [r1, p1, Tstat] = correlation_fast_series(X1, Y1);
    subplot(4,2,1);imagesc(r1); colorbar; title (['subj' num2str(n),' pipe1 bold & hbo']);
    
    Y2 = hbr(:,:,n);
    [r2, p2, Tstat] = correlation_fast_series(X1, Y2);
    subplot(4,2,2);imagesc(r2); colorbar; title (['subj' num2str(n),' pipe1 bold & hbr']);
    
    clims = [0 0.1];
    subplot(4,2,3);imagesc(p1,clims); colorbar; title ('uncorr. p-values bold & hbo');
    subplot(4,2,4);imagesc(p2,clims); colorbar; title ('uncorr. p-values bold & hbr');
    
    Y1trim = hbo(:,[13 26 35:41 63:68 87:89 99:101],n); % somatomotor channels
    [r3, p3, Tstat] = correlation_fast_series(X1, Y1trim);
    subplot(4,2,5);imagesc(r3); colorbar; title ('bold & hbo somatomotor');
    
    pipe1_r3{n} = r3;
    pipe1_p3{n} = p3;    
    
    Y2trim = hbr(:,[13 26 35:41 63:68 87:89 99:101],n);
    [r4, p4, Tstat] = correlation_fast_series(X1, Y2trim);
    subplot(4,2,6);imagesc(r4); colorbar; title ('bold & hbr somatomotor');
    
    pipe1_r4{n} = r4;
    pipe1_p4{n} = p4;
    
    clims = [0 0.1];
    subplot(4,2,7);imagesc(p3,clims); colorbar; title ('uncorr. p-values bold & hbo');
    subplot(4,2,8);imagesc(p4,clims); colorbar; title ('uncorr. p-values bold & hbr');
    
    plugin_save_figure
end

clear('Hb_filtered_ft');

% FNIRS pipeline 2
% -------------------------------------------------------------------------
% find data files
fnirsdatadir = fullfile(basedir, 'fnirs_preprocessed');
load (fullfile(fnirsdatadir,'Hb_Filtered_Pipeline2.mat'));

% subj 9's data is too large
Hb_filtered_ft(1,9).data = Hb_filtered_ft(1,9).data(1:308,:);


% (1,n)
for m=1:size(Hb_filtered_ft,2)
    hbo(:,:,m) = Hb_filtered_ft(1,m).data(:,1:2:end);
    hbr(:,:,m) = Hb_filtered_ft(1,m).data(:,2:2:end);
end

% Pearson 
% -------------------------------------------------------------------------

clear pipe2_*

for n = 1:10
    
    figtitle = (['subj_',num2str(n),'_FT_pipe2_nsnw_fnirs_fmri']); create_figure(figtitle);
    X1 = FT_roi(1:308,:,n); % crop to fit fnirs time-series (omit last fixation)
    Y1 = hbo(:,:,n);
    [r1, p1, Tstat] = correlation_fast_series(X1, Y1);
    subplot(4,2,1);imagesc(r1); colorbar; title (['subj' num2str(n),' pipe2 bold & hbo']);
    
    Y2 = hbr(:,:,n);
    [r2, p2, Tstat] = correlation_fast_series(X1, Y2);
    subplot(4,2,2);imagesc(r2); colorbar; title (['subj' num2str(n),' pipe2 bold & hbr']);
    
    clims = [0 0.1];
    subplot(4,2,3);imagesc(p1,clims); colorbar; title ('uncorr. p-values bold & hbo');
    subplot(4,2,4);imagesc(p2,clims); colorbar; title ('uncorr. p-values bold & hbr');
    
    Y1trim = hbo(:,[13 26 35:41 63:68 87:89 99:101],n); % somatomotor channels
    [r3, p3, Tstat] = correlation_fast_series(X1, Y1trim);
    subplot(4,2,5);imagesc(r3); colorbar; title ('bold & hbo somatomotor');
    
    pipe2_r3{n} = r3;
    pipe2_p3{n} = p3;
    
    Y2trim = hbr(:,[13 26 35:41 63:68 87:89 99:101],n);
    [r4, p4, Tstat] = correlation_fast_series(X1, Y2trim);
    subplot(4,2,6);imagesc(r4); colorbar; title ('bold & hbr somatomotor');
    
    pipe2_r4{n} = r4;
    pipe2_p4{n} = p4;
    
    clims = [0 0.1];
    subplot(4,2,7);imagesc(p3,clims); colorbar; title ('uncorr. p-values bold & hbo');
    subplot(4,2,8);imagesc(p4,clims); colorbar; title ('uncorr. p-values bold & hbr');
    
    plugin_save_figure
end

clear('Hb_filtered_ft');

% FNIRS pipeline 3
% -------------------------------------------------------------------------
% find data files
fnirsdatadir = fullfile(basedir, 'fnirs_preprocessed');
load (fullfile(fnirsdatadir,'Hb_Filtered_Pipeline3.mat'));

% subj 9's data is too large
Hb_filtered_ft(1,9).data = Hb_filtered_ft(1,9).data(1:308,:);


% (1,n)
for m=1:size(Hb_filtered_ft,2)
    hbo(:,:,m) = Hb_filtered_ft(1,m).data(:,1:2:end);
    hbr(:,:,m) = Hb_filtered_ft(1,m).data(:,2:2:end);
end

% Pearson 
% -------------------------------------------------------------------------
clear pipe3_* 

for n = 1:10
    
    figtitle = (['subj_',num2str(n),'_FT_pipe3_nsnw_fnirs_fmri']); create_figure(figtitle);
    
    X1 = FT_roi(1:308,:,n); % crop to fit fnirs time-series (omit last fixation)
    Y1 = hbo(:,:,n);
    [r1, p1, Tstat] = correlation_fast_series(X1, Y1);
    subplot(4,2,1);imagesc(r1); colorbar; title (['subj' num2str(n),' pipe3 bold & hbo']);

    Y2 = hbr(:,:,n);
    [r2, p2, Tstat] = correlation_fast_series(X1, Y2);
    subplot(4,2,2);imagesc(r2); colorbar; title (['subj' num2str(n),' pipe3 bold & hbr']);
    
    clims = [0 0.1];
    subplot(4,2,3);imagesc(p1,clims); colorbar; title ('uncorr. p-values bold & hbo');
    subplot(4,2,4);imagesc(p2,clims); colorbar; title ('uncorr. p-values bold & hbr');
    
    Y1trim = hbo(:,[13 26 35:41 63:68 87:89 99:101],n); % somatomotor channels
    [r3, p3, Tstat] = correlation_fast_series(X1, Y1trim);
    subplot(4,2,5);imagesc(r3); colorbar; title ('bold & hbo somatomotor');
    
    pipe3_r3{n} = r3;
    pipe3_p3{n} = p3;
    
    Y2trim = hbr(:,[13 26 35:41 63:68 87:89 99:101],n);
    [r4, p4, Tstat] = correlation_fast_series(X1, Y2trim);
    subplot(4,2,6);imagesc(r4); colorbar; title ('bold & hbr somatomotor');
    
    clims = [0 0.1];
    subplot(4,2,7);imagesc(p3,clims); colorbar; title ('uncorr. p-values bold & hbo');
    subplot(4,2,8);imagesc(p4,clims); colorbar; title ('uncorr. p-values bold & hbr');
    
    pipe3_r4{n} = r4;
    pipe3_p4{n} = p4;
    
    plugin_save_figure
end

clear('Hb_filtered_ft');


%% Sum across subjects




r; % cell array of subject level r-values
rr = 0;
for i = 1:length(r)
rr = rr + atanh(r{i});
end
rr = tanh(rr./length(r));
rr(pValue > 0.05) = 0;