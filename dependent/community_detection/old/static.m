
close all;
clear all
rep = '2';
addpath(genpath('/Volumes/taghia/BayesianHiddenFactorAnalysis/VB-HMMFA-NBD'))
addpath(genpath('/Volumes/mnt/mapricot/musk2/home/fmri/fmrihome/scripts/GCCA_toolbox_sep21/'))
addpath('/Volumes/mnt/mapricot/musk2/home/sryali/Work/switchingFC/VB-HMM/Scripts/VB-HMM-GD-rev1')
addpath(genpath('/Volumes/mapricot/mnt/musk2/home/fmri/fmrihome/SPM/spm8_scripts'));
addpath(genpath('/Volumes/mnt/mapricot/musk2/home/tianwenc/Toolbox/BCT/BCT_04_05_2014'));
loadpath= '/Volumes/taghia/BayesianHiddenFactorAnalysis/VB-HMMFA-NBD/PaperExperiments/HCP-ICA14/WChiaData/20ROIs/trainedModels/';
rep = '1';
%%
% switch rep
%       case '2'
%             load('/Volumes/mnt/mapricot/musk2/home/wdcai/LabMembers/Jalil/HMM/Data/HCP_REST2_LR_77subjects_Shirer_14Networks_78ROIs.mat')
%       case '1'
%             load('/Volumes/mnt/mapricot/musk2/home/wdcai/LabMembers/Jalil/HMM/Data/HCP_REST1_LR_77subjects_Shirer_14Networks_78ROIs.mat')
%       otherwise
% end
% % rois = [1:78];
% rois = [9 11:12 14 16:17 26:29 52:56 57:61]; % full networks
%%

switch rep
      case '2'
            load('/Volumes/mnt/mapricot/musk2/home/wdcai/LabMembers/Jalil/HMM/Data/HCP_REST2_LR_77subjects_Power_264ROIs.mat')
      case '1'
            load('/Volumes/mnt/mapricot/musk2/home/wdcai/LabMembers/Jalil/HMM/Data/HCP_REST1_LR_77subjects_Power_264ROIs.mat')
      otherwise
end

rois = [1:264]; % full networks
%%

for subj = 1:length(data)
      temp = data{subj};
      data_states{subj} = temp(rois,:);
end
for k = 1:size(data{1},1)
      roi_names{k} = num2str(k);
end
roi_names = roi_names(rois);

data =  data_states;
% data = data([1:25, 27:34, 36: 51, 53:end]); % subject 26, 35 and 52 are excluded


data_concat = cell2mat(data);

dataCov = cov(data_concat');
est_cov = dataCov;
invD = inv(diag(sqrt(diag(est_cov))));
pearson_corr = invD*est_cov*invD;
%Partial Correlation
inv_est_cov = inv(est_cov);
invD = inv(diag(sqrt(diag(inv_est_cov))));
partial_corr = -invD*inv_est_cov*invD;

dim = size(data{1},1);
est_network1 = zeros(dim,dim);
est_network2 = zeros(dim,dim);
[est_network1,clust_mtx_partial] = clusters_community_detection_Newman(partial_corr,2);
[est_network1,clust_mtx_partial] = clusters_community_detection_JT(partial_corr, 1);

figure;
axis square
cca_plotcausality(est_network1,roi_names,.5);
axis off
figure;
axis square
cca_plotcausality(est_network2,roi_names,.5);
axis off