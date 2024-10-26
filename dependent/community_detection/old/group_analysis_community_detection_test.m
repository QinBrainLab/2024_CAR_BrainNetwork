clear all;
addpath(genpath('/Volumes/mnt/mapricot/musk2/home/fmri/fmrihome/scripts/GCCA_toolbox_sep21/'))
addpath('/Volumes/mnt/mapricot/musk2/home/sryali/Work/switchingFC/VB-HMM/Scripts/VB-HMM-GD-rev1')
addpath(genpath('/Volumes/mapricot/mnt/musk2/home/fmri/fmrihome/SPM/spm8_scripts'));
addpath(genpath('/Volumes/mnt/mapricot/musk2/home/tianwenc/Toolbox/BCT/BCT_04_05_2014'));
addpath(genpath('/Volumes/mnt/mapricot/musk2/home/taghia/BayesianHiddenFactorAnalysis/privateUse/combinedVAR'))
addpath(genpath('/Volumes/mnt/mapricot/musk2/home/taghia/BayesianHiddenFactorAnalysis/privateUse/VB-HMMFA-AR-v2'))
addpath(genpath('/Volumes/mnt/mapricot/musk2/home/taghia/BayesianHiddenFactorAnalysis/VB-HMMFA-NBD'))


savepath = '/Volumes/mnt/mapricot/musk2/home/taghia/ColleaguesProjects/Shaozheng/encoding/trained_models_22ROIs/';
stateSet = {'10'}; % number of states
rep = '2'; % replication for encoding session 1 and session 2
trial = '100June20'; 

switch rep
      case '2'
            load('/Volumes/mnt/mabloo1/apricot1_share6/memory_consolidation/dynamic_states/Data/Data_n24/TimeSeries_22ROIs_Encoding2_wm_cs_mnvt_swaor_nofl_218scans/22ROI_ts_encoding_2_n24.mat')
            %load('/mnt/mabloo1/apricot1_share6/memory_consolidation/dynamic_states/Data/Data_n24/TimeSeries_22ROIs_Encoding2_wm_cs_mnvt_swaor_nofl_218scans/22ROI_ts_encoding_1_n24.mat')
      case '1'
            load('/Volumes/mnt/mabloo1/apricot1_share6/memory_consolidation/dynamic_states/Data/Data_n24/TimeSeries_22ROIs_Encoding1_wm_cs_mnvt_swaor_nofl_218scans/22ROI_ts_encoding_1_n24.mat')
      otherwise
end
nSubj = length(data)
for subj=1:nSubj
    temp = data(subj).all_roi_ts';
    datan{subj} = preprocess(temp);
end
roi_names  = data(1).roi_names;
for roi=1:size(datan{1},1)
      roi_names2{roi}  = roi_names{roi}(5:end);
end
%% load the trianed model
load([savepath,stateSet{1},'/','model',trial, '_', rep])
estStatesCell = model.estStatesCell;
estStates = model.estStates;
% dataCov = model.dataCov;
modelCov = model.modelCov;
dataCov = modelCov ;
%% Compute the occupancy rate of each state and the mean life in subject level for a given replication
for subj=1:length(data)
      K= str2num(stateSet{1}); 
      sc =zeros(1,K);
      for j=1:K
            sc(j) =  sum(estStatesCell{subj} ==j);
      end
      counts_post = sc/sum(sc);
      [percent_dominant(subj,:), dominant_states(subj,:)] = sort(counts_post,'descend');
      [fractional_occupancy(subj,:), mean_life(subj,:),Counters] = summary_stats_fast(estStatesCell{subj}, dominant_states(subj,:));
end
figure(2);
subplot 211
MA = nanmean(percent_dominant)*100;
EA = nanstd(percent_dominant)*100;
ccc = distinguishable_colors(K);
for s=1:K
      bar(s,MA(s),'FaceColor',ccc(s,:),'EdgeColor',ccc(s,:))
      hold on
      errorbar(s,MA(s),EA(s), 'Color',ccc(s,:) )
      hold on
end
title('occupancy rate')
MA2 = nanmean(mean_life);
EA2 = nanstd(mean_life);
subplot 212
for s=1:K
      bar(s,MA2(s),'FaceColor',ccc(s,:),'EdgeColor',ccc(s,:))
      hold on
      errorbar(s,MA2(s),EA2(s), 'Color',ccc(s,:) )
      hold on
end
title('mean life')
%% Compute time evolution of hidden states for the given replication
post_states = estStates;
Labels_subj = reshape(post_states,size(datan{1},2),length(datan))';

for subj=1:length(datan)
      counter = 1;
      
      temp = Labels_subj(subj,:);
      for k=1:K
%             Labels_subj(subj,find((temp==dominant_states(subj,k))==1)) = counter;
            mode_states = mode(dominant_states);
            Labels_subj(subj,find((temp==mode_states(k))==1)) = counter;

            counter = counter + 1;
      end
end
figure(2);
imagesc(Labels_subj);
pf2 = gca;
set(pf2,'YDir','normal')
colormap(ccc)
c= colorbar('location','eastoutside')
ylabel(c, 'state')
ylabel('subject')
 xlabel('time instance')
 title('time evolution')
box off
%% community structure 
for j=1:K
      sc(j) =  sum(estStates ==j);
end
counts_post = sc/sum(sc);
[percent_dominant, dominant_states] = sort(counts_post,'descend');
 
 
%Estimates of Covariance
for j= 1:K
      k = dominant_states(j);
      est_cov = dataCov{k};
      invD = inv(diag(sqrt(diag(est_cov))));
      pearson_corr(:,:,j) = invD*est_cov*invD;
      %Partial Correlation
      inv_est_cov = inv(est_cov);
      invD = inv(diag(sqrt(diag(inv_est_cov))));
      partial_corr(:,:,j) = -invD*inv_est_cov*invD;
end
dim = size(datan{1},1);
est_network1 = zeros(dim,dim,K);
est_network2 = zeros(dim,dim,K);

for k=1:6
      %       k = mode(dominant_states(j));
      [est_network2(:,:,k),clust_mtx_partial(:,k)] = clusters_community_detection_Newman(pearson_corr(:,:,k),1);
      figure(111);
      subplot(3,2,k)
      axis square
      cca_plotcausality(est_network2(:,:,k),roi_names2, .5);
      axis off
      
end
