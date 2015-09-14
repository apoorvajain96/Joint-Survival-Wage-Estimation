load('rlms.mat');
X = [asjpdist_avg bir_urban female russian_ethn schol];
E = [asia cnl contig csto disso europe f10gdpdif fdd frreligion ... 
    gdpdif ldist lmepvany lmoru5 lrecess lurbper];
y = [asjpdist_avg female fysm married russian_ethn schadj work_exp ysm2 ldysm1];

beta_x =[-.4, -.014, .13, -.24, .001]'; 
beta_E= [.01, .011, 1.54, .02, .16, .01, .013, .005, -.45, .013, -.035, .012, -.001, -.007, -.001]';
%beta_y= [.291, -.7, .015, .01, -.024, .064, .002, -.0001, -.004]';
%gamma1 = .037;
sigma_ab = .4;
sigma_b = 1;
sigma_c = 1;
sigma_ac = .5;
sigma_bc = .45;
sigma_a = 2;
sigma_e = .75;
%lambda = 2.25;
[beta_y, gamma1] = estimation_guess(y, ysm, lw_r);
lambda = 0.1;
%out = joint_survival_wage_estimation(lw_r, y, ysm, idind, X, E, age, mig_age, lambda, gamma1, sigma_ab, sigma_b, ...
%    sigma_ac, sigma_bc, sigma_a, sigma_c, sigma_e, beta_E, beta_x, beta_y);

guess_param = [lambda; gamma1; sigma_ab; sigma_b; ...
    sigma_ac; sigma_bc; sigma_a; sigma_c; sigma_e; beta_E; beta_x; beta_y];

%func = overall_joint_estimation_cost_function(lw_r, y, ysm, idind, X, E, age, mig_age);

[p fval history2] = joint(guess_param, lw_r, y, ysm, idind, X, E, age, mig_age)



