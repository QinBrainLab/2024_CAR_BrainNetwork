rep = '2';
trial = 'June8';
addpath(genpath('/Volumes/mnt/mapricot/musk2/home/taghia/BayesianHiddenFactorAnalysis/VB-HMMFA-NBD/'))
addpath(genpath('/Volumes/mnt/mapricot/musk2/home/fmri/fmrihome/scripts/GCCA_toolbox_sep21/'))
addpath('/Volumes/mnt/mapricot/musk2/home/sryali/Work/switchingFC/VB-HMM/Scripts/VB-HMM-GD-rev1')
addpath(genpath('/Volumes/mapricot/mnt/musk2/home/fmri/fmrihome/SPM/spm8_scripts'));
addpath(genpath('/Volumes/mnt/mapricot/musk2/home/tianwenc/Toolbox/BCT/BCT_04_05_2014'));
addpath(genpath('/Volumes/taghia/BayesianHiddenFactorAnalysis/VB-HMMFA-NBD/PaperExperiment5/FC/scripts/2016_01_16_BCT '))
loadpath= '/Volumes/mnt/mapricot/musk2/home/taghia/BayesianHiddenFactorAnalysis/VB-HMMFA-NBD/PaperExperiment5/FC/trainedModels/20ROIs/';

stateSet = {'40'};
for state = 1:1% numel(stateSet)
      load([loadpath,stateSet{state},'/','model_R',rep, trial])
      load([loadpath,stateSet{state},'/','estStates_R',rep, trial])
      load([loadpath,stateSet{state},'/','estStatesCell_R',rep, trial])
      load([loadpath,stateSet{state},'/','dataCov_R', rep, trial])
      load([loadpath,stateSet{state},'/','dataCovModel',rep, trial])
      dataCov = dataCov2;
      
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
      data = data([1:25, 27:34, 36: 51, 53:end]);
%       data = data(1:10);
      community_analysis;
      
end
