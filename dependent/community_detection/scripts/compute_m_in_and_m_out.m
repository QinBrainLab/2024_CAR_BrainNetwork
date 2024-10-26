A_positive = A;
A_positive(A_positive<0) = 0;

A_negative = A;
A_negative(A_negative>=0) = 0;
A_negative = abs(A_negative);
A_full = {A_positive, A_negative};
m_out = zeros(1, numel(A_full));
m_in = zeros(1, numel(A_full));
for A_choice=1: numel(A_full)
      A_temp = A_full{A_choice};
      wo = zeros(n_nodes, n_nodes, number_of_groups, number_of_groups);
      for group1 = 1:number_of_groups
            id1 = double(S==group1);
            for group2 = 1:number_of_groups
                  id2 = double(S==group2);
                  wo(:,:,group1, group2) = id1*id2';
            end
      end
      
      m_in(A_choice) = 0;
      for group = 1:number_of_groups
            m_in(A_choice)  = m_in(A_choice)  + sum(sum(wo(:,:,group, group).*A_temp));
      end
      m_in(A_choice)  = 0.5* m_in(A_choice) ;
      
      wo_temp = wo;
      for group = 1:number_of_groups
            wo_temp(:, :, group, group) = zeros(n_nodes, n_nodes);
      end
      
      m_out(A_choice) = 0;
      for group1 = 1:number_of_groups
            for group2= 1:number_of_groups
                  m_out(A_choice) = m_out(A_choice)+ sum(sum(wo_temp(:,:,group1, group2).*A_temp));
            end
      end
      m_out(A_choice) = 0.5* m_out(A_choice);
end

m_out = sum(m_out);
m_in = sum(m_in);