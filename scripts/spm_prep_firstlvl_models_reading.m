% generate SPM-style conditions, four files per subject

cd(scriptsdir)
DSGN = spm_get_firstlvl_dsgn_obj_reading();

maskTRs = 0;  % can't remove ANY volumes, task starts immediately!

%% extract model data, perform sanity check and save it
for i = 1:length(DSGN.subjects) 
    nii = dir([DSGN.subjects{i},'/',DSGN.funcnames{1}]);
    if ~isempty(nii) % if has nii
        save_files = true;
        
        nii_path = [nii(1).folder, '/', nii(1).name];
        nii_hdr = read_hdr(nii_path); % used later for sanity checks

        sid = nii(1).name(11:13); % swdcrsub-F101 --- grab '101' in position 11-13

        %% create IV design
        
        reading1 = struct('name',{{'reading1'}}, ...
                    'onset', {{[]}}, ...
                    'duration', {{[]}},...
                    'tmod',{{0}});
        reading2 = struct('name',{{'reading2'}}, ...
                    'onset', {{[]}}, ...
                    'duration', {{[]}},...
                    'tmod',{{0}});
        questions1 = struct('name',{{'questions1'}}, ...
                    'onset', {{[]}}, ...
                    'duration', {{[]}},...
                    'tmod',{{0}});
        questions2= struct('name',{{'questions2'}}, ...
                    'onset', {{[]}}, ...
                    'duration', {{[]}},...
                    'tmod',{{0}});

        video_affect = struct('name',{{'video_affect'}}, ...
                    'onset', {{[]}}, ...
                    'duration', {{[]}},...
                    'tmod',{{0}});
        
        rating_mood = struct('name',{{'rating_mood'}}, ...
                    'onset', {{[]}}, ...
                    'duration', {{[]}},...
                    'tmod',{{0}});
                
        rating_mw = struct('name',{{'rating_mw'}}, ...
                    'onset', {{[]}}, ...
                    'duration', {{[]}},...
                    'tmod',{{0}});

        raw_dat_fname = [sid, '_trigger_data.xlsx'];
        try % import stim data saved by matlab during scan
            raw = readtable([cleanedraw,'/',raw_dat_fname]);
        catch
            error(['Could not import stimulation data for ' nii_path]);
            keyboard
        end
        
        raw.Properties.VariableNames
        %     {'id'}    {'timestamp'}    {'boot_time'}    {'time_since_boot?'}    {'trigger'}    {'trigger_string'}
        
        % define blocks and timings
        % -------------------------------------------------------------------------
        % scan start
        raw_scanstart = strcmp(raw.trigger_string, 'Scanner_Start_Received');
        
        % reading + affect induction
        raw_readstart = strcmp(raw.trigger_string, 'Reading_Section_Began');
        raw_readend = strcmp(raw.trigger_string, 'Reading_Section_Ended');
        raw_pageturn = strcmp(raw.trigger_string, 'Page_Turn');
        
        raw_videostart = strcmp(raw.trigger_string, 'Affect_Induction_Start');
        raw_videoend = strcmp(raw.trigger_string, 'Affect_Induction_End');
        
        % rating scales
        raw_ratingstart = strcmp(raw.trigger_string, 'Slider_Question_Presented');
        raw_ratingend = strcmp(raw.trigger_string, 'Slider_Question_Answered');
        raw_questionstart = strcmp(raw.trigger_string, 'Mult_Choice_Question_Presented'); %
        % raw_questionend is coded as slider_question_answered
        
        % scanstarts for fingertap (1), stroop (2), reading (3)
        t0 = raw.timestamp(raw_scanstart == 1);
        
        % task starts relative to scanstart (3)
        t_readstart = (raw.timestamp(raw_readstart == 1) - t0(3))';
        t_pagestart = (raw.timestamp(raw_pageturn == 1) - t0(3))';
        t_videostart = (raw.timestamp(raw_videostart == 1) - t0(3))';
        t_ratingstart = (raw.timestamp(raw_ratingstart == 1) - t0(3))';
        t_ratingstart = t_ratingstart((end-4):end); % for reading run
        t_questionstart = (raw.timestamp(raw_questionstart == 1) - t0(3))';
        
        % task ends
        t_readend = (raw.timestamp(raw_readend == 1) - t0(3))';
        t_videoend = (raw.timestamp(raw_videoend == 1) - t0(3))';
        t_ratingend = (raw.timestamp(raw_ratingend == 1) - t0(3))';
        t_ratingend = t_ratingend((end-10):end); % for reading run - 11 values: 5 are VAS, 6 are multiple choice questions
        
        % populate SPM-style onset + duration for each IV
        % -------------------------------------------------------------------------
        reading1.onset = {t_readstart(1)};
        reading2.onset = {t_readstart(2)};
        % do for page turns within the reading block later
        
        video_affect.onset = {t_videostart};
        
        rating_mood.onset = {t_ratingstart([1,3,4])};
        rating_mw.onset = {t_ratingstart([2,5])};
        questions1.onset = {t_questionstart(1:3)}; % first block of questions
        questions2.onset = {t_questionstart(4:6)}; % second block of questions
        
        reading1.duration = {t_readend(1) - t_readstart(1)};
        reading2.duration = {t_readend(2) - t_readstart(2)};
        video_affect.duration = {t_videoend - t_videostart};
        
        rating_mood.duration = {t_ratingend([1,3+3,4+3]) - t_ratingstart([1,3,4])}; % delay = 3 multiple choice questions
        rating_mw.duration = {t_ratingend([2,5+3]) - t_ratingstart([2,5])}; % delay = 3 multiple choice questions
        questions1.duration = {t_ratingend(3:5) - t_questionstart(1:3)}; % first block of questions
        questions2.duration = {t_ratingend(9:11) - t_questionstart(4:6)}; % second block of questions
        
        % for F101, cross-checked values against raw output in Behavior/raw_psychopy
        
        % add earlyVol regressors 
        nuisance_r = fullfile(DSGN.subjects{i},DSGN.multireg(6:end)); % skip ../.. (chars 1:5)
        load(nuisance_r)
        
        earlyVol = zeros(scn_num_volumes(nii_hdr.hname), maskTRs);
        for k = 1:maskTRs
            earlyVol(k,k) = 1;
        end

        R = [R, earlyVol];

        % do a sanity check on design info
        maxDesignTiming = max([reading1.onset{1} + reading1.duration{1}, ...
            reading2.onset{1} + reading2.duration{1}, ...
            video_affect.onset{1} + video_affect.duration{1}, ...
            rating_mood.onset{1} + rating_mood.duration{1}, ...
            rating_mw.onset{1} + rating_mw.duration{1}, ...
            questions1.onset{1} + questions1.duration{1}, ...
            questions2.onset{1} + questions2.duration{1}])
            
        % 101: 491.79, 591.56
        % 102: 595.42, 588.80
        % 103: 593.65, 594.32
        % 104: 550.95, 594.32
        % 105: 540.54, 594.32
        % 106: 585.59, 594.32
        % 107: 528.87, 594.32
        % 108: 546.74, 594.32
        % 109: 543.25, 575.00
        % 110: 563.85, 594.32
        
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
            save([mdl_path, reading1.name{1}],'-struct','reading1');
            save([mdl_path, reading2.name{1}],'-struct','reading2');
            save([mdl_path, video_affect.name{1}],'-struct','video_affect');
            save([mdl_path, rating_mood.name{1}],'-struct','rating_mood');
            save([mdl_path, rating_mw.name{1}],'-struct','rating_mw');
            save([mdl_path, questions1.name{1}],'-struct','questions1');
            save([mdl_path, questions2.name{1}],'-struct','questions2');
        end
    end
end
