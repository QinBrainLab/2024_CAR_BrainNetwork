% compute k_r

A_positive = A;
A_positive(A_positive<0) = 0;

A_negative = A;
A_negative(A_negative>=0) = 0;
A_negative = abs(A_negative);
A_full = {A_positive, A_negative};

k_r = zeros(number_of_groups, numel(A_full));
for A_choice=1: numel(A_full)
      A_temp = A_full{A_choice};
      for group = 1:number_of_groups
            %       k_r(group) = sum(k(find(S==group)));
            k_r(group, A_choice) = sum(sum(A_temp((S==group), :)));
      end
end

k_r = sum(k_r,2);
