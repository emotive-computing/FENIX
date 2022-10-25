## FENIX 

### Summary and requirements

This repository contains FMRI, FNIRS and EEG code related to preprocessing and analysis of FENIX project data

#### FMRI
- code runs ok on MATLAB 2019b

- code requires CANLAB core tools (https://github.com/canlab) and a few other tools, all loaded using a2_mc_set_up_paths.m

#### FNIRS 
- add requirements 

#### EEG
- add requirements 

### Documents 

[Google Drive link to notes](https://docs.google.com/document/d/1-fGsBUktHSFKVsCYtNA6UotB3DEnhiP-hHVsiIQ-vII/edit#heading=h.glwm6zv7e37q)

[Google Drive link to manuscript in prep](https://docs.google.com/document/d/1x-_4xzOVYwPUOoxKXfudr2lgQajNFIMBavWwFpIbG10/edit#)

[Google Drive link to slide deck](https://docs.google.com/presentation/d/1BpNJ1DfFCyTr3aQs5p4XsXLKvtmAFrIB/edit?usp=sharing&ouid=109717606940615674738&rtpof=true&sd=true)

### FMRI & FNIRS Preprocessed Data 
data and results are in Google Drive, currently available to those with Edit permissions (contact: marta.ceko@gmail.com):

[Google Drive link to data](https://drive.google.com/drive/folders/1LsLdkWb098rVNOOmpM-PlPb5Fmo0iHVn?usp=sharing)


### FMRI & FNIRS correlations 
- in scripts/scriptscorr


### FMRI: Overview of scripts

(1) BIDS formatting: fenixfmri_bids.m 
- Cocoan's lab 'humanfmri' scripts adapted to run on FENIX fmri data 
  - can probably be (easily?) adapted for FNIRS data
  - alternatively, could try this: https://github.com/rob-luke/BIDS-NIRS-Tapping
 
(2) Preprocessing: fenixfmri_fmriprep.m
- Cocoan's lab 'humanfmri' scripts adapted to run on FENIX fmri data 

(3) GLM: First level (= subject-level) 

- n = 10 subjects x 4 tasks (finger tap, stroop, reading with affect, pain with regulation) 

- spm_get_firstlvl_dsgn_obj_[taskname].m
- spm_prep_firstlvl_models_[taskname].m
- spm_fit_firstlvl_models_[taskname].m

(4) GLM: Second level (= group-level) 

- prep_1_[taskname]_set_conditions_contrasts_colors.m
- then run prep_2_, prep_3_, c_univariate_contrast_maps (canlab core scripts) 


