function [beta_y, lambda] = estimation_guess(y, ysm, lwr)

  % Solve [y ysm]*[beta_y lambda]' = lwr;
  A=[y ysm];
  notnans = ~isnan(A);
  rows = all(notnans');
  x = A(rows,:)\lwr(rows);
  beta_y = x(1:end-1);
  lambda = beta_y(end);
end