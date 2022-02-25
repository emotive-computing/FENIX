% run 1st-level SPM

cd(scriptsdir)
DSGN = spm_get_firstlvl_dsgn_obj_reading();

for i = 1:numel(DSGN.subjects) 
fprintf('Running on subject directory %s\n',DSGN.subjects{i});
canlab_glm_subject_levels(DSGN,'subjects',DSGN.subjects(i))
end

%% run this to output vifs and create displays
sid = strsplit(DSGN.subjects{i},'/');
sid = sid{end};
logDir=[DSGN.modeldir, '/', sid, '_diagnostics'];

p = struct('useNewFigure', false, 'maxHeight', 800, 'maxWidth', 1600, ...
    'format', 'html', 'outputDir', logDir, ...
    'showCode', true);

mkdir(logDir);

publish('spm_diagnose_firstlvl_models_painreg.m',p)
