% This function calculates the fully parametric survival model for one
% individual with baseline hazard assumed to follow exponential(constant
% with respect to time).

function func = full_survival(X, E, age, beta_E, beta_x, mig_age, lambda)   

mig_row = find(age == mig_age); 
h_t = lambda0(age(1:mig_row), lambda).*exp(X(1:mig_row,:)*beta_x + E(1:mig_row,:)*beta_E);
% g_t is the hazard function which is calculated for all ages up till
% migration age
func = @(c) c_dep(c, h_t(end), sum(h_t(1:end-1)));
% g_t(end) is the hazard function for only migration age.
end


% This function defines the exponential baseline hazard lambda
function l = lambda0(age, lambda)
  %% Takes a vector and returns a vector of the same size.
  %% Can use a spline here later
  l = lambda*ones(size(age));
end

function out = c_dep(c, hT, SumGt)
    out = hT * exp(c - SumGt*exp(c));
end