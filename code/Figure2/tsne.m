% t-SNE analysis load tsne_data.mat
rest_color =  [0.44,0.71,0.63];
nback_color =  [0.33,0.67,1];
emo_color =   [1,0.41,0.29];
clear species
for i=1:61  
    species{i,1} = 'rest';
    species{i+61,1} = 'emotion';
    species{i+61*2,1} = 'nback';
end

clear meas Y 
meas = [fractional_occupancy_rs;fractional_occupancy_em;fractional_occupancy_wm];
Y = tsne(meas);
gscatter(Y(:,1),Y(:,2),species)