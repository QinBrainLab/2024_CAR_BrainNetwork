%% addpath
addpath(genpath('E:\MGZ_dynamics_project\HMM-MAR\HMM-MAR-master'))
addpath(genpath('E:\DST_multitask\functions'))


%% HMM model prior-parameters setting

if ~exist('data','var') || ~exist('T','var')
    error('You need to load the data (data and T - see Documentation)')
end

data_modality = 'fMRI' ; % one of: 'fMRI', 'M/EEG', 'M/EEG power' or 'LFP' 
no_states = 10; % the number of states depends a lot on the question at hand
Hz = 0.5; % the frequency of the data
stochastic_inference = 0; % set to 1 if a normal run is too computationally expensive
% N = length(T); % number of subjects
% getting the number of channels

if iscellstr(data) 
    dfilenames = data;
    if ~isempty(strfind(dfilenames{1},'.mat')), load(dfilenames{1},'X');
    else X = dlmread(dfilenames{1});
    end
elseif iscell(data)
    X = data{1};
end
X=X'; 


% Setting the options

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
load('trained_model_cohort1.mat') % trained models, state number setting at 10, reptition number at 5

%choose HMM model with the lowest free energy
hmm=hmm_all{1,find(fe(1,:) == min(fe(1,:)))};
Gamma=Gamma_all{1,find(fe(1,:) == min(fe(1,:)))};
Xi=Xi_all{1,find(fe(1,:) == min(fe(1,:)))};

post_states = vpath;
Labels_subj = reshape(post_states,size(data_t{1,1},1),length(data_t))';
Labels_subj_1 = Labels_subj;

figure(7);
imagesc(Labels_subj); 
pf2 = gca;
set(pf2,'YDir','normal')
%colormap(ccc)
c= colorbar('location','eastoutside')
ylabel(c, 'state')
ylabel('subject')
xlabel('time instance')
title('time evolution')

K=10;
% get relative magnitude of 14 networks for each state
for i=1:K
   mean_em(:,i)=getMean(hmm,i);
end

% get state evolution for each task
for i=1:size(Labels_subj,1)
    state_evo{1,i} = Labels_subj(i,:);
end
    

for i=1:size(state_evo,2)
    state_rs{i} = state_evo{i}(1:170); %rest
    state_wm{i} = state_evo{i}(171:398); %nback
    state_em{i} = state_evo{i}(399:548); %emotion
end

% Compute the occupancy rate of each state and the mean life in subject level
[fractional_occupancy, mean_life]  = compute_occupancy_and_mean_life_subject_wise(state_evo,K); %overall
[fractional_occupancy_rs, mean_life_rs]  = compute_occupancy_and_mean_life_subject_wise(state_rs,K); %rest
[fractional_occupancy_wm, mean_life_wm]  = compute_occupancy_and_mean_life_subject_wise(state_wm,K); %nback
[fractional_occupancy_em, mean_life_em]  = compute_occupancy_and_mean_life_subject_wise(state_em,K); %emotion


% t-SNE analysis

rest_color =  [0.44,0.71,0.63];
nback_color =  [0.33,0.67,1];
emo_color =   [1,0.41,0.29];
clear species
for i=1:61  
    species{i,1} = 'rest';
    species{i+61,1} = 'emotion';
    species{i+61*2,1} = 'nback';
end

clear meas Y 
meas = [fractional_occupancy_rs;fractional_occupancy_em;fractional_occupancy_wm];
Y = tsne(meas);
gscatter(Y(:,1),Y(:,2),species)


% knee point analysis, knee point for each task is determined by kneedle algorithm (see code for supplement figure)  
% load tsne_data.mat is enough for executing this code
rest_col =  [0.44,0.71,0.63];
nback_col =  [0.33,0.67,1];
emotion_col =   [1,0.41,0.29];
length = 548;

z_rest = sort(mean(fractional_occupancy_rs),'descend');
z_wm = sort(mean(fractional_occupancy_wm),'descend');
z_em = sort(mean(fractional_occupancy_em),'descend');

