function [outs] = getSets(sendx)%,file)

%data = load(file);
%sendx = data.sendxs;
%data = data.traces(:,1:200);
%numOfOne=0;
%numOfZero=0;
length = size(sendx,1);
res = dec2bin(sendx,5);
outs = zeros(length,1);

 for i = 1:length
    outs(i) = and(xor(str2double(res(i,4)),str2double(res(i,5))),xor(str2double(res(i,2)),str2double(res(i,3))));
 end

% set_0 = zeros(numOfZero,200);
% set_1 = zeros(numOfOne,200);
% 
% tmp_1 = 1;
% tmp_0 = 1;
% 
%  for i = 1:20000
%     if sendx(i) == 1
%        set_1(tmp_1,:) = data(i,:);
%        tmp_1=tmp_1+1;
%     else
%        set_0(tmp_0,:) = data(i,:);
%        tmp_0=tmp_0+1;
%     end 
%  end
