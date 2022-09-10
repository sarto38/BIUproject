function [mu] = mean_incremental(data_set)
%calculating the mean of full a dataset with incremental formulas
[r, ~] = size(data_set);
mu = data_set(1, :);
for k=2:r
    mu = mean_new_sample(mu, data_set(k, :), k);
end
end