sum_rest(1)=0; sum_wm(1)=0; sum_em(1)=0;

for i=2:11
    sum_rest(i) = sum(z_rest(1:i-1));
    sum_wm(i) = sum(z_wm(1:i-1));
    sum_em(i) = sum(z_em(1:i-1));
end

figure(1)
plot(0:0.5:5,sum_rest,'LineWidth',3,'Color',rest_col)
hold on
plot([2.5,2.5],[0,1],'--b','LineWidth',3,'Color',rest_col)
plot([1.5,1.5],[0,1],'--b','LineWidth',3,'Color',nback_col)
plot([1,1],[0,1],'--b','LineWidth',3,'Color',emotion_col)
plot(0:0.5:5,sum_wm,'LineWidth',3,'Color',nback_col)
plot(0:0.5:5,sum_em,'LineWidth',3,'Color',emotion_col)
f=figure(1);
f.Color = 'w';
set(gca,'xtick',[])
box off

%% behavior 

% load FO_behavior.mat
placebo = find(group_label(:)==1);
DXM = find(group_label(:)==0);

exclude_label=[];

for i = 1:length(exclude_label)
    if  placebo(find(placebo(:) == exclude_label(i)))
        placebo(find(placebo(:) == exclude_label(i))) = [];
    end
    
    if  DXM(find(DXM(:) == exclude_label(i)))
        DXM(find(DXM(:) == exclude_label(i))) = [];
    end
end

Labels_subj_regroup(1:length(placebo),:) = Labels_subj(placebo,:);
Labels_subj_regroup(length(placebo)+1:length(placebo)+length(DXM),:) = Labels_subj(DXM,:);

for i=1:length(placebo)+length(DXM)
    state_evo_11{1,i} = Labels_subj_regroup(i,:);
end

clear state_rs state_wm state_em state_rs_placebo state_wm_placebo state_em_placebo state_rs_dxm state_wm_dxm state_em_dxm

for i=1:size(state_evo_11,2)
    state_rs{i} = state_evo_11{i}(1:170);
    state_wm{i} = state_evo_11{i}(171:398);
    state_em{i} = state_evo_11{i}(399:548);
  %  state_ms{i} = state_evo{i}(549:end);
end

for i=1:length(placebo)
    state_rs_placebo{1,i} = state_rs{1,i};
    state_wm_placebo{1,i} = state_wm{1,i};
    state_em_placebo{1,i} = state_em{1,i};
  %  state_ms_placebo{1,i} = state_ms{1,placebo(i)};
end

for i=1:length(DXM)
    state_rs_dxm{1,i} = state_rs{1,length(placebo)+i};
    state_wm_dxm{1,i} = state_wm{1,length(placebo)+i};
    state_em_dxm{1,i} = state_em{1,length(placebo)+i};
%    state_ms_dxm{1,i} = state_ms{1,DXM(i)};
end

clear fo_rs_placebo fo_wm_placebo fo_em_placebo ml_rs_placebo ml_wm_placebo ml_em_placebo
clear fo_rs_dxm fo_wm_dxm fo_em_dxm ml_rs_dxm ml_wm_dxm ml_em_dxm
[fo_rs_placebo, ml_rs_placebo]  = compute_occupancy_and_mean_life_subject_wise(state_rs_placebo,10);
[fo_wm_placebo, ml_wm_placebo]  = compute_occupancy_and_mean_life_subject_wise(state_wm_placebo,10);
[fo_em_placebo, ml_em_placebo]  = compute_occupancy_and_mean_life_subject_wise(state_em_placebo,10);
[fo_rs_dxm, ml_rs_dxm]  = compute_occupancy_and_mean_life_subject_wise(state_rs_dxm,10);
[fo_wm_dxm, ml_wm_dxm]  = compute_occupancy_and_mean_life_subject_wise(state_wm_dxm,10);
[fo_em_dxm, ml_em_dxm]  = compute_occupancy_and_mean_life_subject_wise(state_em_dxm,10);

%% for 2-back
i=5;
include_subj = 1:61;
include_subj([24,39]) =[]; % excluding poor performance below mean-3std during 2-back condition 

