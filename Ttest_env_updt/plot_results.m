 %% file_name = "d=2";
 % file_name = "WDDL_MSK_d=2";
num_of_sets = 4;

for l = 3:3%num_of_sets
    tic
    if l==1 || l==2
        d=2;
    else
        d=3;
    end
    if mod(l, 2)==0
        string = "WDDL_Mask_Hierarchial";
    else
        string = "Mask";
    end
    file_name = string+"_d="+num2str(d)+"_No1Ohm_badrandomness_FIFO"; %file_name = "WDDL_MSK_d=2";
    
    regular_t_test=1;%0;


    
    if regular_t_test==1 
        %plot t-test statistic vector
        path = "t_inc_all_" + file_name;
        load(path)
        %if mod(l, d)==1
            figure;
        %end
        %figure(1)
        for k=1:d
            subplot(ceil(d/2), 2, k)
            plot(t_inc_all(k, :)); hold on;
            plot(4.5*ones(size(t_inc_all(k, :))),'r'); hold on;
            plot(-4.5*ones(size(t_inc_all(k, :))),'r'); hold on;
            xlabel('Time Sample'); ylabel('T value');
            title(['Order #' num2str(k)])
        end
        sgtitle(strrep(file_name,'_',' '));
        saveas(gcf, file_name+".png")
    end

    if regular_t_test==0
        %plot t-test statistic vector
        path = "max_ts" + file_name;
        load(path)
        %if mod(l, d)==1
            figure;
        %end
        %figure(1)
        for k=1:d
            subplot(ceil(d/2), 2, k)
            plot(max_ts(k, :)); hold on;
            plot(4.5*ones(size(max_ts(k, :))),'r'); hold on;
            plot(-4.5*ones(size(max_ts(k, :))),'r'); hold on;
            xlabel('Number of files(*'+string(Jumps)+')'); ylabel('max T value');
            title(['Order #' num2str(k)])
        end
        sgtitle(strrep(file_name,'_',' '));
        saveas(gcf, 'max_ts_'+file_name+".png")
    end
    
end