

%% Load data
savefilenamedata = fullfile(scriptscorrdir, 'Evalpipes_FT_data_and_rois.mat');
load(savefilenamedata);


%% Mean r per cell (ROI/ch) across 10 subjects
% pipe1_r1 is a cell arrays (10 cells), each cell is a 24 x 113 double

% extract values, then nanmean
for n = 1:10
    for m = 1:24
        for t = 1:113
    val1_r(n,m,t) = pipe1_r1{n}(m,t);
        end  
    end
end
val1_rmean = nanmean(val1_r);
val1 = (squeeze(val1_rmean(1,:,:)))';

for n = 1:10
    for m = 1:24
        for t = 1:113
    val2_r(n,m,t) = pipe2_r1{n}(m,t);
        end  
    end
end
val2_rmean = nanmean(val2_r);
val2 = (squeeze(val2_rmean(1,:,:)))';

for n = 1:10
    for m = 1:24
        for t = 1:113
    val3_r(n,m,t) = pipe3_r1{n}(m,t);
        end  
    end
end
val3_rmean = nanmean(val3_r);
val3 = (squeeze(val3_rmean(1,:,:)))';


%% compare across pipes
% size(val1_rmean) = 1 24 113
% 24 = 6 channels x 4 ROI sizes 

% ANOVA per channel/ROI size across 3 pipes
clear foranova
foranova = {}
for a = 1:24
foranova{a} = [val1(:,a) val2(:,a) val3(:,a)] 
[p(a), tbl, stats] = anova1(foranova{a})
end


% save p 
save(savefilenamedata, 'p', '-append');


% ANOVA n.s. for ROIs 1-3 = of interest (regardless of size)
% except roi 2 size 18mm, p = 0.0564 (# 20)
% significant for ROI 4 = control ROI (regardless of size) 

% conclusion: it does not matter which pipe we use


% but, I am also not interested in all 113 channels -
% pick good ones, repeat anova on those 

%% ANOVA on selected channels 

% 13, 30, 32-33, 35-41, 50-52,
% 60, 63-68, 78-80, 87-89, 99-101

clear val1_rs val2_rs val3_rs
for n = 1:10
    for m = 1:24
        for t = [13,30,32:33,35:41,50:52,60,63:68,78:80,87:89,99:101]
    val1_rs(n,m,t) = pipe1_r1{n}(m,t);
        end  
    end
end
val1_rsmean = nanmean(val1_rs);
val1_sel = (squeeze(val1_rsmean(1,:,[13,30,32:33,35:41,50:52,60,63:68,78:80,87:89,99:101])))';

for n = 1:10
    for m = 1:24
        for t = [13,30,32:33,35:41,50:52,60,63:68,78:80,87:89,99:101]
    val2_rs(n,m,t) = pipe2_r1{n}(m,t);
        end  
    end
end
val2_rsmean = nanmean(val2_rs);
val2_sel = (squeeze(val2_rsmean(1,:,[13,30,32:33,35:41,50:52,60,63:68,78:80,87:89,99:101])))';


for n = 1:10
    for m = 1:24
        for t = [13,30,32:33,35:41,50:52,60,63:68,78:80,87:89,99:101]
    val3_rs(n,m,t) = pipe3_r1{n}(m,t);
        end  
    end
end
val3_rsmean = nanmean(val3_rs);
val3_sel = (squeeze(val3_rsmean(1,:,[13,30,32:33,35:41,50:52,60,63:68,78:80,87:89,99:101])))';

%%

% ANOVA per channel/ROI size across 3 pipes
clear foranova
foranova = {}
for a = 1:24
foranova{a} = [val1(:,a) val2(:,a) val3(:,a)] 
[pss(a), tbl, stats] = anova1(foranova{a})
end


% save p 
save(savefilenamedata, 'pss', '-append');


%% DC 
% mean r in selected channels should be higher vs. all
% compare mean per ROI across channels
val1_perroi = nanmean(val1)';
val2_perroi = nanmean(val2)';
val3_perroi = nanmean(val3)';
val_perroi = [val1_perroi val2_perroi val3_perroi];
val_perroi = val_perroi([1:3,7:9,13:15,19:21],:)

val1_sel_perroi = nanmean(val1_sel)';
val2_sel_perroi = nanmean(val2_sel)';
val3_sel_perroi = nanmean(val3_sel)';
val_sel_perroi = [val1_sel_perroi val2_sel_perroi val3_sel_perroi];
val_sel_perroi = val_sel_perroi([1:3,7:9,13:15,19:21],:)

% plot this 
clear toplot 
toplot = [val_perroi val_sel_perroi];
% don't care about sign
toplot = abs(toplot)
imagesc(toplot)
clim = [0 0.5];
colorbar

% I dunno, can't tell for sure. 


%% Sum across subjects
% r; % cell array of subject level r-values
% rr = 0;
% for i = 1:length(r)
% rr = rr + atanh(r{i});
% end
% rr = tanh(rr./length(r));
% rr(pValue > 0.05) = 0;