clear total_fo

% for mean lifetime
total_fo = [ml_wm_placebo(:,i);ml_wm_dxm(:,i)];
% for fractional occupancy
total_fo = [fo_wm_placebo(:,i);fo_wm_dxm(:,i)];

[corrE12_rs, pvalueE12_rs] = corr(nbperformance_re(include_subj,3),total_fo(include_subj),'Type', 'Pearson')

total_fo = [fo_wm_placebo(:,:);fo_wm_dxm(:,:)];
% color s4: [23 190 207]/255  color s5: [31,119,180]/255;

% s5 plot
y = nbperformance_re(include_subj,3);
x = total_fo(include_subj,5); xfit = min(x):0.01:max(x); 
    a = plot(x,y,'o'); set(a,'MarkerEdgeColor',[31,119,180]/255,'MarkerFaceColor',[31,119,180]/255);
    [p,s] = polyfit(x,y,1); 
    [yfit,dy] = polyconf(p,xfit,s,'predopt','curve','simopt','on'); 
    line(xfit,yfit,'color',[31,119,180]/255,'LineWidth',1.5)
    hold on
    plot(xfit,yfit-dy,':','color',[31,119,180]/255)
    plot(xfit,yfit+dy,':','color',[31,119,180]/255)
    p = []; s = [];
 % s4 plot
    y = nbperformance_re(include_subj,3);
    x = total_fo(include_subj,4);xfit = min(x):0.01:max(x);
    
    a = plot(x,y,'o'); set(a,'MarkerEdgeColor',[23 190 207]/255,'MarkerFaceColor',[23 190 207]/255);
    [p,s] = polyfit(x,y,1); 
    [yfit,dy] = polyconf(p,xfit,s,'predopt','curve','simopt','on'); 
    line(xfit,yfit,'color',[23 190 207]/255,'LineWidth',1.5)
    hold on
    plot(xfit,yfit-dy,':','color',[23 190 207]/255)
    plot(xfit,yfit+dy,':','color',[23 190 207]/255)
    p = []; s = [];
    hold on

% 2-back and 1-back network efficiency

load('network_efficiency.mat')
% separate group
placebo_length = length(placebo);
back0_Labels_subj_re(1:placebo_length,:) = back0_Labels_subj(placebo,:);
back0_Labels_subj_re((placebo_length+1):61,:) = back0_Labels_subj(DXM,:);
back1_Labels_subj_re(1:placebo_length,:) = back1_Labels_subj(placebo,:);
back1_Labels_subj_re((placebo_length+1):61,:) = back1_Labels_subj(DXM,:);
back2_Labels_subj_re(1:placebo_length,:) = back2_Labels_subj(placebo,:);
back2_Labels_subj_re((placebo_length+1):61,:) = back2_Labels_subj(DXM,:);

for i=1:length(placebo)
    state_0b_re_placebo{i} = back0_Labels_subj_re(i,:);
    state_1b_re_placebo{i} = back1_Labels_subj_re(i,:);
    state_2b_re_placebo{i} = back2_Labels_subj_re(i,:);
end

for i=(length(placebo)+1):61
    state_0b_re_dxm{i-length(placebo)} = back0_Labels_subj_re(i,:);
    state_1b_re_dxm{i-length(placebo)} = back1_Labels_subj_re(i,:);
    state_2b_re_dxm{i-length(placebo)} = back2_Labels_subj_re(i,:);
end

[fractional_occupancy_0back_placebo, mean_life_0back]  = compute_occupancy_and_mean_life_subject_wise(state_0b_re_placebo,K);
[fractional_occupancy_0back_dxm, mean_life_0back]  = compute_occupancy_and_mean_life_subject_wise(state_0b_re_dxm,K);
[fractional_occupancy_1back_placebo, mean_life_1back]  = compute_occupancy_and_mean_life_subject_wise(state_1b_re_placebo,K);
[fractional_occupancy_1back_dxm, mean_life_1back]  = compute_occupancy_and_mean_life_subject_wise(state_1b_re_dxm,K);
[fractional_occupancy_2back_placebo, mean_life_2back]  = compute_occupancy_and_mean_life_subject_wise(state_2b_re_placebo,K);
[fractional_occupancy_2back_dxm, mean_life_2back]  = compute_occupancy_and_mean_life_subject_wise(state_2b_re_dxm,K);



