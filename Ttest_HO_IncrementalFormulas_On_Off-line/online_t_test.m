function [Mp_set0, n_set0, Mp_set1, n_set1] = online_t_test(Mp_set0, n_set0, Mp_set1, n_set1, new_traces_set0, new_traces_set1)
%combining between an old moments of order p and new matrices of traces
%returning the t_test vectors
p = size(Mp_set0, 1);
d = p/2;
%n_set_0_new is the amount of new traces for the new matrix with result 0 
%n_set_1_new is the amount of new traces for the new matrix with result 1
%T is the amount of time samples and it is the same for both matrices

[n_set0_new, T] = size(new_traces_set0);
n_set1_new = size(new_traces_set1, 1);

%calculating the new Mp matrix for set 0
Mp_set0_new = zeros(size(Mp_set0));
for k=1:n_set0_new
    Leakage = new_traces_set0(k, :);
    if k>1
    	Mp_set0_new = Mp_vector_update_new_sample(p, k-1, Mp_set0_new, Leakage);
        %else then this is the first sample for the set
        %mean = sample ; greater orders = 0
    else
        Mp_set0_new = [Leakage; zeros(p-1, T)];
    end
end
%calculating the new Mp matrix for set 0
Mp_set1_new = zeros(size(Mp_set1));
for k=1:n_set1_new
    Leakage = new_traces_set1(k, :);
    if k>1
    	Mp_set1_new = Mp_vector_update_new_sample(p, k-1, Mp_set1_new, Leakage);
        %else then this is the first sample for the set
        %mean = sample ; greater orders = 0
    else
        Mp_set1_new = [Leakage; zeros(p-1, T)];
    end
end

%combining between the old Mp matrix and the new Mp matrix
%for each set
Mp_set0_comb = zeros(size(Mp_set0));
Mp_set1_comb = zeros(size(Mp_set1));
Mp_set0_comb(1, :) = mean_two_groups(Mp_set0(1, :), Mp_set0_new(1, :), n_set0, n_set0_new);
Mp_set1_comb(1, :) = mean_two_groups(Mp_set1(1, :), Mp_set1_new(1, :), n_set1, n_set1_new);
for k=2:p
    Mp_set0_comb(k, :) = Mp_two_groups(k, n_set0, n_set0_new, Mp_set0, Mp_set0_new);
    Mp_set1_comb(k, :) = Mp_two_groups(k, n_set1, n_set1_new, Mp_set1, Mp_set1_new);
end
n_set0 = n_set0+n_set0_new;
n_set1 = n_set1+n_set1_new;


Mp_set0 = Mp_set0_comb;
Mp_set1 = Mp_set1_comb;

end

