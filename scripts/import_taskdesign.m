
raw = readtable(fullfile(behdatadir,'cleaned_psychopy/101_trigger_data.xlsx'));
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
t_ratingstart = t_ratingstart(5:end); % for reading run 
t_questionstart = (raw.timestamp(raw_questionstart == 1) - t0(3))';

% task ends
t_readend = (raw.timestamp(raw_readend == 1) - t0(3))';
t_videoend = (raw.timestamp(raw_videoend == 1) - t0(3))';
t_ratingend = (raw.timestamp(raw_ratingend == 1) - t0(3))';
t_ratingend = t_ratingend(5:end); % for reading run - 11 values: 5 are VAS, 6 are multiple choice questions

% populate SPM-style onset + duration for each IV
% -------------------------------------------------------------------------
reading1.onset = t_readstart(1);
reading2.onset = t_readstart(2);
% do for page turns within the reading block later

video_affect.onset = t_videostart; 

rating_mood.onset = t_ratingstart([1,3,4]);
rating_mw.onset = t_ratingstart([2,5]);
questions1.onset = t_questionstart(1:3); % first block of questions
questions2.onset = t_questionstart(4:6); % second block of questions

reading1.duration = t_readend(1) - t_readstart(1);
reading2.duration = t_readend(2) - t_readstart(2);
video_affect.duration = t_videoend - t_videostart; 

rating_mood.duration = t_ratingend([1,3+3,4+3]) - t_ratingstart([1,3,4]); % delay = 3 multiple choice questions
rating_mw.duration = t_ratingend([2,5+3]) - t_ratingstart([2,5]); % delay = 3 multiple choice questions
questions1.duration = t_ratingend(3:5) - t_questionstart(1:3); % first block of questions
questions2.duration = t_ratingend(9:11) - t_questionstart(4:6); % second block of questions 

% for F101, cross-checked values against raw output in Behavior/raw_psychopy