% 2back, exclude poor performance below mean-3std during 2-back condition 
include_subj_1 = [1:10,12:23,25:28];
include_subj_2 = [29:32,33:38,40:47,48:61];

% 1back, exclude poor performance below mean-3std during 1-back condition 
include_subj_1 = [1:10,12:24,25:28];
include_subj_2 = [29:39,40:47,48:61];

state_list = 4;

[corrE12_rs, pvalueE12_rs] = corr([nbperformance_re(include_subj_1,3)./((1-fractional_occupancy_2back_placebo(include_subj_1,state_list(1))));nbperformance_re(include_subj_2,3)./((1-fractional_occupancy_2back_dxm(include_subj_2-28,state_list(1))))],[auci_placebo(include_subj_1);auci_dxm(include_subj_2-28)], 'Type','Pearson')

[corrE12_rs, pvalueE12_rs] = corr([nbperformance_re(include_subj_1,2)./((1-fractional_occupancy_1back_placebo(include_subj_1,state_list(1))));nbperformance_re(include_subj_2,2)./((1-fractional_occupancy_1back_dxm(include_subj_2-28,state_list(1))))],[auci_placebo(include_subj_1);auci_dxm(include_subj_2-28)], 'Type','Pearson')


% using permutaton test to obtain significance for correlation between network efficiency and auci 

    
%% for emotion condition
    
include_subj = 1:61;
include_subj([3]) =[];  % excluding poor performance below mean-3std during emotion condition
[corrE12_pr, pvalueE12_pr] = corr(fractional_occupancy_em(include_subj,8), EMperformance(include_subj,1), 'Type','Pearson')

% permutation test
switch_value  = corrE12_pr;

clear y_tol x_tol
y_tol = EMperformance(include_subj,1);
x_tol =fractional_occupancy_em(include_subj,8);

clear all_re
for i=1:5000
    
   rand_seed = randperm(length(y_tol));
   all_re(i) = corr(y_tol(rand_seed),x_tol,'Type', 'Pearson');

end

p = length(find(all_re(:)>switch_value))/5000

%plot 
total_fo = fractional_occupancy_em(:,:);
% s1 plot
y = EMperformance(include_subj,1);
x = total_fo(include_subj,1); xfit = min(x):0.01:max(x); 
    a = plot(x,y,'o'); set(a,'MarkerEdgeColor',[188,189,34]/255,'MarkerFaceColor',[188,189,34]/255);
    [p,s] = polyfit(x,y,1); 
    [yfit,dy] = polyconf(p,xfit,s,'predopt','curve','simopt','on'); 
    line(xfit,yfit,'color',[188,189,34]/255,'LineWidth',1.5)
    hold on
    plot(xfit,yfit-dy,':','color',[188,189,34]/255)
    plot(xfit,yfit+dy,':','color',[188,189,34]/255)
    p = []; s = [];
% s8 plot
    y = EMperformance(include_subj,1);
    x = total_fo(include_subj,8);xfit = min(x):0.01:max(x);
    
    a = plot(x,y,'o'); set(a,'MarkerEdgeColor',[255 124 14]/255,'MarkerFaceColor',[255 124 14]/255);
    [p,s] = polyfit(x,y,1); 
    [yfit,dy] = polyconf(p,xfit,s,'predopt','curve','simopt','on'); 
    line(xfit,yfit,'color',[255 124 14]/255,'LineWidth',1.5)
    hold on
    plot(xfit,yfit-dy,':','color',[255 124 14]/255)
    plot(xfit,yfit+dy,':','color',[255 124 14]/255)
    p = []; s = [];
    hold on  

%% FO and mean lifetime group difference analysis for each task (block-based) for Figure 3

