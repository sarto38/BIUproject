function [mu] = mean_two_groups(mu1, mu2, n1, n2)
%calculating the mean of two difference groups together
mu = mu1 + n2.*(mu2-mu1)./(n1+n2);
end

