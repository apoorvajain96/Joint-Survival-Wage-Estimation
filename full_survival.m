function func = full_survival(X, E, age, beta_E, beta_x, mig_age, lambda)
%% This function calculates the fully parametric survival model for one individual.
%% The value of bh (baseline hazard contributions) is computed from stata command sts generate newvar=h

mig_row = find(age == mig_age); 
g_t = lambda0(age(1:mig_row), lambda).*exp(X(1:mig_row,:)*beta_x + E(1:mig_row,:)*beta_E);

func = @(c) c_dep(c, g_t(end), exp(sum(g_t(1:end-1))));

end


function l = lambda0(age, lambda)
  %% Takes a vector and returns a vector of the same size.
  %% Can use a spline here later
  l = lambda*ones(size(age));
end

function out = c_dep(c, gT, expSumGt)
    out = gT * exp(c - expSumGt*exp(c));
end