% rs
[fo_rs_dxm, ml_rs_dxm]  = compute_occupancy_and_mean_life_subject_wise(state_rs_dxm,10);

% nback block-based FO and mean life
load('nback_blockbase_state_evolution.mat')

[fractional_occupancy_0back_rep1, mean_life_0back_rep1,mean_life_var]  = compute_occupancy_and_mean_life_subject_wise(state_0b_rep1,K);
[fractional_occupancy_1back_rep1, mean_life_1back_rep1]  = compute_occupancy_and_mean_life_subject_wise(state_1b_rep1,K);
[fractional_occupancy_2back_rep1, mean_life_2back_rep1]  = compute_occupancy_and_mean_life_subject_wise(state_2b_rep1,K);
[fractional_occupancy_0back_rep2, mean_life_0back_rep2,mean_life_var]  = compute_occupancy_and_mean_life_subject_wise(state_0b_rep2,K);
[fractional_occupancy_1back_rep2, mean_life_1back_rep2]  = compute_occupancy_and_mean_life_subject_wise(state_1b_rep2,K);
[fractional_occupancy_2back_rep2, mean_life_2back_rep2]  = compute_occupancy_and_mean_life_subject_wise(state_2b_rep2,K);
[fractional_occupancy_0back_rep3, mean_life_0back_rep3,mean_life_var]  = compute_occupancy_and_mean_life_subject_wise(state_0b_rep3,K);
[fractional_occupancy_1back_rep3, mean_life_1back_rep3]  = compute_occupancy_and_mean_life_subject_wise(state_1b_rep3,K);
[fractional_occupancy_2back_rep3, mean_life_2back_rep3]  = compute_occupancy_and_mean_life_subject_wise(state_2b_rep3,K);
[fractional_occupancy_0back_rep4, mean_life_0back_rep4,mean_life_var]  = compute_occupancy_and_mean_life_subject_wise(state_0b_rep4,K);
[fractional_occupancy_1back_rep4, mean_life_1back_rep4]  = compute_occupancy_and_mean_life_subject_wise(state_1b_rep4,K);
[fractional_occupancy_2back_rep4, mean_life_2back_rep4]  = compute_occupancy_and_mean_life_subject_wise(state_2b_rep4,K);

fractional_occupancy_0back_placebo = [fractional_occupancy_0back_rep1(1:length(placebo),:);fractional_occupancy_0back_rep2(1:length(placebo),:);fractional_occupancy_0back_rep3(1:length(placebo),:);fractional_occupancy_0back_rep4(1:length(placebo),:)];
fractional_occupancy_1back_placebo = [fractional_occupancy_1back_rep1(1:length(placebo),:);fractional_occupancy_1back_rep2(1:length(placebo),:);fractional_occupancy_1back_rep3(1:length(placebo),:);fractional_occupancy_1back_rep4(1:length(placebo),:)];
fractional_occupancy_2back_placebo = [fractional_occupancy_2back_rep1(1:length(placebo),:);fractional_occupancy_2back_rep2(1:length(placebo),:);fractional_occupancy_2back_rep3(1:length(placebo),:);fractional_occupancy_2back_rep4(1:length(placebo),:)];
fractional_occupancy_0back_dxm = [fractional_occupancy_0back_rep1(length(placebo)+1:end,:);fractional_occupancy_0back_rep2(length(placebo)+1:end,:);fractional_occupancy_0back_rep3(length(placebo)+1:end,:);fractional_occupancy_0back_rep4(length(placebo)+1:end,:)];
fractional_occupancy_1back_dxm = [fractional_occupancy_1back_rep1(length(placebo)+1:end,:);fractional_occupancy_1back_rep2(length(placebo)+1:end,:);fractional_occupancy_1back_rep3(length(placebo)+1:end,:);fractional_occupancy_1back_rep4(length(placebo)+1:end,:)];
fractional_occupancy_2back_dxm = [fractional_occupancy_2back_rep1(length(placebo)+1:end,:);fractional_occupancy_2back_rep2(length(placebo)+1:end,:);fractional_occupancy_2back_rep3(length(placebo)+1:end,:);fractional_occupancy_2back_rep4(length(placebo)+1:end,:)];

