%update_objective_function

obj_fun = @(v) C + (A(:,v) - gamma*k'*k(v)/twom)*B;

