% % This file first seperates C1E2F expression into wage equation(independent of b and c) and bc_dep.
% Wage equation produces 'func' which is a function of bc_dep rather defines a function which uses bc_dep.
% This function is finally executed in file joint_survival_wage_estimation
% where wage_func is called.
% Function bc_dep produces 'out' (C1E2f expression)
% in bc_dep we change the D_s function to operate with vectors of b rather
% than scalars because integral2 sends arrays/matrix of b, not scalars.
function func = wage_equation(D, rho_ab, sigma_b, rho_ac, rho_bc,...
    sigma_a, sigma_c, sigma_e, ysm)
sigma_ab = rho_ab*sigma_a*sigma_b;
sigma_ac = rho_ac*sigma_a*sigma_c;
sigma_bc = rho_bc*sigma_b*sigma_c;
sigma11_sigma22_inv =[sigma_ab sigma_ac]/[sigma_b^2 sigma_bc; sigma_bc sigma_c^2]; % coeffs of b&c in mu_a_bc
sigma2_a_bc = (sigma_a).^2 - sigma11_sigma22_inv*[sigma_ab; sigma_ac];
S = length(ysm);
C_coeff_inv = (sqrt(2*pi)*sigma_e)^S * sqrt(2 * pi * sigma2_a_bc);
func = @(b, c)(bc_dep_vec(b, c, D, ysm, sigma11_sigma22_inv(1), sigma11_sigma22_inv(2), sigma2_a_bc, ...
    1/C_coeff_inv, sigma_e, S));
end

function row = mat2row(mat)
    row = mat(:)';  % stack all columns in the matrix in 1 column and then transpose it for row
end

function mat = row2mat(row, sz)
    mat = reshape(row', sz);
end

function out_mat = bc_dep(bmat, cmat, D, ysm, mu_a_bc_b, mu_a_bc_c, sigma2_a_bc, ...
    C_coeff, sigma_e, S)
%b = mat2row(bmat);
%c = mat2row(cmat);
out_mat = zeros(size(bmat));
for i = 1:size(bmat, 1)
    for j = 1:size(bmat, 2)
        b=bmat(i,j);
        c=cmat(i,j);
        D_s = D*ones(size(b)) - ysm*b;
        mu_a_bc = mu_a_bc_b*b + mu_a_bc_c*c;
        C_exp = sum(D_s.^2)/(2*sigma_e^2) + (mu_a_bc.^2)/(2*sigma2_a_bc);
        
        E = sum(D_s)/(sigma_e^2) + mu_a_bc/sigma2_a_bc;
        F = S/(sigma_e^2) + 1/(sigma2_a_bc);
        
        exp_val = (E.^2)./(2*F) - C_exp;
        out = C_coeff.* exp(exp_val) .* sqrt(2*pi./F);
        out_mat(i,j) = out;
    end
end
%out_mat = row2mat(out, size(bmat));

end

function out_mat = bc_dep_vec(bmat, cmat, D, ysm, mu_a_bc_b, mu_a_bc_c, sigma2_a_bc, ...
    C_coeff, sigma_e, S)
% check = bc_dep(bmat, cmat, D, ysm, mu_a_bc_b, mu_a_bc_c, sigma2_a_bc, C_coeff, sigma_e, S);
b = mat2row(bmat);
c = mat2row(cmat);
D_s = D*ones(size(b)) - ysm*b;
mu_a_bc = mu_a_bc_b*b + mu_a_bc_c*c;
C_exp = sum(D_s.^2, 1)/(2*sigma_e^2) + (mu_a_bc.^2)/(2*sigma2_a_bc);

E = sum(D_s, 1)/(sigma_e^2) + mu_a_bc/sigma2_a_bc;
F = S/(sigma_e^2) + 1/(sigma2_a_bc);

exp_val = (E.^2)./(2*F) - C_exp;
out = C_coeff.* exp(exp_val) .* sqrt(2*pi./F);
out_mat = row2mat(out, size(bmat));
% err = check-out_mat;
% tot_err = sum(sum(err.^2));
% if tot_err > 0.0001
%     fprintf('%f\n', tot_err);
% end
end