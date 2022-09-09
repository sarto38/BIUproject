function [t, v] = t_test(CM_set0, CM_set1, ord, n_set0, n_set1)
%returning the t_test vectors for specific order
if (ord==1)
    %calculating the vector t for the first order
    %with the regular mean and variance
    %%%%%%%%%%%%%%%%% CHANGE - FIX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     t = (CM_set0(1, :)-CM_set1(1, :))./sqrt((CM_set0(2, :)./n_set0)+(CM_set1(2, :)./n_set1));

    %v1, v2, v3 are interim calculation
    v1 = ((CM_set0(2, :)./n_set0)+(CM_set1(2, :)./n_set1)).^2;
    v2 = ((CM_set0(2, :)./n_set0).^2)./(n_set0-1);
    v3 = ((CM_set1(2, :)./n_set1).^2)./(n_set1-1);
    v = v1./(v2+v3);
elseif (ord==2)
    %for the second order, we cannot use the regular expanded formula
    %because the mean will be CM_2/(sqrt(CM_2)^2) = 1
    %therefore the mean for key0 will be equal to the mean for key1
    %and t will be 0.
    %we will use the same formula but without deviding by sqrt(CM_2)^2
    %mean = CM_2
    %and s^2 will be just CM_4-(CM_2)^2
    mu_set0_ord = CM_set0(ord, :);
    mu_set1_ord = CM_set1(ord, :);
    s_set0_ord_sq = (CM_set0(2*ord, :)-(CM_set0(ord, :).^2));%abs((CM_set0(2*ord, :)-(CM_set0(ord, :).^2)));
    s_set1_ord_sq = (CM_set1(2*ord, :)-(CM_set1(ord, :).^2));%abs((CM_set1(2*ord, :)-(CM_set1(ord, :).^2)));
    %%%%%%%%%%%%%%%%% CHANGE - FIX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     t = (mu_set0_ord-mu_set1_ord)./(sqrt((s_set0_ord_sq./n_set0)+(s_set1_ord_sq./n_set1)));
    v1 = ((s_set0_ord_sq./n_set0)+(s_set1_ord_sq./n_set1)).^2;
    v2 = ((s_set0_ord_sq./n_set0).^2)./(n_set0-1);
    v3 = ((s_set1_ord_sq./n_set1).^2)./(n_set1-1);
    v = v1./(v2+v3);
else
    %calculating the t-test statistic vector for higher orders
    mu_set0_ord = CM_set0(ord, :)./(sqrt(CM_set0(2, :)).^ord);
    mu_set1_ord = CM_set1(ord, :)./(sqrt(CM_set1(2, :)).^ord);
    s_set0_ord_sq = abs((CM_set0(2*ord, :)-(CM_set0(ord, :).^2))./(CM_set0(2, :).^ord));
    s_set1_ord_sq = abs((CM_set1(2*ord, :)-(CM_set1(ord, :).^2))./(CM_set1(2, :).^ord));
    %%%%%%%%%%%%%%%%% CHANGE - FIX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     t = (mu_set0_ord-mu_set1_ord)./(sqrt((s_set0_ord_sq./n_set0)+(s_set1_ord_sq./n_set1)));
    v1 = ((s_set0_ord_sq./n_set0)+(s_set1_ord_sq./n_set1)).^2;
    v2 = ((s_set0_ord_sq./n_set0).^2)./(n_set0-1);
    v3 = ((s_set1_ord_sq./n_set1).^2)./(n_set1-1);
    v = v1./(v2+v3);
end
end

