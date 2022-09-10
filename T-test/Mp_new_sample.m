function [Mp_inc] = Mp_new_sample(p, n1, M_prev_1, y)
%combaining between one group and a new sample
%and calculating the central sum with order p
%for the new group with the central sums with orders {1,...,p} for group1
%                 !!! p>1 !!!
%M_prev_1 contains all the orders 1-p for group1
Mp_inc = double(M_prev_1(end, :));
delta21 = double(y) - double(M_prev_1(1, :));
n = n1+1;
for k=1:(p-2)
   Mp_inc_k = nchoosek(p,k).*(double(double(-delta21./n).^k).*double(M_prev_1(p-k, :))); 
   Mp_inc = Mp_inc + Mp_inc_k;
end
Mp_inc = Mp_inc +(double(n1*delta21./n).^p)*(1-double((-1/n1).^(p-1)));
end

