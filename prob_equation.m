% This function defines the joint bivariate normal distribution of b_i and
% c_i.
function val = prob_equation(b, c, sigma_b, sigma_c, rho_bc)
val = 1/(2*pi*sigma_b*sigma_c*sqrt(1-rho_bc^2))*exp(-(b.^2/(sigma_b^2) ...
    - 2*rho_bc*b.*c/(sigma_b*sigma_c) + c.^2/(sigma_c^2))/(2*(1-rho_bc^2)));
end