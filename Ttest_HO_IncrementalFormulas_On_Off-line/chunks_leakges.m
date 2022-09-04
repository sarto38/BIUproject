function [t, v] = chunks_leakges(Leakage, Result, d, Nchunks)
%calculating the t_test vectors offline mode
%deviding the samples in time into chuncks in order to calculat in parallel
T = size(Leakage, 2);
time = 1:T;
t_temp = zeros(Nchunks, d, T./Nchunks);
v_temp = zeros(Nchunks, d, T./Nchunks);
t = zeros(d, T);
v = zeros(d, T);
%calculate in parallel the t_test for each chunck
parfor k=1:Nchunks
    %which samples to take
    samp = time((1+(k-1).*T./Nchunks):(k.*T./Nchunks));
    LeakageC = Leakage(:, samp);
    %calculate for specific chunck
    [t_C, v_C] = offline_t_test(LeakageC, Result, d);
    t_temp(k, :, :) = t_C;
    v_temp(k, :, :) = v_C;
end
%combining the results into one long vector
for k=1:Nchunks
    samp = time((1+(k-1).*T./Nchunks):(k.*T./Nchunks));
    t(:, samp) = reshape(t_temp(k, :, :), d, T./Nchunks);
    v(:, samp) = reshape(v_temp(k, :, :), d, T./Nchunks);
end
end

