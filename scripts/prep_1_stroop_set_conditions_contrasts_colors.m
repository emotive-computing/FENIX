%% Set up conditions 
% ------------------------------------------------------------------------

% conditions = {'C1' 'C2' 'C3' 'etc'};
% structural_wildcard = {'c1*nii' 'c2*nii' 'c3*nii' 'etc*nii'};
% functional_wildcard = {'fc1*nii' 'fc2*nii' 'fc3*nii' 'etc*nii'};
% colors = {'color1' 'color2' 'color3' etc}  One per condition

fprintf('Image data should be in /data folder\n');

DAT = struct();

% Names of subfolders in /data

DAT.subfolders =    {'firstlvl/stroop/sub*' 'firstlvl/stroop/sub*'};
                                               
% Names of conditions (see end of file for list of conditions as specified
% in 1st level DSGN.mat file

DAT.conditions = {'congruent','incongruent'};

DAT.conditions = format_strings_for_legend(DAT.conditions);

DAT.structural_wildcard = {};

DAT.functional_wildcard =  {'beta_0001.nii' 'beta_0002.nii'}; 


%% Set Contrasts
% ------------------------------------------------------------------------
% Vectors across conditions
DAT.contrasts = [1 0;
                 0 1;
                -1 1]; 

DAT.contrastnames = {'congruent', 'incongruent', 'incon_vs_con'}; 


DAT.contrastnames = format_strings_for_legend(DAT.contrastnames);

% Set Colors

mycolors = colorcube_colors(length(DAT.conditions) + size(DAT.contrasts, 1));

DAT.colors = mycolors(1:length(DAT.conditions));
DAT.contrastcolors = mycolors(length(DAT.conditions) + 1:length(mycolors));


disp('SET up conditions, colors, contrasts in DAT structure.');


DAT.between_condition_cons = [];

DAT.between_condition_contrastnames = {};
          
DAT.between_condition_contrastcolors = custom_colors ([.2 .2 .8], [.2 .8 .2], size(DAT.between_condition_cons, 1));

