function [Mp_set0, n_set0, Mp_set1, n_set1] = offline_t_first_file_for_online(Leakages, Results, d)
%offline calculating the t_test vectors for leakages vector
[n, T] = size(Leakages);
p = 2*d;
n_set0 = 0;
Mp_set0 = double(zeros(p, T));
n_set1 = 0;
Mp_set1 = double(zeros(p, T));

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


end

