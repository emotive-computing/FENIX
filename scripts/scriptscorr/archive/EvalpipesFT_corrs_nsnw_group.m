%% Load preprocessed data 

cd(scriptscorrdir)
% FMRI
% -------------------------------------------------------------------------
% preproc w/ fmriprep, not smoothed
% high pass filter data - 180s = 0.005 Hz

subj=filenames(fullfile(basedir,'denoised_fingertap/sub-F*_wdcr_cleaned_nw_hpf.mat'));
%load(fullfile(basedir,'denoised/sub-F101_wdcr_cleaned_nw_hpf.mat'));

clear FT_roi*
for n = 1:size(subj)
    
    clear dat
    
    load(subj{n});
    dat = dat_denoised_ns_nw
    
    % Extract dat_denoised signals from rois (created in prep_rois_fingertap.m))
    for i = 1:6 % rois
        roi6{i} = which (sprintf('EvalFT_6mmroi%d.nii',i));
        roi_ex6(i) = extract_roi_averages(dat,roi6{i});
        FT_roi6(:,i,n) = roi_ex6(i).dat; 
    end
    
    for i = 1:6 % rois
        roi10{i} = which (sprintf('EvalFT_10mmroi%d.nii',i));
        roi_ex10(i) = extract_roi_averages(dat,roi10{i});
        FT_roi10(:,i,n) = roi_ex10(i).dat; 
    end
    
    for i = 1:6 % rois
        roi14{i} = which (sprintf('EvalFT_14mmroi%d.nii',i));
        roi_ex14(i) = extract_roi_averages(dat,roi14{i});
        FT_roi14(:,i,n) = roi_ex14(i).dat; 
    end
        
    for i = 1:6 % rois
        roi18{i} = which (sprintf('EvalFT_18mmroi%d.nii',i));
        roi_ex18(i) = extract_roi_averages(dat,roi18{i});
        FT_roi18(:,i,n) = roi_ex18(i).dat; 
    end   
end

FT_roi = [FT_roi6 FT_roi10 FT_roi14 FT_roi18];
size(FT_roi) 
% 326 x 24 x 10

% save FT_roi
savefilenamedata = fullfile(scriptscorrdir, 'Evalpipes_FT_data_and_rois.mat');
save(savefilenamedata, 'FT_roi');

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
clear r1 p1 r2 p2

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

    pipe1_r1{n} = r1;
    pipe1_p1{n} = p1; 
    
    pipe1_r2{n} = r2;
    pipe1_p2{n} = p2; 
       
    plugin_save_figure
end

% save pipe1, clear data 
save(savefilenamedata, 'pipe1_r1', 'pipe1_p1', 'pipe1_r2', 'pipe1_p2', '-append');
clear('Hb_filtered_ft');

%% FNIRS pipeline 2
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
clear r1 p1 r2 p2

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
    
    pipe2_r1{n} = r1;
    pipe2_p1{n} = p1; 
    
    pipe2_r2{n} = r2;
    pipe2_p2{n} = p2; 
    
    plugin_save_figure
end


% save pipe1, clear data 
save(savefilenamedata, 'pipe2_r1', 'pipe2_p1', 'pipe2_r2', 'pipe2_p2', '-append');
clear('Hb_filtered_ft');


%% FNIRS pipeline 3
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
clear r1 p1 r2 p2

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
          
    pipe3_r1{n} = r1;
    pipe3_p1{n} = p1; 
    
    pipe3_r2{n} = r2;
    pipe3_p2{n} = p2; 
    
    plugin_save_figure
end

% save pipe1, clear data 
save(savefilenamedata, 'pipe3_r1', 'pipe3_p1', 'pipe3_r2', 'pipe3_p2', '-append');
clear('Hb_filtered_ft');

