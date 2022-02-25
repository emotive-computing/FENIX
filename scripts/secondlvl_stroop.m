% secondlevel scripts and extract data 

% set defaults + task-specific output dirs
% ------------------------------------------------------------------------
a2_set_default_options

resultsdir = fullfile(basedir, 'results_stroop');
figsavedir = fullfile(resultsdir, 'figures');

% 2nd level
% ------------------------------------------------------------------------

prep_1_stroop_set_conditions_contrasts_colors

cd / 
prep_2_load_image_data_and_save

cd(scriptsdir)
prep_3_calc_univariate_contrast_maps_and_save
c_univariate_contrast_maps


% better dorsal axial view to match fNIRS map
% display thresholded maps

% STROOP EFFECT: INCONGRUENT - CONGRUENT CONTRAST

o2 = fmridisplay
r = region(contrast_t_unc{3}, 'noverbose');
o2 = montage(o2, 'axial', 'slice_range', [0 68], 'spacing',4, 'noverbose');
o2 = addblobs(o2, r, 'splitcolor', {[0 0 1] [0 1 1] [1 .5 0] [1 1 0]}, 'noverbose'); 
o2 = legend(o2);

figtitle = ['stroop_01unc_axial.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
clear o2

o2 = fmridisplay
r = region(contrast_t_unc{3}, 'noverbose');
o2 = montage(o2, 'axial', 'slice_range', [0 20], 'spacing',1, 'noverbose');
o2 = addblobs(o2, r, 'splitcolor', {[0 0 1] [0 1 1] [1 .5 0] [1 1 0]}, 'noverbose'); 
o2 = legend(o2);

figtitle = ['stroop_01unc_axial_top.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
clear o2

% clusters with k>10 saved in r 
[results_table] = table_simple(r)
writetable(results_table, 'stroopeffect_clusters.txt');

% Left fnirs blob
rr_at_ch50 = [rr(133).dat rr(158).dat rr(166).dat rr(174).dat rr(107).dat rr(107).all_data(:,75)];
fr_at_ch50 = [4.60E-01
2.46355576
-5.49E-01
0.3391276179
1.58E+00
-9.84E-01
3.691015114
-1.03E-01
-2.21E-01
1.23E+00];
for i = 1:size(rr_at_ch50,2); corr50(i,:)= corr(fr_at_ch50, rr_at_ch50(:,i)); end

% Right fnirs blob
rr_at_ch78 = [rr(140).dat rr(143).dat rr(149).dat];
fr_at_ch78 = [0.9388369147
3.125784416
1.510560892
-0.4025915715
4.52E+00
0.2220658778
9.68E-01
7.29E-01
1.45E-01
1.332965852]; 
for i = 1:size(rr_at_ch78,2); corr78(i,:)= corr(fr_at_ch78, rr_at_ch78(:,i)); end


figure; subplot(2,3,1)
plot_correlation(rr_at_ch50(:,4),fr_at_ch50, 'xlabel', 'FMRI BOLD', 'ylabel','FNIRS HbO');
set(gca,'LineWidth', 1,'FontSize', 14);
figtitle = ['stroop_corr.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
clear o2