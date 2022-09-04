function [Mp_1] = Mp_vector_update_new_sample(p, n1, M_prev_1, y)
%calculating the total M_p vector for dataset
Mp_1 = zeros(size(M_prev_1));
Mp_1(1, :) = mean_new_sample(M_prev_1(1, :), y, n1+1);
for k=2:p
    Mp_1(k, :) = Mp_new_sample(k, n1, M_prev_1(1:k, :), y);
end
end

