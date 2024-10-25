
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

    
%% for emotion condition
    
include_subj = 1:61;
include_subj([3]) =[];  % excluding poor performance below mean-3std during emotion condition



[corrE12_pr, pvalueE12_pr] = corr(fractional_occupancy_em(include_subj,8), EMperformance(include_subj,1), 'Type','Pearson')

% permutation
switch_value  = corrE12_pr;

clear y_tol x_tol
y_tol = EMperformance(include_subj,1);
x_tol =fractional_occupancy_em(include_subj,8);

clear all_re
for i=1:5000
    
   rand_seed = randperm(length(y_tol));
   all_re(i) = corr(y_tol(rand_seed),x_tol,'Type', 'Pearson');

end

length(find(all_re(:)>switch_value))/5000

%plot 
%s1 [188,189,34]/255 s8 [255 124 14]/255
total_fo = fractional_occupancy_em(:,:);
  
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
