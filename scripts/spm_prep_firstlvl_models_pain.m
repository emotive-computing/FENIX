% generate SPM-style condition

cd(scriptsdir)
DSGN = spm_get_firstlvl_dsgn_obj_painreg();

maskTRs = 0;

%% extract model data, perform sanity check and save it
for i = 1:length(DSGN.subjects) 
    nii = dir([DSGN.subjects{i},'/',DSGN.funcnames{1}]);
    if ~isempty(nii) % if has nii
        save_files = true;
        
        nii_path = [nii(1).folder, '/', nii(1).name];
        nii_hdr = read_hdr(nii_path); % used later for sanity checks

        sid = nii(1).name(11:13); % swdcrsub-F101 --- grab '101' in position 11-13

        %% create IV design
        heat1 = struct('name',{{'heat1_down'}}, ...
                    'onset', {{[]}}, ...
                    'duration', {{[]}},...
                    'tmod',{{0}});
        heat2 = struct('name',{{'heat1_neut'}}, ...
                    'onset', {{[]}}, ...
                    'duration', {{[]}},...
                    'tmod',{{0}});
        heat3 = struct('name',{{'heat1_up'}}, ...
                    'onset', {{[]}}, ...
                    'duration', {{[]}},...
                    'tmod',{{0}});
        heat4 = struct('name',{{'heat2_down'}}, ...
                    'onset', {{[]}}, ...
                    'duration', {{[]}},...
                    'tmod',{{0}});
        heat = struct('name',{{'heat2_neut'}}, ...
                    'onset', {{[]}}, ...
                    'duration', {{[]}},...
                    'tmod',{{0}});
        heat2_up = struct('name',{{'heat2_up'}}, ...
                    'onset', {{[]}}, ...
                    'duration', {{[]}},...
                    'tmod',{{0}});
                    
        cue = struct('name',{{'cue'}}, ...
                    'onset', {{[]}}, ...
                    'duration', {{[]}},...
                    'tmod',{{0}});
        rating = struct('name',{{'rating'}}, ...
                    'onset', {{[]}}, ...
                    'duration', {{[]}},...
                    'tmod',{{0}});
        perspect = struct('name',{{'perspect'}}, ...
                    'onset', {{[]}}, ...
                    'duration', {{[]}},...
                    'tmod',{{0}});

        stim_dat_fname = [sid, '_ptt.mat'];
        try % import stim data saved by matlab during scan
            stim_dat = importdata([timingspttdir,'/',stim_dat_fname]);
        catch
            error(['Could not import stimulation data for ' nii_path]);
            keyboard
        end

        ts = stim_dat.data.dat{1};
        t0 = ts{1}.runscan_starttime;
         
        for k = 1:length(ts)
            switch ts{k}.type
                case 'VI2'
                    this_persp = ts{k}.intensity;
                    perspect.onset{1} = [perspect.onset{1}, ts{k}.stim_timestamp - t0];
                    perspect.duration{1} = [perspect.duration{1}, ts{k}.total_dur_recorded];
                case 'TP'
                    switch ts{k}.intensity
                        case 'LV4'
                            switch this_persp
                                case 'up'
                                    heat1_up.onset{1} = [heat1_up.onset{1}, ts{k}.stim_timestamp - t0];
                                    heat1_up.duration{1} = [heat1_up.duration{1}, ts{k}.total_dur_recorded];
                                case 'neut'
                                    heat1_neut.onset{1} = [heat1_neut.onset{1}, ts{k}.stim_timestamp - t0];
                                    heat1_neut.duration{1} = [heat1_neut.duration{1}, ts{k}.total_dur_recorded];
                                case 'down'
                                    heat1_down.onset{1} = [heat1_down.onset{1}, ts{k}.stim_timestamp - t0];
                                    heat1_down.duration{1} = [heat1_down.duration{1}, ts{k}.total_dur_recorded];
                                otherwise
                                    warning(sprintf('Unsupported perspective %s', this_persp));
                                    continue
                            end
                        case 'LV5'
                            switch this_persp
                                case 'up'
                                    heat2_up.onset{1} = [heat2_up.onset{1}, ts{k}.stim_timestamp - t0];
                                    heat2_up.duration{1} = [heat2_up.duration{1}, ts{k}.total_dur_recorded];
                                case 'neut'
                                    heat2_neut.onset{1} = [heat2_neut.onset{1}, ts{k}.stim_timestamp - t0];
                                    heat2_neut.duration{1} = [heat2_neut.duration{1}, ts{k}.total_dur_recorded];
                                case 'down'
                                    heat2_down.onset{1} = [heat2_down.onset{1}, ts{k}.stim_timestamp - t0];
                                    heat2_down.duration{1} = [heat2_down.duration{1}, ts{k}.total_dur_recorded];
                                otherwise
                                    warning(sprintf('Unsupported perspective %s', this_persp));
                                    continue
                            end
                        otherwise
                            warning(sprintf('Unsupported TP intensity %s', ts{k}.intensity));
                            continue
                    end

                    rating.onset{1} = [rating.onset{1}, ts{k}.overall_rating_timestamp - t0];
                    rating.duration{1} = [rating.duration{1}, ts{k}.overall_RT];
                case 'WA'
                    cue.onset{1} = [cue.onset{1}, ts{k}.stim_timestamp - t0];
                    cue.duration{1} = [cue.duration{1}, ts{k}.total_dur_recorded];
                otherwise
                    error(['Stype type ''' ts{k}.type ''' not supported']);
            end
        end
        
        % add earlyVol regressors 
        nuisance_r = fullfile(DSGN.subjects{i},DSGN.multireg(6:end)); % skip ../.. (chars 1:5));
        load(nuisance_r)
        
        earlyVol = zeros(scn_num_volumes(nii_hdr.hname), maskTRs);
        for k = 1:maskTRs
            earlyVol(k,k) = 1;
        end

        R = [R, earlyVol];

        % do a sanity check on design info
        maxDesignTiming = max([heat1_down.onset{1} + heat1_down.duration{1}, ...
                heat1_neut.onset{1} + heat1_neut.duration{1}, ...
                heat1_up.onset{1} + heat1_up.duration{1}, ...
                heat2_down.onset{1} + heat2_down.duration{1}, ...
                heat2_neut.onset{1} + heat2_neut.duration{1}, ...
                heat2_up.onset{1} + heat2_up.duration{1}, ...
                cue.onset{1} + cue.duration{1},...
                rating.onset{1} + rating.duration{1},...
                perspect.onset{1} + perspect.duration{1}])
            
        % between ~630 - 637
            
        % boldDuration = nii_hdr.tdim*DSGN.tr; = 644.92
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
            save([mdl_path, heat1_down.name{1}],'-struct','heat1_down');
            save([mdl_path, heat1_neut.name{1}],'-struct','heat1_neut');
            save([mdl_path, heat1_up.name{1}],'-struct','heat1_up');
            save([mdl_path, heat2_down.name{1}],'-struct','heat2_down');
            save([mdl_path, heat2_neut.name{1}],'-struct','heat2_neut');
            save([mdl_path, heat2_up.name{1}],'-struct','heat2_up');
            
            save([mdl_path, cue.name{1}],'-struct','cue');
            save([mdl_path, rating.name{1}],'-struct','rating');
            save([mdl_path, perspect.name{1}],'-struct','perspect');
        end
    end
end
