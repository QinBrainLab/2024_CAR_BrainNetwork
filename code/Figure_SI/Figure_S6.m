
% calculate free energy and AIC for each trained HMM model (state number:2-16,step = 2)
% For each state number setting, we trained model with repetitions = 5 and chose
% the trained model with the lowest free energy for subsequent comparisons among different state number settings. 
% load HMM_models.mat


clear aic_all aic_per_chg per_chg
for i=1:(length(all_fe))
        aic_all(i) = aicbic(-all_fe(i),2*i);
end

for i=1:length(all_fe)-1
      if i <= length(all_fe)-1
        per_chg(i) = (all_fe(i)-all_fe(i+1))/all_fe(i)*100;
        aic_per_chg(i) = (aic_all(i)-aic_all(i+1))/aic_all(i)*100;
      end
end

plot(aic_all);
plot(all_fe);
xticks([1:8]);
tickk = {'2','4','6','8','10','12','14','16'};
xticklabels(tickk);

hold on 

plot(aic_per_chg)
plot(per_chg);
xticks([1:7]);
tickk = {'2-4','4-6','6-8','8-10','10-12','12-14','14-16'};
xticklabels(tickk);

