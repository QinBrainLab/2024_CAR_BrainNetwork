
%% addpath for CanlanCore for Neurosynth decoding

addpath(genpath('E:\DST_multitask\script'))
addpath(genpath('E:\DST_multitask\script\CanlabCore-master'))
% save state mean activity to nii before decoding
save_result_path = 'E:\DST_multitask\DST_multitask_time_series\DST_discovery_dataset\state_nii';
roi_path = 'E:\DST_multitask\whole_brain_14roi_nii';

for i=1:10
   mean_em(:,i)=getMean(hmm,i);
end

t_all = zeros(91,109,91);

volumeViewer(t1_data)
t_all = t1_data;

for i=1:10
    
    t_all = zeros(91,109,91);
    cd(roi_path)
    for j=1:14
        temp_name =  roi_names{j,1}{1,1}(1:end-4);        
        % the standard t1 scan
        t1_file = strcat(temp_name,'_roi.nii');
        t1_vol = spm_vol(t1_file);
        t1_data = spm_read_vols(t1_vol); %-- it's a 91*109*91
        t_all = t_all+t1_data.*mean_em(j,i);
    end
    cd(save_result_path)
    t1_vol.fname = strcat('state',num2str(i),'.nii');
    spm_write_vol(t1_vol, t_all);
        
end


%% Neurosynth-Decoding
 
cd(save_result_path)

clear total_term_corr total_term_words
state_num=10;
for i=1:state_num
    test_dat = fmri_data(strcat('state',num2str(i),'.nii'));
    [image_by_feature_correlations, top_feature_tables] = neurosynth_feature_labels(test_dat);
    top_ft{i} = top_feature_tables;
    total_term_corr{1,i} = top_feature_tables{1, 1}.testr_high;
    total_term_words{1,i} = top_feature_tables{1, 1}.words_high;
    clear top_feature_tables image_by_feature_correlations
end
