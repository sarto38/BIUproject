data = load('C:\Users\USER\Desktop\BIUproject\Data\2d\File8.mat');
sendx = data.sendxs;
data = data.traces(:,1:200);
numOfOne=0;
numOfZero=0;

 for i = 1:20000
    res = dec2bin(sendx(i),5);
    isw = and(xor(str2double(res(4)),str2double(res(5))),xor(str2double(res(2)),str2double(res(3))));
    if isw == 1
       sendx(i) = 1;
       numOfOne=numOfOne+1;
    else
       sendx(i) = 0;
       numOfZero=numOfZero+1;
    end 
 end

set_0 = zeros(numOfZero,200);
set_1 = zeros(numOfOne,200);

tmp_1 = 1;
tmp_0 = 1;

 for i = 1:20000
    if sendx(i) == 1
       set_1(tmp_1,:) = data(i,:);
       tmp_1=tmp_1+1;
    else
       set_0(tmp_0,:) = data(i,:);
       tmp_0=tmp_0+1;
    end 
 end
