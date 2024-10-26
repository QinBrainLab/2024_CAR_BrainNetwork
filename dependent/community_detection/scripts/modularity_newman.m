% M. E. J. Newmann (2016), community detection in networks: Modularity optimization and maximum likelihood are equivalent.

%taghia@stanford.edu

function [S, Q, gamma, wo] = modularity_newman(A, gamma, max_iter, tol, method)
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
gamma_old = -inf;
A_positive = A;
A_positive(A_positive<0) = 0;
k_positive = full(sum(A_positive)); 
A_negative = A;
A_negative(A_negative>=0) = 0;
A_negative = abs(A_negative);
k_negative = full(sum(A_negative));
k = k_positive + k_negative;
% k = full(sum(A)); % sum((k) = 2m
twom = sum(k); % 2m
m = twom/2;
diff_gamma = 1e10;
iter =1;
display('............................learning...........................')
while iter<max_iter  && diff_gamma>tol
      switch method
            case 'louvain'
                  if sum(all(A>=0))==n_nodes 
                        [S, Q] = community_louvain(A, gamma);
                  else
                  [S, Q] = community_louvain(A, gamma, [], 'negative_asym');
                  end
%                   [S, Q] = community_louvain(A, gamma);

            case 'newman'
                   if sum(all(A>=0))==n_nodes 
                        [S,Q] = modularity_und(A,gamma);
                   else
                         error('does not support negative adj matrix. Try Louvain method')
                   end
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
 display(['Q:  ', num2str(Q),'            optimized gamma:  ', num2str(gamma), '            number of communities:  ', num2str(numel(unique(S)))])


