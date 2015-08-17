clear
load('rlms.mat');
X = [asjpdist_avg bir_urban female russian_ethn schol];
E = [asia cnl contig csto disso europe f10gdpdif fdd frreligion ... 
    gdpdif ldist lmepvany lmoru5 lrecess lurbper];
y = [asjpdist_avg female fysm married russian_ethn schadj work_exp ysm2 ldysm1];

beta_x =[-.4, .2, -.05, -.03, .4]'; 
beta_E= [.1, .2, .4, .2, .6, .1, .25, -.15, -.05, .32, -.25, .12, .1, .07, .09]';
beta_y= [-.2, .25, -.1, .02, .15, .4, .2, -.09, -.1]';
gamma1 = .42;
sigma_ab = .35;
sigma_b = 1;
sigma_c = 1;
sigma_ac = .5;
sigma_bc = .45;
sigma_a = 2;
sigma_e = .75;
lambda = 2.25;

out = joint_survival_wage_estimation(lw_r, y, ysm, idind, X, E, age, mig_age, beta_y, gamma1, sigma_ab, sigma_b, ...
    sigma_ac, sigma_bc, sigma_a, sigma_c, sigma_e, beta_E, beta_x, lambda);

