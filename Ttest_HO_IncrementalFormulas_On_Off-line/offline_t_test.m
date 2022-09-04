function [t, v] = offline_t_test(Leakages, Results, d)
%offline calculating the t_test vectors for leakages vector
[n, T] = size(Leakages);
p = 2*d;
n_set0 = 0;
Mp_set0 = zeros(p, T);
n_set1 = 0;
Mp_set1 = zeros(p, T);

for k=1:n
    result = Results(k);
    Leakage = Leakages(k, :);
    %if the result is 0 we will chenge 
    %the Mp matrix for set0
    if result==0
        %update set0 size
        n_set0 = n_set0+1;
        %if this is not the first sample
        %then we will use the incremental
        %formulas in order to update the Mp matrix
        if n_set0>1
            Mp_set0 = Mp_vector_update_new_sample(p, n_set0-1, Mp_set0, Leakage);
        %else then this is the first sample for the set
        %mean = sample ; greater orders = 0
        else
            Mp_set0 = [Leakage; zeros(p-1, T)];
        end
    %same for result = 1 and set1
    else
        n_set1 = n_set1+1;
        if n_set1>1
            Mp_set1 = Mp_vector_update_new_sample(p, n_set1-1, Mp_set1, Leakage);
        else
            Mp_set1 = [Leakage; zeros(p-1, T)];
        end
    end
end

%calculate the Central Moments Incremental
CM_set0 = [Mp_set0(1, :); Mp_set0(2:end, :)./n_set0];
CM_set1 = [Mp_set1(1, :); Mp_set1(2:end, :)./n_set1];

%t is the t-test statistic vector
t = zeros(d, T);
%v is the degree of freedom of the system
%actually there is no need to calculate v
%but we did it anyway
v = zeros(d, T);
for ord=1:d
    [t(ord, :), v(ord, :)] = t_test(CM_set0, CM_set1, ord, n_set0, n_set1);
end

end