% using permutaton test to compare group difference in 2-back condition



% emotion matching block-based FO and mean life
load('emotion_blockbase_state_evolution.mat')

[fractional_occupancy_emo_rep1, mean_life_emo_rep1]  = compute_occupancy_and_mean_life_subject_wise(state_emo_rep1,K);
[fractional_occupancy_emo_rep2, mean_life_emo_rep2]  = compute_occupancy_and_mean_life_subject_wise(state_emo_rep2,K);
[fractional_occupancy_emo_rep3, mean_life_emo_rep3]  = compute_occupancy_and_mean_life_subject_wise(state_emo_rep3,K);
[fractional_occupancy_emo_rep4, mean_life_emo_rep4]  = compute_occupancy_and_mean_life_subject_wise(state_emo_rep4,K);
[fractional_occupancy_emo_rep5, mean_life_emo_rep5]  = compute_occupancy_and_mean_life_subject_wise(state_emo_rep5,K);
[fractional_occupancy_neu_rep1, mean_life_neu_rep1]  = compute_occupancy_and_mean_life_subject_wise(state_neu_rep1,K);
[fractional_occupancy_neu_rep2, mean_life_neu_rep2]  = compute_occupancy_and_mean_life_subject_wise(state_neu_rep2,K);
[fractional_occupancy_neu_rep3, mean_life_neu_rep3]  = compute_occupancy_and_mean_life_subject_wise(state_neu_rep3,K);
[fractional_occupancy_neu_rep4, mean_life_neu_rep4]  = compute_occupancy_and_mean_life_subject_wise(state_neu_rep4,K);
[fractional_occupancy_neu_rep5, mean_life_neu_rep5]  = compute_occupancy_and_mean_life_subject_wise(state_neu_rep5,K);



fractional_occupancy_emo_placebo = [fractional_occupancy_emo_rep1(1:length(placebo),:);fractional_occupancy_emo_rep2(1:length(placebo),:);fractional_occupancy_emo_rep3(1:length(placebo),:);fractional_occupancy_emo_rep4(1:length(placebo),:);fractional_occupancy_emo_rep5(1:length(placebo),:)];
fractional_occupancy_neu_placebo = [fractional_occupancy_neu_rep1(1:length(placebo),:);fractional_occupancy_neu_rep2(1:length(placebo),:);fractional_occupancy_neu_rep3(1:length(placebo),:);fractional_occupancy_neu_rep4(1:length(placebo),:);fractional_occupancy_neu_rep5(1:length(placebo),:)];
fractional_occupancy_emo_dxm = [fractional_occupancy_emo_rep1(length(placebo)+1:end,:);fractional_occupancy_emo_rep2(length(placebo)+1:end,:);fractional_occupancy_emo_rep3(length(placebo)+1:end,:);fractional_occupancy_emo_rep4(length(placebo)+1:end,:);fractional_occupancy_emo_rep5(length(placebo)+1:end,:)];
fractional_occupancy_neu_dxm = [fractional_occupancy_neu_rep1(length(placebo)+1:end,:);fractional_occupancy_neu_rep2(length(placebo)+1:end,:);fractional_occupancy_neu_rep3(length(placebo)+1:end,:);fractional_occupancy_neu_rep4(length(placebo)+1:end,:);fractional_occupancy_neu_rep5(length(placebo)+1:end,:)];


