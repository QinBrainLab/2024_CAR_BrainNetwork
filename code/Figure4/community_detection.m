%% load community_detection.mat 


addpath(genpath('E:\DST_multitask\CommunityDetection'));

% set task color
rest_color =  [0.44,0.71,0.63];
nback_color =  [0.42,0.67,0.92];
emo_color =   [0.91,0.47,0.38];
color_list = [emo_color;nback_color;rest_color; [0 0 0]];

%% plot

total_trans = hmm.P;

for q=1:10
     total_trans(q,q)=0; % exclude diag self-transitions
end
A = total_trans;
sort_A = sort(A(find(A(:)>0)),'descend');
thres_pro = 0.25;
thresh = sort_A(round(90*thres_pro));
A(A <= thresh-0.0001) = 0;
[est_network2,clust_mtx_partial] = community_detection_newman(A)

clear node_color
node_color = zeros(1,3);
for i=1:10
    node_color = [node_color;color_list(clust_mtx_partial(i),:)];
   % node_color = [node_color;color_list(node_cor_list(i),:)];
end
node_color(1,:) = [];

names = {'S1' 'S2' 'S3' 'S4','S5','S6','S7','S8','S9','S10'};
G = digraph(A,names,'omitselfloops');
all_edges = G.Edges.Weight;
max_edge = max(all_edges(all_edges >0));
min_edge = min(all_edges(all_edges >0));
RWidths = 4+5*((G.Edges.Weight-min_edge)/max_edge);
MSize = 100*nanmean(fractional_occupancy);
p = plot(G,'LineWidth',RWidths,'MarkerSize',MSize,'NodeFontSize',10,'NodeColor',node_color,'EdgeColor',[0.67 0.67 0.67]);