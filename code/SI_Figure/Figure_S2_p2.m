
%% plot error bar
% load FigS2_p2.mat

length(total_exclude) % Subjects with missing saliva sample(s) were excluded

% bar graph

aucg = mean(cortisol_all(total_exclude,[8]));
auci = mean(cortisol_all(total_exclude,[9]));

bar(1:2,[aucg,auci])
hold on 
errorbar(1:2,[aucg,auci],std(cortisol_all(total_exclude,[8,9]))/sqrt(length(total_exclude)), 'LineStyle', 'none', 'CapSize', 10)


