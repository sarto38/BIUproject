function [Mp_inc] = Mp_two_groups(p, n1, n2, M_prev_1, M_prev_2)
%combaining between two groups and calculating the central sum with order p
%for the new group with the central sums with orders {1,...,p} for each group 
%                 !!! p>1 !!!
%M_prev_1 and M_prev_2 contains all the orders 1-p of group1 and group2
Mp_inc = M_prev_1(end, :) + M_prev_2(end, :);
delta21 = M_prev_2(1, :) - M_prev_1(1, :);
n = n1+n2;
for k=1:(p-2)
   Mp_inc_k = nchoosek(p,k).*(((-n2/n)^k).*(M_prev_1(p-k, :))+((n1/n).^k).*(M_prev_2(p-k, :))).*(delta21.^k); 
   Mp_inc = Mp_inc + Mp_inc_k;
end
Mp_inc = Mp_inc +((n1.*n2.*delta21./n).^p).*(1./(n2.^(p-1))-(-1./n1).^(p-1));
end

