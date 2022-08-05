function [ inp00 ,inp01,inp10, inp11] = devide(file_offset,file_num,files_location)
g00 = [0, 2, 4, 6, 8, 15, 16, 22, 24, 27, 28, 31];
g01 = [10, 13, 19, 21];
g10 = [11, 12, 18, 20];
g11 = [1, 3, 5, 7, 9, 14, 17, 23, 25, 26, 29, 30];
clc = zeros(file_num*20000,1);
clc00 = 0;
clc01 = 0;
clc10 = 0;
clc11 = 0;
c00 = 1;
c01 = 1;
c10 = 1;
c11 = 1;



for j= 1+file_offset:file_num+file_offset
    data = load([files_location num2str(j-1) '.mat']);
    s = data.sendxs;
    fprintf('calc - file: %d \n',j-file_offset);
    for i = 1:20000
        
        if ismember(s(i),g00)
            clc((j-1-file_offset)*20000 + i) = 1;
            clc00 = clc00+1;
        elseif ismember(s(i),g01)
             clc((j-1-file_offset)*20000 + i) = 2;
            clc01 = clc01+1;
        elseif ismember(s(i),g10)
             clc((j-1-file_offset)*20000 + i) = 3;
            clc10 = clc10+1;
        elseif ismember(s(i),g11)
            clc((j-1-file_offset)*20000 + i) = 4;
            clc11 = clc11+1;
        end
    end
    
end

inp00 = zeros(clc00,600);
inp10 = zeros(clc01,600);
inp01 = zeros(clc10,600);
inp11 = zeros(clc11,600);

for j= 1+file_offset:file_num+file_offset
    data = load(['C:\Users\USER\Desktop\Traces\file' num2str(j-1) '.mat']);
    inp = data.traces;
    fprintf('add - file: %d \n',j-file_offset);
    for i = 1:20000
        
        if clc((j-1-file_offset)*20000 + i) == 1
            inp00(c00,:) = inp(i,:);
            c00 = c00+1;
        elseif clc((j-1-file_offset)*20000 + i) == 2
            inp01(c01,:) = inp(i,:);
            c01 = c01+1;
        elseif clc((j-1-file_offset)*20000 + i) == 3
            inp10(c10,:) = inp(i,:);
            c10 = c10+1;
        elseif clc((j-1-file_offset)*20000 + i) == 4
            inp11(c11,:) = inp(i,:);
            c11 = c11+1;
        end
    end
    
end