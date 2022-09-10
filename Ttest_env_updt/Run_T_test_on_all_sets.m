close all
clear all
clc


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COMPUTE with All the Data in parallel but divide to chunks to reduce %
%%% Matrix sizes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_of_sets = 4;

for l = 1:1%num_of_sets
    tic
%     if l==1 || l==2
%         d=2;
%     else
%         d=3;
%     end
    d=2;
    if mod(l, 2)==1
        string = "";
        string2 ="2d-randomization";
        %string = "WDDL_Mask_Hierarchial";
        %string = "WDDL_Mask_Hierarchial_d=2_No1Ohm";
    else
        %string = "Mask";
        string = "";
        string2 ="3d";
    end
    %file_name = string+"_d="+num2str(d)+"_No1Ohm"; %file_name = "WDDL_MSK_d=2";
    %file_name = string+"_d="+num2str(d);%+"_No1Ohm"; %file_name = "WDDL_MSK_d=2";

    %file_name = string+"/WDDL_Mask_Hierarchial_d=1_No1Ohm/FvF";
    %file_name = string+"/Mask_d=2_No1Ohm/FvR";
    %file_title = "C:\Users\USER\Desktop\Traces";
    %runType = "FvR";
    %file_name = string+"/"+file_title;%+"/"+runType;
    regular_t_test=1;%1;


    Nfiles=10;%958;%197;%100;%1550;%1450;%1499;%850;%1499;
    skip_files = 0;%20;
    Nfiles = Nfiles-skip_files;
    NtracesPfile=20000;
    NsamplesPtrace_orig=600;%700;
    decim_inter = 1/2; %1/2; %1/4;% Decimation/Interpulation factor
    decim = round(1/decim_inter);
    NsamplesPtrace = round(NsamplesPtrace_orig*decim_inter);
    % load('AES_Sbox.mat');
    %byte = 3;
    T = NsamplesPtrace;

    Nchunks_real = 300;%75;%50;%70;%should be a divider of 900 (NsamplesPtrace)
    Nchunks = 1;%NsamplesPtrace/Nchunks_real; %should be a divider of 700 (NsamplesPtrace)
    Jumps = 10;%10;%100;

    t_inc_all = zeros(d, NsamplesPtrace);

    y1= zeros(NtracesPfile*Nfiles,1);
    if regular_t_test == 0
        if d <= 2
            max_ts = zeros(2, Nfiles/Jumps);
        else
            max_ts = zeros(3, Nfiles/Jumps);
        end
    end

    for chunk = 0:Nchunks_real:NsamplesPtrace-1
        tracesT=zeros(NtracesPfile*Nfiles, Nchunks_real);
        disp(['chunk: ',num2str(chunk)])
        for f=1:Nfiles
            %load_name = "./Traces/"+file_name+"/file"+num2str(f-1)+".mat";
            %load_name = "../"+file_name+"/file"+num2str(f-1)+".mat";
            %load_name = "./"+file_name+"/file"+num2str(f-1)+".mat";
            load_name = "./../Data/"+string2+"/File"+num2str(f+skip_files-1)+".mat";
            load([load_name]);
            chunk_idx=int16(chunk)+1;
            traces2(:,:) = traces(:,1:decim:end);
            tracesT((f-1)*NtracesPfile+1:f*NtracesPfile , :) = traces2(:,chunk_idx:chunk_idx+Nchunks_real-1);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%% UNTRACKED MODIFICATIONS %%%%%%%%%%%%%%%%%%%%%%%
            % plaintextsB = squeeze(plaintexts(1,f,1));%byte+1);
            %plaintextsB = squeeze(plaintexts(1,:,1));%plaintexts(1,f,1));%byte+1);
            %%%%%%%%%% END UNTRACKED MODIFICATIONS %%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %keyB = key(byte,1);
            %y = sum(de2bi(sbox(bitxor(plaintextsB,keyB)),8));
            inpByte = getSets(sendxs); %de2bi(plaintextsB);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%% UNTRACKED MODIFICATIONS %%%%%%%%%%%%%%%%%%%%%%%
            %y1((f-1)*NtracesPfile+1:f*NtracesPfile , 1)= inpByte(:,1);% y(:,1);
            y1((f-1)*NtracesPfile+1:f*NtracesPfile , 1)= inpByte;% y(:,1);
            %%%%%%%%%% END UNTRACKED MODIFICATIONS %%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if regular_t_test==0 && mod(f, Jumps)==0
                disp(['chunk: ',num2str(chunk),'. Nfiles: ',num2str(f),' out of 1100.'])
                toc
                tracesT_f = tracesT(1:f*NtracesPfile, :);
                y1_f = y1(1:f*NtracesPfile);
                [t_inc, v_inc] = chunks_leakges(tracesT_f, y1_f, d, Nchunks);
                if chunk==0 % if first chunk
                    curr_max_t1 = max(abs(t_inc(1,:)));
                    curr_max_t2 = max(abs(t_inc(2,:)));
                    if d==3
                        curr_max_t3 = max(abs(t_inc(3,:)));
                    end

                else
                    curr_max_t1 = max(max(abs(t_inc(1,:))), max_ts(1, f/Jumps));
                    curr_max_t2 = max(max(abs(t_inc(2,:))), max_ts(2, f/Jumps));
                    if d==3
                    curr_max_t3 = max(max(abs(t_inc(3,:))), max_ts(3, f/Jumps));
                    end
                end
                max_ts(1, f/Jumps) = curr_max_t1;
                max_ts(2, f/Jumps) = curr_max_t2;
                if d==3
                    max_ts(3, f/Jumps) = curr_max_t3;
                end
            end
        end
        if regular_t_test == 1
            [t_inc, v_inc] = chunks_leakges(tracesT, y1, d, Nchunks);
            chunk_idx=int16(chunk)+1;
            t_inc_all(1:d, chunk_idx:chunk_idx+Nchunks_real-1) = t_inc;
        end
    end

    if regular_t_test==1
        save("t_inc_all_"+string2+"_"+".mat", "t_inc_all");
    else
        save("max_ts"+string2+"_"+".mat", "max_ts");
    end 
%%
    if regular_t_test==1 
        %plot t-test statistic vector
        figure;
        for k=1:d
            subplot(ceil(d/2), 2, k)
            plot(t_inc_all(k, :)); hold on;
            plot(4.5*ones(size(t_inc_all(k, :))),'r'); hold on;
            plot(-4.5*ones(size(t_inc_all(k, :))),'r'); hold on;
            xlabel('Time Sample'); ylabel('T value');
            title(['Order #' num2str(k)])
            xlim([0 T])
            saveas(gcf, string2+".png")
        end
    end
%%
    if regular_t_test==0
        %plot t-test statistic vector
        figure;
        for k=1:d
            subplot(ceil(d/2), 2, k)
            plot(max_ts(k, :)); hold on;
            plot(4.5*ones(size(max_ts(k, :))),'r'); hold on;
            plot(-4.5*ones(size(max_ts(k, :))),'r'); hold on;
            xlabel(['Number of files(*',num2str(Jumps),')']); ylabel('max T value');
            title(['Order #' num2str(k)])
            xlim([0 T])
            saveas(gcf, 'max_ts_'+string2+".png")
        end
    end
    toc
end
    

%%
% tr= zeros(1,600);
% tr(1,:) = traces(1,1,:);
% plot(tr)
