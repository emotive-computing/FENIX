% secondlevel scripts and extract data 

% set defaults + task-specific output dirs
% ------------------------------------------------------------------------
a2_set_default_options

resultsdir = fullfile(basedir, 'results_fingertap');
figsavedir = fullfile(resultsdir, 'figures');

% 2nd level
% ------------------------------------------------------------------------

prep_1_fingertap_set_conditions_contrasts_colors

cd / 
prep_2_load_image_data_and_save

cd(scriptsdir)
prep_3_calc_univariate_contrast_maps_and_save
c_univariate_contrast_maps


% better dorsal axial view to match fNIRS map
% display thresholded maps

o2 = fmridisplay
r = region(contrast_t_unc{1}, 'noverbose');
o2 = montage(o2, 'axial', 'slice_range', [0 68], 'spacing',4, 'noverbose');
o2 = addblobs(o2, r, 'splitcolor', {[0 0 1] [0 1 1] [1 .5 0] [1 1 0]}, 'noverbose'); 
o2 = legend(o2);

figtitle = ['fingertap_01unc_axial.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
clear o2

o2 = fmridisplay
r = region(contrast_t_unc{1}, 'noverbose');
o2 = montage(o2, 'axial', 'slice_range', [40 68], 'spacing',1, 'noverbose');
o2 = addblobs(o2, r, 'splitcolor', {[0 0 1] [0 1 1] [1 .5 0] [1 1 0]}, 'noverbose'); 
o2 = legend(o2);

figtitle = ['fingertap_01unc_axial_top.png'];
savename = fullfile(figsavedir,figtitle);saveas(gcf,savename); drawnow, snapnow; %close;
clear o2

% clusters with k>10 saved in r 
[results_table] = table_simple(r)
writetable(results_table, 'fingertap_clusters.txt');


rr = extract_data(r,DATA_OBJ_CON{1})
rr(15).dat