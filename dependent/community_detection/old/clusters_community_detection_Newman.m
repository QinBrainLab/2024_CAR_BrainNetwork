function [est_network,clust_mtx] = clusters_community_detection_Newman(conn_mtx, gamma)
if nargin<2
      gamma =1;
end
conn_mtx = conn_mtx-diag(diag(conn_mtx));
gamma_old = gamma;
diff_gamma = inf;
count = 0;
while diff_gamma>1e-5 && count<200
      [Ci, Q] = community_louvain(conn_mtx, gamma, [], 'negative_asym');
      for irep = 1:100
            [Ci_next, Q_next] = community_louvain(conn_mtx, gamma, [], 'negative_asym');
            if Q_next > Q
                  Q = Q_next; Ci = Ci_next;
            end
      end
      
      %       Q_all = [];
      %       Ci_all = [];
      %       [Ci, Q] = community_louvain(conn_mtx, gamma, [], 'negative_asym');
      %       for irep = 1:100
      %             [Ci_next, Q_next] = community_louvain(conn_mtx, gamma, Ci, 'negative_asym');
      %             Q = Q_next;
      %             Ci = Ci_next;
      %             Q_all = [Q_all, Q];
      %             Ci_all = [Ci_all, Ci];
      %       end
      %       [val_Q, ind_Q] = max(Q_all);
      %       Q = val_Q;
      %       Ci = Ci_all(:, ind_Q);
      %
      clust_mtx = Ci(:);
      est_network = zeros(length(clust_mtx));
      for m = 1:length(clust_mtx)-1
            for n = m+1:length(clust_mtx)
                  if clust_mtx(m) == clust_mtx(n)
                        est_network(m,n) = 1; est_network(n,m) = 1;
                  end
            end
      end
      
      number_of_groups = numel(unique(clust_mtx));
      number_of_nodes = numel(clust_mtx);
      [degree_in,degree_out, degree_all] = degrees_dir(est_network);
      k_r = zeros(number_of_groups,1);
      for group = 1:number_of_groups
            %                   k_r (group) = sum(sum(est_network(find(clust_mtx==group), :)));
            k_r (group) = sum(degree_in( find(clust_mtx==group)));
      end
      
      m_in = .25*sum(degree_in);
      m_out = .25*sum(degree_out);
      m_all = (m_in + m_out);
      w_in = 2*m_in/sum(k_r.^2./(2*m_all));
      w_out = (2*m_all - 2*m_in)/(2*m_all - sum(k_r.^2./(2*m_all)));
      
      gamma = (w_in - w_out)./(log(w_in) - log(w_out));
      B = m_all * log(w_in/w_out);
      if isnan(gamma)
            warning('singularity: last estimated gamma is used')
            gamma = gamma_old;
      end
      diff_gamma = abs(gamma - gamma_old);
      gamma_old = gamma;
      display(['improvement in optimizing gamma:', num2str(diff_gamma)])
      
      
      count = count +1;
end

display(['optimal gamma:', num2str(gamma)])
