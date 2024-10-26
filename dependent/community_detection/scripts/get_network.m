function est_network = get_network(S)
clust_mtx = S(:);
est_network = zeros(length(clust_mtx));
for mm = 1:length(clust_mtx)-1
      for nn = mm+1:length(clust_mtx)
            if clust_mtx(mm) == clust_mtx(nn)
                  est_network(mm,nn) = 1; est_network(nn,mm) = 1;
            end
      end
end
