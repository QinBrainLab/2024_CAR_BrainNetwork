% post-analysis scripts


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
figure(1);
subplot 211
MA = nanmean(percent_dominant)*100;
EA = nanstd(percent_dominant)*100;
ccc = distinguishable_colors(30);
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
Labels_subj = reshape(post_states,size(data{1},2),length(data))';

for subj=1:length(data)
      counter = 1;
      
      temp = Labels_subj(subj,:);
      for k=1:K
            Labels_subj(subj,find((temp==dominant_states(subj,k))==1)) = counter;
            counter = counter +1;
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
%% compute community structures
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
dim = size(data{1},1);
est_network1 = zeros(dim,dim,K);
est_network2 = zeros(dim,dim,K);

for k=1:12
      
      %k = mode(dominant_states(j));
%       [est_network2(:,:,k),clust_mtx_partial(:,k)] = clusters_community_detection(partial_corr(:,:,k));
      [est_network2(:,:,k),clust_mtx_partial(:,k)] = clusters_community_detection_Newman(partial_corr(:,:,k),2);

      figure(1);
      subplot(3,4,k)
      axis square 
       cca_plotcausality_MyVersion2(est_network2(:,:,k),roi_names,.5);
      axis off
%       figure;
%       axis square 
%       imagesc(partial_corr(:,:,k) )
%      caxis([min(min(min(partial_corr))),max(max(max(partial_corr)))])
% %       caxis([-1,1])
%       set(gca, 'XTick', [0 6, 7, 10,11, 14,15, 20], 'XTickLabel',[ ] );
%       set(gca, 'YTick', [0 6, 7, 10,11, 14,15, 20], 'YTickLabel',[ ] );
% %       colorbar('northoutside')
% box off
end
%%
% % counter = 1;
% % temp = Labels_subj;
% % for k=1:K
% %       Labels_subj(find((temp==dominant_states(k))==1)) = counter;
% %       counter = counter +1;
% % end
% % figure(10000);
% % subplot(1,2,str2num(rep))
% % imagesc(Labels_subj);
% % pf2 = gca;
% % set(pf2,'YDir','normal')
% % % Create colormap:
% % map = brewermap(30,'pubugn');
% % %map(1,:) = [1 1 1]; % optionally force first color to white
% % colormap(ccc)
% % %cb = colorbar('location','south');
% % %caxis([1 12]) % sets colorbar limits
% % % another colorbar:
% % %cb2 = colorbar('location','northoutside');
% % c= colorbar('location','eastoutside')
% % ylabel(c, 'state')
% % ylabel('subject')
% %  xlabel('time instance')
% %   title(['Rest',rep])
% % box off
%% transition probabilities
temp = model.params.stran;
for k=1:K
      for j=1:K
            AA(k,j) = ( temp(dominant_states(j),dominant_states(k)));
      end
end
% BB = AA- diag(diag(AA));
indAA = find(diag(AA)>.000);
AA2 = AA(indAA,indAA);
BB= AA2- diag(diag(AA2));

figure(5);
imagesc(BB)
pf2 = gca;
% Create colormap:
map = brewermap(30,'oranges');
map(1,:) = [ 1 1 1]

colormap(map)
h= colorbar('location','eastoutside');
caxis([0 max(max(BB))]);
ylabel(h, 'cross-transition probability')
 xlabel('state')
 ylabel('state')
 box off
 figure;
bimg =  imagesc(diag(diag(AA)))
pf2 = gca;
% Create colormap:
map = brewermap(30,'blues');
map(1,:) = [ 1 1 1]
colormap(map)
h= colorbar('location','eastoutside');
caxis([0.6 1]);
ylabel(h, 'self-transition probability')
 xlabel('state')
 ylabel('state')
 box off
indAA = find(diag(AA)>.005);
AA2 = AA(indAA,indAA);
BB= AA2- diag(diag(AA2));


figure(12); 
subplot(1,2,1)
h1= histogram(diag(AA2))
xlabel('self-transition probability')
box off
subplot(1,2,2)

h2= histogram(BB(:))
xlabel('cross-transition probability')

h1.Normalization = 'probability';
h1.BinWidth = 0.05;
h2.Normalization = 'probability';
h2.BinWidth = 0.008;
h1.FaceColor = 'k'
h2.FaceColor = 'k'
box off

%
% A = imread('/Users/taghia/Desktop/A3.tif');
% B = imread('/Users/taghia/Desktop/B3.tif');
% C = imfuse(A,B,'blend','Scaling','independent');
% imwrite(C,'my_blend_overlay.tif');
% imshow(C);
