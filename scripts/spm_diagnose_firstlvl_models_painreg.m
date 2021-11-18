
DSGN = get_firstlvl_dsgn_obj_painreg();

sid = tokenize(DSGN.subjects{i},'/');
sid = sid{end};

vifs = scn_spm_design_check([DSGN.modeldir, '/', sid],'events_only');
save([DSGN.modeldir, '/', sid, '/vifs.mat'],'vifs');
