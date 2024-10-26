addpath(genpath('E:\MGZ_dynamics_project\HMM-MAR\HMM-MAR-master'))
addpath(genpath('E:\DST_multitask\script'))


%% HMM model prior-parameters setting

if ~exist('data','var') || ~exist('T','var')
    error('You need to load the data (data and T - see Documentation)')
end

data_modality = 'fMRI' ; % one of: 'fMRI', 'M/EEG', 'M/EEG power' or 'LFP' 
no_states = 10; % the number of states setting identical with that in Cohort 1
Hz = 0.5; % the frequency of the data
stochastic_inference = 0; % set to 1 if a normal run is too computationally expensive


if iscellstr(data) 
    dfilenames = data;
    if ~isempty(strfind(dfilenames{1},'.mat')), load(dfilenames{1},'X');
    else X = dlmread(dfilenames{1});
    end
elseif iscell(data)
    X = data{1};
end
X=X'; 

options = struct();
options.K = no_states; % number of states
options.order = 0; % no autoregressive components
options.zeromean = 0; % model the mean
options.covtype = 'full'; % full covariance matrix
options.Fs = Hz;
options.verbose = 1;
options.standardise = 0; % data is already standardised before
options.inittype = 'random';  % default is HMM-MAR
options.cyc = 1000; %default set to 1000
options.initcyc = 25; %default set to 25
options.initrep = 5;  % default to 5,
% options.repetitions = 1;
rep = 5;

if strcmp(data_modality,'fMRI') % Gaussian observation model
    options.order = 0;
    options.zeromean = 0;
    options.covtype = 'full';     
    
else
    error('Option data_modality not recognised')
end



%% analysis
load('trained_model_cohort2.mat') % trained models, state number setting at 10 identical to that in Cohort 1, reptition number at 5

%choose HMM model with the lowest free energy
hmm=hmm_all{1,find(fe(1,:) == min(fe(1,:)))};
Gamma=Gamma_all{1,find(fe(1,:) == min(fe(1,:)))};
Xi=Xi_all{1,find(fe(1,:) == min(fe(1,:)))};

post_states = vpath;
Labels_subj = reshape(post_states,size(data_t{1,1},1),length(data_t))';
Labels_subj_1 = Labels_subj;

for i=1:10
   mean_em(:,i)=getMean(hmm,i);
end

%% analysis for basic property
clear state_evo fractional_occupancy fractional_occupancy_rs fractional_occupancy_wm fractional_occupancy_em
clear mean_life mean_life_rs mean_life_wm mean_life_em state_rs state_wm state_em

rest = [1:176];
nback = [177:404];
emotion = [405:524]; % exclude unbalanced blocks

for i=1:size(Labels_subj,1)
    state_evo{1,i} = double(Labels_subj(i,1:end));
end
    
% for discovery dataset, time interval [176 228 150]
for i=1:size(state_evo,2)
    state_rs{i} = state_evo{i}(rest); %rest
    state_wm{i} = state_evo{i}(nback); %nback
    state_em{i} = state_evo{i}(emotion); %emotion
  %  state_ms{i} = state_evo{i}(549:end);
end

%% Compute the occupancy rate of each state and the mean life in subject level for a given replication
[fractional_occupancy, mean_life]  = compute_occupancy_and_mean_life_subject_wise(state_evo,K);
[fractional_occupancy_rs, mean_life_rs]  = compute_occupancy_and_mean_life_subject_wise(state_rs,K);
[fractional_occupancy_wm, mean_life_wm]  = compute_occupancy_and_mean_life_subject_wise(state_wm,K);
[fractional_occupancy_em, mean_life_em]  = compute_occupancy_and_mean_life_subject_wise(state_em,K);
%[fractional_occupancy_ms, mean_life_ms]  = compute_occupancy_and_mean_life_subject_wise(state_ms,K);


% FO of S8 during emotion condition and its correlation with CAR
load('fo_emo_cohort2.mat') % exclude subjects with missing AUCi\AUCg data
[corrE12_em, pvalueE12_em] = corr(fo_emo_cohort2, cortisol_all(total_exclude,2), 'Type', 'Pearson')

% transition complexity 
load('emotion_nback_state_sequence_cohort2.mat') % exclude subjects with missing AUCi\AUCg data

%nback
for i=1:size(T,2)
    temp = DL_Complexity(back0_Labels_subj(i,:));
    switch_0b(i,1) = temp.DLComp;
    temp = DL_Complexity(back2_Labels_subj(i,:));
    switch_2b(i,1) = temp.DLComp;
end

[corrE12_rs, pvalueE12_rs] = corr(switch_2b(total_exclude)-switch_0b(total_exclude), cortisol_all(total_exclude,1), 'Type', 'Pearson')

%emotion

clear switch_emo switch_neu
for i=1:size(T,2)
    temp = DL_Complexity(emotion_Labels_subj(i,1:end));
    switch_emo(i,1) = temp.DLComp;
    temp = DL_Complexity(neutral_Labels_subj(i,1:end));
    switch_neu(i,1) = temp.DLComp;
end

 clear reg_result reg_result_v
 [corr_c2, pvalueE2] = corr(switch_emo(total_exclude,1)-switch_neu(total_exclude,1),cortisol_all(total_exclude,1), 'Type', 'Pearson')
 

    