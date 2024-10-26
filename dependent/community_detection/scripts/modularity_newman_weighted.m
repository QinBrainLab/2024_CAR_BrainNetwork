% M. E. J. Newmann (2016), community detection in networks: Modularity optimization and maximum likelihood are equivalent.

%taghia@stanford.edu

function [S, Q, wo] = modularity_newman_weighted(A, gamma, max_iter, tol, method)
display('........................initialization........................')
if nargin<5
      method = 'newman';
      display('newman method as default ')

end
if nargin<3
      max_iter =100;
      display(['defalut value of max_iter:  ', num2str(max_iter)])
end
if nargin<4
      tol = 1e-3;
      display(['defalut value of tolerance:  ', num2str(tol)])

end
if nargin<2
      gamma = 1;
      display(['defalut value of gamma:  ', num2str(gamma)])
end

n_nodes = size(A,2);
gamma_old = inf;
k = full(sum(A)); % sum((k) = 2m
twom = sum(k); % 2m
m = twom/2;
diff_gamma = 1e10;
iter =1;
display('.......................learning........................')
while diff_gamma>tol && iter<max_iter
      switch method
            case 'louvain'
                  [S, Q] = community_louvain(A, gamma, [], 'negative_asym');
%                   [S, Q] = community_louvain(A, gamma);

            case 'newman'
                  [S,Q] = modularity_und(A,gamma);
      end
      number_of_groups = numel(unique(S));
      compute_m_in_and_m_out;
      compute_k_r;
      w_in = 2*m_in/sum(k_r.^2./(2*m));
      w_out = (2*m - 2*m_in)/(2*m - sum(k_r.^2./(2*m)));
      gamma = (w_in - w_out)./(log(w_in) - log(w_out));
      diff_gamma = abs(gamma - gamma_old);
      gamma_old = gamma;
      iter = iter+1;
end
 display([ 'improvement in optimizing gamma:  ', num2str(diff_gamma),'            required number of itearations:  ', num2str(iter)])
 display(['            ']);
 display(['Q:  ', num2str(Q),'            optimized gamma:  ', num2str(gamma), '            number of commmunities:  ', num2str(numel(unique(S)))])


