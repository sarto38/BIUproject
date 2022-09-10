close all
clear all
clc
tic

Compute_parallel_OR_incremental = 1; % 1 is parallel

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COMPUTE with All the Data in parallel but divide to chunks to reduce %
%%% Matrix sizes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Nfiles=3;
NtracesPfile=10000;
NsamplesPtrace=700;
load('AES_Sbox.mat');
byte = 3;
T = NsamplesPtrace;
d=2;
Nchunks = 10; %should be a divider of 700 (NsamplesPtrace)

if Compute_parallel_OR_incremental==1
    tracesT=zeros(NtracesPfile*Nfiles, NsamplesPtrace);
    y1=zeros (NtracesPfile*Nfiles,1);
    for f=1:3
        load(['file', num2str(f-1),'.mat']);
        tracesT((f-1)*NtracesPfile+1:f*NtracesPfile , :) = traces(1,:,:);
        plaintextsB = plaintexts(1,:,byte+1);
        %keyB = key(byte,1);
        %y = sum(de2bi(sbox(bitxor(plaintextsB,keyB)),8));
        inpByte = de2bi(plaintextsB);
        y1((f-1)*NtracesPfile+1:f*NtracesPfile , 1)= inpByte(:,1);% y(:,1);
    end


    [t_inc, v_inc] = chunks_leakges(tracesT, y1, d, Nchunks);

    %plot t-test statistic vector
    figure(1)
    for k=1:d
        subplot(ceil(d/2), 2, k)
        plot(t_inc(k, :)); hold on;
        plot(4.5*ones(size(t_inc(k, :))),'r'); hold on;
        plot(-4.5*ones(size(t_inc(k, :))),'r'); hold on;
        xlabel('Time Sample'); ylabel('T value');
        title(['Order #' num2str(k)])
        xlim([0 T])
    end


else
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COMPUTE with incremented formulea %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Matrix sizes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    for f=1:3
        load(['file', num2str(f-1),'.mat']);
        traces = squeeze(traces(1,:,:));
        plaintextsB = plaintexts(1,:,byte+1);
        %keyB = key(byte,1);
        %y = sum(de2bi(sbox(bitxor(plaintextsB,keyB)),8));
        inpByte = de2bi(plaintextsB);

        if f==1
            [Mp_set0, n_set0, Mp_set1, n_set1] = offline_t_first_file_for_online(traces, inpByte(:,1), d);
        elseif f==Nfiles
            [t, v] = online_t_test_final_step(Mp_set0, n_set0, Mp_set1, n_set1, traces(inpByte(:,1)==0,:), traces(inpByte(:,1)==1,:));
        else
            [Mp_set0, n_set0, Mp_set1, n_set1] = online_t_test(Mp_set0, n_set0, Mp_set1, n_set1, traces(inpByte(:,1)==0,:), traces(inpByte(:,1)==1,:));
        end
    end


    T = NsamplesPtrace;
    d=2;

    %plot t-test statistic vector
    figure(2)
    for k=1:d
        subplot(ceil(d/2), 2, k)
        plot(t(k, :)); hold on;
        plot(4.5*ones(size(t(k, :))),'r'); hold on;
        plot(-4.5*ones(size(t(k, :))),'r'); hold on;
        xlabel('Time Sample'); ylabel('T value');
        title(['Order #' num2str(k)])
        xlim([0 T])
    end

end


% 
% 
% figure(1)
% sgtitle(['SNR = 10^{' num2str(log10(SNR)) '}, n = 2^{' num2str(n0) '}'])
% fig_title = [char('d_') char(num2str(d)) char(' - SNR_10^') char(num2str(log10(SNR))) char(' - n_2^') char(num2str(n0))];
% % saveas(gcf, [fig_title '.jpg']);
% 
% t1 = toc;
% s = ['SNR = 10^{' num2str(log10(SNR)) '}, n = 2^{' num2str(n0) '}, d = ' num2str(d) ', t = ' num2str(t1)]
% 
% 
% 
% 
% 
% SNR = 10^(-1);
% VARIANCE_noise = 0.25./SNR;
% sigma = sqrt(VARIANCE_noise);
% n0 = 14;
% n = 2^n0;
% d = 2;
% p = 2*d;
% rep = 10;
% z = 40;
% T = 2*z+rep;
% 
% 
% LeakageT = zeros(n, T);
% ResultT = zeros(n, 1);
% 
% for k=1:n
%     %key
%     result = randi(2)-1;
%     %masking
%     max_order = d-2;
%     s0 = (randi(2)-1).*(0<=max_order);
%     s1 = (randi(2)-1).*(1<=max_order);
%     s2 = (randi(2)-1).*(2<=max_order);
%     s3 = (randi(2)-1).*(3<=max_order);
%     s4 = (randi(2)-1).*(4<=max_order);
%     %if e.g. max_order=4 ->s5=s6=0 and they will not effect XOR_all, s7,
%     %and s
%     s5 = (randi(2)-1).*(5<=max_order);
%     s6 = (randi(2)-1).*(6<=max_order);
%     XOR_all = bitxor(s0, bitxor(s1, bitxor(s2, bitxor(s3, bitxor(s4, bitxor(s5, s6))))));
%     
%     s7 = bitxor(result, XOR_all);
%     s = s0+s1+s2+s3+s4+s5+s6+s7;
%     
%     %Leakage vector
%     Leakage = [zeros(1, z) repmat(s, 1, rep) zeros(1, z)];
%     Leakage = Leakage+randn(size(Leakage)).*sigma;
%     
%     %saving each result and each leakage vector
%     ResultT(k) = result;
%     LeakageT(k, :) = Leakage;
%     
% end
% Nchunks = 9;
% [t_inc, v_inc] = chunks_leakges(LeakageT, ResultT, d, Nchunks);
% 
% %plot t-test statistic vector
% figure(1)
% for k=1:d
%     subplot(ceil(d/2), 2, k)
%     plot(t_inc(k, :))
%     title(['Order #' num2str(k)])
%     xlim([0 T])
% end
% figure(1)
% sgtitle(['SNR = 10^{' num2str(log10(SNR)) '}, n = 2^{' num2str(n0) '}'])
% fig_title = [char('d_') char(num2str(d)) char(' - SNR_10^') char(num2str(log10(SNR))) char(' - n_2^') char(num2str(n0))];
% % saveas(gcf, [fig_title '.jpg']);
% 
% t1 = toc;
% s = ['SNR = 10^{' num2str(log10(SNR)) '}, n = 2^{' num2str(n0) '}, d = ' num2str(d) ', t = ' num2str(t1)]

