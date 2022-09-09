close all
clear all
clc

n = 2^16;
l = 50;
p = 6;
mat = rand(n, l);
Mp_inc = zeros(p, l);
Mp_inc(1, :) = mat(1, :);
for k=2:n
    Mp_inc = Mp_vector_update_new_sample(p, k-1, Mp_inc, mat(k, :));
end

Mp = zeros(p, l);
Mp(1, :) = sum(mat)./n;
for k=2:p
    Mp(k, :) = sum((mat-Mp(1,:)).^k);
end

figure
for k=1:p
    subplot(ceil(p/2), 2, k)
    plot(Mp_inc(k, :))
    hold on
    plot(Mp(k, :), '.')
    title(['p = ' num2str(k)])
    xlim([0 l])
end