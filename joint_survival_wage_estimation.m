function [out] = joint_survival_wage_estimation(lW_r2010, y, ysm, idind, X, E, age, mig_age,year_fe, mig_risk, lambda, gamma1, rho_ab, sigma_b, ...
    rho_ac, rho_bc, sigma_a, sigma_c, sigma_e, beta_E, beta_x, beta_y, beta_year)
D = lW_r2010 - y * beta_y - gamma1 * ysm - year_fe*beta_year;

uids = unique(idind);

out = 0;
disp([rho_ab rho_bc rho_ac sigma_b gamma1 sigma_c]);
sigma_ab = rho_ab*sigma_a*sigma_b;
sigma_ac = rho_ac*sigma_a*sigma_c;
sigma_bc = rho_bc*sigma_b*sigma_c;
[bmax, cmax]=bc_bounds(sigma_b, sigma_c, sigma_bc/(sigma_b*sigma_c));
bmax = min(bmax, 0.5);
cmax = min(cmax, 2);
for j = 1:length(uids)
    i = uids(j);
    selected_rows_wage = find(idind==i & ~isnan(D));
    selected_rows_survival = find(idind==i & mig_risk==1);
    
    selected_age = age(selected_rows_survival);
    selected_mig_age = mig_age(selected_rows_survival);
    if (~any(selected_age==selected_mig_age))
        continue;
    end
    wage_func = wage_equation(D(selected_rows_wage), rho_ab, sigma_b, ...
        rho_ac, rho_bc, sigma_a, sigma_c, sigma_e, ysm(selected_rows_wage));
    
    prob_func = @(b,c)(prob_equation(b, c, sigma_b, sigma_c, rho_bc));
    
    survival_func = full_survival(X(selected_rows_survival,:), E(selected_rows_survival,:), age(selected_rows_survival), beta_E, beta_x, mig_age(selected_rows_survival), lambda);
    
    % likelihood_i = @(b, c)(survival_func(c) .* prob_func(b, c) .* wage_func(b, c));
    likelihood_i = @(b, c)(bc_dep(b, c, @(b,c)survival_func(c), prob_func, wage_func));
    likelihood_i_integral = integral2(likelihood_i, -bmax, bmax, -cmax, cmax);
    out = out + log(likelihood_i_integral);
%    log(likelihood_i_integral)
end
if out > -5000 && out < 0
    disp(out);
end
fprintf('jswe: %f\n', out);
end

function test_matrix(m, name)
if any(any(isnan(m)))
    fprintf([name 'nan\n']);
end
% if any(any(abs(m) == Inf))
%     fprintf([name 'inf\n']);
% end
if any(any(m < 0))
    fprintf([name 'neg\n']);
end
if any(any(~isreal(m)))
    fprintf([name 'imaginary\n']);
end
end

function out = bc_dep(b,c,f1,f2,f3)
    v1 = f1(b,c);
    v2 = f2(b,c);
    v3 = f3(b,c);
    
    %test_matrix(v1, 'f1');
    test_matrix(v2, 'f2');
    test_matrix(v3, 'f3');

    out=v1.*v2.*v3;
end


