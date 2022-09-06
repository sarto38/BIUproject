[t0,t1] = getSets();


m0 = mean(double(t0));
m1 = mean(double(t1));
 
v0 = var(double(t0));
v1 = var(double(t1));
 
n_0 = length(t0);
n_1 = length(t1);
 
 
ttestOrd1 = (m0-m1)./sqrt(v0./n_0+v1./n_1);


moment_formula0 = (double(t0) - double(repmat(m0,length(t0),1))).^2;
moment_formula1 = (double(t1) - double(repmat(m1,length(t1),1))).^2;   
    
    
 
m0 = mean(double(moment_formula0));
m1 = mean(double(moment_formula1));
 
v0 = var(double(moment_formula0));
v1 = var(double(moment_formula1));
 
n_0 = length(t0);
n_1 = length(t1);
 
 
ttestOrd2 = (m0-m1)./sqrt(v0/n_0 + v1/n_1);


x=1:1:200;

figure
plot(x, ttestOrd1); hold on;
plot(x, ttestOrd2); hold on;
    
    