subplot(1,2,1)
bar([nanmean(fractional_occupancy_emo_placebo)*100;nanmean(fractional_occupancy_emo_dxm)*100]')
title('emotion')
%ylim([0 100])
ylabel('occupancy rate'); xlabel('metastate')
subplot(1,2,2)
bar([nanmean(fractional_occupancy_neu_placebo)*100;nanmean(fractional_occupancy_neu_dxm)*100]')
title('neutral')
%ylim([0 100])
ylabel('occupancy rate'); xlabel('metastate')


% using permutaton test to compare group difference in emotion condition

%% Transition analyses
addpath(genpath('E:\DST_multitask\CommunityDetection'));

% community detection

% set task color
rest_color =  [0.44,0.71,0.63];
nback_color =  [0.42,0.67,0.92];
emo_color =   [0.91,0.47,0.38];
color_list = [emo_color;nback_color;rest_color; [0 0 0]];

%% plot

total_trans = hmm.P;

for q=1:10
     total_trans(q,q)=0; % exclude diag self-transitions
end
A = total_trans;
sort_A = sort(A(find(A(:)>0)),'descend');
thres_pro = 0.25;
thresh = sort_A(round(90*thres_pro));
A(A <= thresh-0.0001) = 0;
[est_network2,clust_mtx_partial] = community_detection_newman(A)

clear node_color
node_color = zeros(1,3);
for i=1:10
    node_color = [node_color;color_list(clust_mtx_partial(i),:)];
   % node_color = [node_color;color_list(node_cor_list(i),:)];
end
node_color(1,:) = [];

names = {'S1' 'S2' 'S3' 'S4','S5','S6','S7','S8','S9','S10'};
G = digraph(A,names,'omitselfloops');
all_edges = G.Edges.Weight;
max_edge = max(all_edges(all_edges >0));
min_edge = min(all_edges(all_edges >0));
RWidths = 4+5*((G.Edges.Weight-min_edge)/max_edge);
MSize = 100*nanmean(fractional_occupancy);
p = plot(G,'LineWidth',RWidths,'MarkerSize',MSize,'NodeFontSize',10,'NodeColor',node_color,'EdgeColor',[0.67 0.67 0.67]);

% transition comparison edge-by-edge

for i=1:length(data)
   T{1,i} = [170 228 150];
end

mask = {[1:170],[171:398],[399:548]};
for i=1:60
    t0= 548*i+1;
    t1=t0+169;t2=t1+228;t3=t2+150;
    mask =  [mask,{[t0:t1],[(t1+1):t2],[(t2+1):t3]}];
end

[P,Pi] = getMaskedTransProbMats(data_t,T,hmm,mask,Gamma);

trans_matrix = reshape(P,3,61)';

% remove diag self trans

for i=1:61
    for j=1:3
        trans_matrix{i,j}(logical(eye(size(trans_matrix{i,j}))))=0;
        for q=1:10
            trans_matrix{i,j}(q,:) = trans_matrix{i,j}(q,:)/sum(trans_matrix{i,j}(q,:));
        end
    end
end

for i=1:61
    trans_rs(i,:) = reshape(trans_matrix{i,1}',1,100);
    trans_wm(i,:) = reshape(trans_matrix{i,2}',1,100);
    trans_em(i,:) = reshape(trans_matrix{i,3}',1,100);
end


trans_mat{1,1} = mean(trans_rs);
trans_mat{1,2} = mean(trans_wm);
trans_mat{1,3} = mean(trans_em);
   
f = figure;
title_list = {'WM-Rest','EM-Rest','EM-WM'};
   subplot(1,3,1)
  % clim = [0 1];
   imagesc(reshape(trans_mat{1,2},10,10)'-reshape(trans_mat{1,1},10,10)');
  % imagesc(reshape(trans_mat{1,i},10,10)'-diag(diag(reshape(trans_mat{1,i},10,10)')));
    xticks([1:10])
    yticks([1:10])
    caxis([-0.06 0.1])
    %set(gca,'XTickLabelRotation',90)
    title(title_list{1})
    box off
    subplot(1,3,2)
  % clim = [0 1];
   imagesc(reshape(trans_mat{1,3},10,10)'-reshape(trans_mat{1,1},10,10)');
  % imagesc(reshape(trans_mat{1,i},10,10)'-diag(diag(reshape(trans_mat{1,i},10,10)')));
    xticks([1:10])
    yticks([1:10])
    caxis([-0.06 0.1])
    %set(gca,'XTickLabelRotation',90)
    title(title_list{2})
    box off
    subplot(1,3,3)
  % clim = [0 1];
   imagesc(reshape(trans_mat{1,3},10,10)'-reshape(trans_mat{1,2},10,10)');
  % imagesc(reshape(trans_mat{1,i},10,10)'-diag(diag(reshape(trans_mat{1,i},10,10)')));
    xticks([1:10])
    yticks([1:10])
    caxis([-0.06 0.1])
    %set(gca,'XTickLabelRotation',90)
    title(title_list{3})
    f.Color = 'w';
    box off
    
