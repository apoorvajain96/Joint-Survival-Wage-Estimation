% This function calculates the minimum and maximum values i.e the range for numerical
% integration over b and c. These values are used in the file
% joint_survival_wage_estm when using integral2. 


function [b_max, c_max] = bc_bounds(sigma_b, sigma_c, rho)
A = [1/(sigma_b^2),-rho/(sigma_b*sigma_c); -rho/(sigma_b*sigma_c), 1/(sigma_c^2)];
[R,S,~] = svd(A);
inv_sigma2_w = S(1,1);
inv_sigma2_z = S(2,2);
sigma_w = 1/sqrt(inv_sigma2_w);
sigma_z = 1/sqrt(inv_sigma2_z);
max1=abs(4*sqrt(1-rho^2)*R*[sigma_w; sigma_z]);
b_max1 = max1(1,1);
c_max1 = max1(2,1);
max2=abs(4*sqrt(1-rho^2)*R*[sigma_w; -sigma_z]);
b_max2 = max2(1,1);
c_max2 = max2(2,1);
b_max = max(b_max1, b_max2);
c_max = max(c_max1, c_max2);
end