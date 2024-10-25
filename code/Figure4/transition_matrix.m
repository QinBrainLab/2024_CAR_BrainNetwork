% Transition matrix analysis, load community_detection.mat
addpath(genpath('E:\MGZ_dynamics_project\BSDS\Scripts\CommunityDetection'))

for i=1:length(data)
   T{1,i} = [170 228 150];
end

mask = {[1:170],[171:398],[399:548]};
for i=1:60
    t0= 548*i+1;
    t1=t0+169;t2=t1+228;t3=t2+150;
    mask =  [mask,{[t0:t1],[(t1+1):t2],[(t2+1):t3]}];
end

[P,Pi] = getMaskedTransProbMats(data_t,T,hmm,mask,Gamma);

trans_matrix = reshape(P,3,61)';

% remove diag self trans

for i=1:61
    for j=1:3
        trans_matrix{i,j}(logical(eye(size(trans_matrix{i,j}))))=0;
        for q=1:10
            trans_matrix{i,j}(q,:) = trans_matrix{i,j}(q,:)/sum(trans_matrix{i,j}(q,:));
        end
    end
end

for i=1:61
    trans_rs(i,:) = reshape(trans_matrix{i,1}',1,100);
    trans_wm(i,:) = reshape(trans_matrix{i,2}',1,100);
    trans_em(i,:) = reshape(trans_matrix{i,3}',1,100);
end


trans_mat{1,1} = mean(trans_rs);
trans_mat{1,2} = mean(trans_wm);
trans_mat{1,3} = mean(trans_em);
   
f = figure;
title_list = {'WM-Rest','EM-Rest','EM-WM'};
   subplot(1,3,1)
  % clim = [0 1];
   imagesc(reshape(trans_mat{1,2},10,10)'-reshape(trans_mat{1,1},10,10)');
  % imagesc(reshape(trans_mat{1,i},10,10)'-diag(diag(reshape(trans_mat{1,i},10,10)')));
    xticks([1:10])
    yticks([1:10])
    caxis([-0.06 0.1])
    %set(gca,'XTickLabelRotation',90)
    title(title_list{1})
    box off
    subplot(1,3,2)
  % clim = [0 1];
   imagesc(reshape(trans_mat{1,3},10,10)'-reshape(trans_mat{1,1},10,10)');
  % imagesc(reshape(trans_mat{1,i},10,10)'-diag(diag(reshape(trans_mat{1,i},10,10)')));
    xticks([1:10])
    yticks([1:10])
    caxis([-0.06 0.1])
    %set(gca,'XTickLabelRotation',90)
    title(title_list{2})
    box off
    subplot(1,3,3)
  % clim = [0 1];
   imagesc(reshape(trans_mat{1,3},10,10)'-reshape(trans_mat{1,2},10,10)');
  % imagesc(reshape(trans_mat{1,i},10,10)'-diag(diag(reshape(trans_mat{1,i},10,10)')));
    xticks([1:10])
    yticks([1:10])
    caxis([-0.06 0.1])
    %set(gca,'XTickLabelRotation',90)
    title(title_list{3})
    f.Color = 'w';
    box off
    