% using Network-Based Statistics (NBS) to compute permuted-p values for edge-by-edge comparisons

%% Transition complexity 

% Rest
clear switch_rs
for i=1:size(Labels_subj_1,1)
     z = DL_Complexity(Labels_subj_regroup(i,1:170));
    switch_rs(i,1) = z.DLComp;
    clear z
end

% Emotion
load('emotion_nback_state_sequence_cohort1.mat')
% rearrange data to: (Placebo: 1:28 row;DXM: 29:61 row)
Labels_subj_regroup_emotion_re(1:length(placebo),:) = emotion_Labels_subj(placebo,:); 
Labels_subj_regroup_emotion_re(length(placebo)+1:length(placebo)+length(DXM),:) = emotion_Labels_subj(DXM,:); 
Labels_subj_regroup_neutral_re(1:length(placebo),:) = neutral_Labels_subj(placebo,:); 
Labels_subj_regroup_neutral_re(length(placebo)+1:length(placebo)+length(DXM),:) = neutral_Labels_subj(DXM,:); 

clear switch_state_emo_placebo_word switch_state_emo_dxm_word switch_state_neu_placebo_word switch_state_neu_dxm_word

for i=1:28
    z = DL_Complexity(Labels_subj_regroup_emotion_re(i,1:end));
    switch_state_emo_placebo_word(i,1) = z.DLComp;
    z = DL_Complexity(Labels_subj_regroup_neutral_re(i,1:end));
    switch_state_neu_placebo_word(i,1) = z.DLComp;
end

for i=1:33
    z = DL_Complexity(Labels_subj_regroup_emotion_re(i+28,1:end));
    switch_state_emo_dxm_word(i,1) = z.DLComp;
    z = DL_Complexity(Labels_subj_regroup_neutral_re(i+28,1:end));
    switch_state_neu_dxm_word(i,1) = z.DLComp;
end


[corrE12_rs, pvalueE12_rs] = corr([switch_state_emo_placebo_word;switch_state_emo_dxm_word]-[switch_state_neu_placebo_word;switch_state_neu_dxm_word],[aucg_placebo;aucg_dxm],'Type', 'Pearson')

% Nback
load('emotion_nback_state_sequence_cohort1.mat')
% back0_Labels_subj_re: rearranged data to (Placebo: 1:28 row;DXM: 29:61 row)
% back2_Labels_subj_re: rearranged data to (Placebo: 1:28 row;DXM: 29:61 row)
for i=1:28
    z = DL_Complexity(back0_Labels_subj_re(i,1:end));
    switch_state_0b_placebo_word(i,1) = z.DLComp;
    z = DL_Complexity(back1_Labels_subj_re(i,1:end));
    switch_state_1b_placebo_word(i,1) = z.DLComp;
    z = DL_Complexity(back2_Labels_subj_re(i,1:end));
    switch_state_2b_placebo_word(i,1) = z.DLComp;
end

for i=1:33
    z = DL_Complexity(back0_Labels_subj_re(i+28,1:end));
    switch_state_0b_dxm_word(i,1) = z.DLComp;
    z = DL_Complexity(back1_Labels_subj_re(i+28,1:end));
    switch_state_1b_dxm_word(i,1) = z.DLComp;
    z = DL_Complexity(back2_Labels_subj_re(i+28,1:end));
    switch_state_2b_dxm_word(i,1) = z.DLComp;
end

[corrE12_rs, pvalueE12_rs] = corr([switch_state_2b_placebo_word;switch_state_2b_dxm_word]-[switch_state_0b_placebo_word;switch_state_0b_dxm_word],[aucg_placebo;aucg_dxm],'Type', 'Pearson')
