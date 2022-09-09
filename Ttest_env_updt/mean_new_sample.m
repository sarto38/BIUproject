function [mu] = mean_new_sample(mu1, y, n)
%mu = new mean
%mu1 = prev mean
%y = new sample
%n = total number of samples
mu = double(mu1) + (double(y)-double(mu1))./n;
end

