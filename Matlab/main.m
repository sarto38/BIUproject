clear
[ t00,t01,t10, t11]= devide(0,50,'C:\Users\USER\Desktop\Traces\2d');
save('result1.mat','t00','t01','t10', 't11','-v7.3');
clear
[ b00,b01,b10, b11]= devide(0,50,'C:\Users\USER\Desktop\Traces\2d+r');
save('result2.mat','b00','b01','b10', 'b11','-v7.3');
clear
[ c00,c01,c10, c11]= devide(0,50,'C:\Users\USER\Desktop\Traces\2d+f');
save('result3.mat','c00','c01','c10', 'c11','-v7.3');
clear


load('result1.mat','t00','t01','t10', 't11')
load('result2.mat','b00','b01','b10', 'b11')
load('result3.mat','c00','c01','c10', 'c11')

%t01 = t01(:,1:200);



    m01 = mean(double(t00));
    m11 = mean(double(t11));
    var01 = var(double(t00));
    var11 = var(double(t11));
    
    
    m02 = mean(double(b00));
    m12 = mean(double(b11));
    var02 = var(double(b00));
    var12 = var(double(b11));
    
    m03 = mean(double(c00));
    m13 = mean(double(c11));
    var03 = var(double(c00));
    var13 = var(double(c11));

    
    subplot(2,1,1);
    plot(m01-m11);
    hold on
    plot(m02-m12);
    hold on
    plot(m03-m13);
    legend('Only masking','Masking + randomization','Masking + flattening')
    title('mean');
    
    subplot(2,1,2);
     plot(var01-var11);
     hold on
     plot(var02-var12);
     hold on
     plot(var03-var13);
     legend('Only masking','Masking + randomization','Masking + flattening')
    title('var');
