% test models on the trained models
% taghia@stanford.edu

close all;
clear all
rep = '2';
addpath(genpath('/Volumes/taghia/BayesianHiddenFactorAnalysis/VB-HMMFA-NBD'))
addpath(genpath('/Volumes/mnt/mapricot/musk2/home/fmri/fmrihome/scripts/GCCA_toolbox_sep21/'))
addpath('/Volumes/mnt/mapricot/musk2/home/sryali/Work/switchingFC/VB-HMM/Scripts/VB-HMM-GD-rev1')
addpath(genpath('/Volumes/mapricot/mnt/musk2/home/fmri/fmrihome/SPM/spm8_scripts'));
addpath(genpath('/Volumes/mnt/mapricot/musk2/home/tianwenc/Toolbox/BCT/BCT_04_05_2014'));
loadpath= '/Volumes/taghia/BayesianHiddenFactorAnalysis/VB-HMMFA-NBD/PaperExperiments/HCP-ICA14/WChiaData/20ROIs/trainedModels/';

stateSet = {'30'};
for state = 1: numel(stateSet)
      load ([loadpath,stateSet{state},'/','LLstate',rep]);
      ll(state) =  LL;
      stateID(state) = str2num(stateSet{state});
end

for state = 1:1% numel(stateSet)
      load([loadpath,stateSet{state},'/','model_R',rep])
      load([loadpath,stateSet{state},'/','estStates_R',rep])
      load([loadpath,stateSet{state},'/','estStatesCell_R',rep])
      load([loadpath,stateSet{state},'/','dataCov_R',rep])
      %       load([loadpath,stateSet{state},'/','dataCovModel',rep])
      %       dataCov = dataCov2;
      %       load([loadpath,stateSet{state},'/','dataCov_x_R',rep])
      %       dataCov = dataCov_x;
      %
      
      switch rep
            case '2'
                  load('/Volumes/mnt/mapricot/musk2/home/wdcai/LabMembers/Jalil/HMM/Data/HCP_REST2_LR_77subjects_Shirer_14Networks_78ROIs.mat')
            case '1'
                  load('/Volumes/mnt/mapricot/musk2/home/wdcai/LabMembers/Jalil/HMM/Data/HCP_REST1_LR_77subjects_Shirer_14Networks_78ROIs.mat')
            otherwise
      end
      
      
      rois = [9 11:12 14 16:17 26:29 52:56 57:61]; % full networks
      for subj = 1:length(data)
            temp = data{subj};
            data_states{subj} = temp(rois,:);
      end
      for k = 1:size(data{1},1)
            roi_names{k} = num2str(k);
      end
      roi_names = roi_names(rois);
      
      data =  data_states;
      data = data([1:25, 27:34, 36: 51, 53:end]); % subject 26, 35 and 52 are excluded 
      communityanalysis_Newman;
      
end
