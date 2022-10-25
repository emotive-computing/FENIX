

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


