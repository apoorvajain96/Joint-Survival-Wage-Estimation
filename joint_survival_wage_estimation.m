function [out] = joint_survival_wage_estimation(lW_r, y, ysm, idind, X, E, age, mig_age, lambda, gamma1, sigma_ab, sigma_b, ...
    sigma_ac, sigma_bc, sigma_a, sigma_c, sigma_e, beta_E, beta_x, beta_y)
D = lW_r - y * beta_y - gamma1 * ysm;

uids = unique(idind);

out = 0;
[bmax, cmax]=bc_bounds(sigma_b, sigma_c, sigma_bc/(sigma_b*sigma_c));
for j = 1:length(uids)
    i = uids(j);
    selected_rows_wage = find(idind==i & ~isnan(D));
    wage_func = wage_equation(D(selected_rows_wage), sigma_ab, sigma_b, ...
        sigma_ac, sigma_bc, sigma_a, sigma_c, sigma_e, ysm(selected_rows_wage));
    
    prob_func = @(b,c)(prob_equation(b, c, sigma_b, sigma_c, sigma_bc/(sigma_b*sigma_c)));
    
    survival_func = full_survival(X, E, age, beta_E, beta_x, mig_age, lambda);
    
    % likelihood_i = @(b, c)(survival_func(c) .* prob_func(b, c) .* wage_func(b, c));
    likelihood_i = @(b, c)(bc_dep(b, c, @(b,c)survival_func(c), prob_func, wage_func));
    likelihood_i_integral = integral2(likelihood_i, -bmax, bmax, -cmax, cmax);
    out = out + log(likelihood_i_integral);
%    log(likelihood_i_integral)
end
fprintf('%f\n', out);
end

function test_matrix(m, name)
    if any(any(isnan(m)))
        fprintf([name 'nan\n']);
    end
    if any(any(abs(m) == Inf))
        fprintf([name 'inf\n']);
    end
%     if any(any(m < 0))
%         fprintf([name 'neg\n']);
%     end
end

function out = bc_dep(b,c,f1,f2,f3)
    v1 = f1(b,c);
    v2 = f2(b,c);
    v3 = f3(b,c);
    
    test_matrix(v1, 'f1');
    test_matrix(v2, 'f2');
    test_matrix(v3, 'f3');

    out=v1.*v2.*v3;
end


