
% knee point analysis, knee point for each task is determined by kneedle algorithm (see code for supplement figure)  
% load tsne_data.mat is enough for executing this code
rest_col =  [0.44,0.71,0.63];
nback_col =  [0.33,0.67,1];
emotion_col =   [1,0.41,0.29];
length = 548;

% order as rest

[out,idx] = sort(mean(fractional_occupancy_rs),'descend');
z_wm = sort(mean(fractional_occupancy_wm),'descend');


%  plot 

z_rest = sort(mean(fractional_occupancy_rs),'descend');
z_wm = sort(mean(fractional_occupancy_wm),'descend');
z_em = sort(mean(fractional_occupancy_em),'descend');

sum_rest(1)=0;
sum_wm(1)=0;
sum_em(1)=0;
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
