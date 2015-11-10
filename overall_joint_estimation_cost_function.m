function func = overall_joint_estimation_cost_function(lw_r2010, y, ysm, idind, X, E, age, mig_age, year_fe, mig_risk)
% This function creates the overall cost function to be minimized by
% fmisearch

% Now we tell the program what position in the columns of the parameters
% correspond to what parameters in the physical sense

lambda1 = 1;
gamma1 = 2;
rho_ab = 3;
sigma_b = 4;
rho_ac = 5;
rho_bc = 6;
sigma_a = 7;
sigma_c = 8;
sigma_e = 9;
beta_E = 9 + (1:size(E,2));
beta_x = 9 + size(E,2) + (1:size(X,2));
beta_y = 9 + size(E,2) + size(X,2) + (1:size(y,2));
beta_year = 9 + size(E,2) + size(X,2) + size(y,2) + (1:size(year_fe,2));
lambda234 = 9 + size(E,2) + size(X,2) + size(y,2) + (size(year_fe,2)) + 1;
lambda = [lambda1 lambda234];
func = @(p)(-joint_survival_wage_estimation(lw_r2010, y, ysm, idind, X, E, age, mig_age, year_fe, mig_risk, p(lambda), p(gamma1), p(rho_ab),...
    p(sigma_b), p(rho_ac), p(rho_bc), p(sigma_a), p(sigma_c), p(sigma_e), p(beta_E), p(beta_x), p(beta_y), p(beta_year)));
end
