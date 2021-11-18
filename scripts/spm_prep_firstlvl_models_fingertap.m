% generate SPM-style conditions, four files per subject

cd(scriptsdir)
DSGN = spm_get_firstlvl_dsgn_obj_fingertap();

maskTRs = 0; % can't remove ANY volumes, task starts immediately!

%% extract model data, perform sanity check and save it
for i = 1:length(DSGN.subjects) 
    nii = dir([DSGN.subjects{i},'/',DSGN.funcnames{1}]);
    if ~isempty(nii) % if has nii
        save_files = true;
        
        nii_path = [nii(1).folder, '/', nii(1).name];
        nii_hdr = read_hdr(nii_path); % used later for sanity checks

        sid = nii(1).name(11:13); % swdcrsub-F101 --- grab '101' in position 11-13

        %% create IV design
        tap_on = struct('name',{{'tap_on'}}, ...
                    'onset', {{[]}}, ...
                    'duration', {{[]}},...
                    'tmod',{{0}});

        stim_dat_fname = [sid, '_finger_tapping.mat'];
        try % import stim data saved by matlab during scan
            stim_dat = importdata([timingspsychodir,'/',stim_dat_fname]);
        catch
            error(['Could not import stimulation data for ' nii_path]);
            keyboard
        end
        
        % warning, durations and onsetsw were switched: 
        tap_on.onset = {stim_dat.durations}; 
        tap_on.duration = {stim_dat.onsets};
        
        % add earlyVol regressors 
        nuisance_r = fullfile(DSGN.subjects{i},DSGN.multireg(6:end)); % skip ../.. (chars 1:5)
        load(nuisance_r)
        
        earlyVol = zeros(scn_num_volumes(nii_hdr.hname), maskTRs);
        for k = 1:maskTRs
            earlyVol(k,k) = 1;
        end

        R = [R, earlyVol];

        % do a sanity check on design info
        maxDesignTiming = max(tap_on.onset{1} + tap_on.duration{1})
            
        %  ~ 142
            
        % boldDuration = nii_hdr.tdim*DSGN.tr; = 149.96
        boldDuration = scn_num_volumes(nii_hdr.hname)*DSGN.tr
        
        if boldDuration < maxDesignTiming
            warning(['Max stimulus timing (' int2str(maxDesignTiming) 's) exceeds BOLD duration (' int2str(boldDuration) ,'s) for ' sid ' run ' int2str(j), ', skipping ...']);
            continue
        end
        
        % do also for nuisance regressors
        if scn_num_volumes(nii_hdr.hname) ~= size(R,1)
            warning('noise data length does not match nifti TR length ... skipping...');
            continue
        end

        if save_files
            mkdir(nii(1).folder,DSGN.modelingfilesdir)
            mdl_path = [nii(1).folder, '/', DSGN.modelingfilesdir, '/'];
            save([mdl_path, tap_on.name{1}],'-struct','tap_on');
        end
    end
end
