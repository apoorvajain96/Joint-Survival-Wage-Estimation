warning('off','all')
warning
load('rlms_new.mat');
X = [asjp_n city town female russian_ethn schol];
E = [cnl contig csto disso europe f10gdpdif fdd frethnic... 
    gdpdif ldist lmepvany lmoru5 lrecess lurbper];
%y = [asjp_n female fysm married russian_ethn schadj work_exp ysm2 ldysm];
year_fe = [Isyear_1995 Isyear_1996 Isyear_1998 Isyear_2000 Isyear_2001 Isyear_2002 Isyear_2003 Isyear_2004 Isyear_2005 Isyear_2006 Isyear_2007 Isyear_2008 Isyear_2009 Isyear_2010 Isyear_2011];
y = [asjp_n female married russian_ethn schadj age ldysm2];

% beta_x =[-.4, -.014, .13, -.24, .001]'; 
% beta_E= [.011, 1.54, .02, .16, .01, .013, .005, -.45, .013, -.035, .012, -.001, -.007, -.001]';
% beta_year = [];
% beta_y= [.291, -.7, .015, .01, -.024, .064, .002, -.0001, -.004]';
% gamma1 = .037;
% sigma_ab = .4;
% %sigma_b = 1;
% %sigma_b = .35;
% sigma_b = .65;
% %sigma_c = 1;
% %sigma_c = .54;
% sigma_c = .24;
% sigma_ac = .5;
% %sigma_bc = .45;
% %sigma_bc = .78;
% sigma_bc = -.78;
% sigma_a = 2;
% sigma_e = .75;
% %lambda = 2.25;
% %[beta_y, gamma1] = estimation_guess(y, ysm, lw_r);
% lambda = 0.1;



%% New 
beta_x =[-1.103, -.002, .14, .188, -.716, .063 ]'; 
beta_E= [-.63, 3.59, .74, .22, -.018, .324, .019, -1.29, .070, .516, .091, -.016, .261, .002]';
beta_year = [-.336, -.339, -.635, -0.856, -.571, -.422, -.279, -.160, -0.089, .073, .197, .335, .354, .367, .384]';
beta_y= [-.108, -.396, .061, -.462, .054, .021, -.0022]';
gamma1 = .021;
rho_ab = 0.01;%-.798;
%sigma_b = 1;
%sigma_b = .35;
sigma_b = .0325;
%sigma_c = 1;
%sigma_c = .54;
sigma_c = .24;
rho_ac = 0.01;%.5;
%sigma_bc = .45;
%sigma_bc = .78;
%rho_bc = .78;
rho_bc = 0.01;
sigma_a = .7272;
sigma_e = .411;
%lambda = 2.25;
%[beta_y, gamma1] = estimation_guess(y, ysm, lw_r);
lambda1 = 0.1;
lambda234 = 0.01/10000;

%out = joint_survival_wage_estimation(lw_r2010, y, ysm, idind, X, E, age, mig_age, lambda, gamma1, sigma_ab, sigma_b, ...
%    sigma_ac, sigma_bc, sigma_a, sigma_c, sigma_e, beta_E, beta_x, beta_y);

% guess_param = [lambda; gamma1; sigma_ab; sigma_b; ...
%     sigma_ac; sigma_bc; sigma_a; sigma_c; sigma_e; beta_E; beta_x; beta_y; beta_year];

guess_param = 0.9*[lambda1; gamma1; rho_ab; sigma_b; ...
    rho_ac; rho_bc; sigma_a; sigma_c; sigma_e; beta_E; beta_x; beta_y; beta_year; lambda234'];

guess_param = [0.0891
    0.0188
    0.0090
    0.0293
    0.0090
    0.0090
    0.6544
    0.2160
    0.3700
   -0.5670
    3.2310
    0.6660
    0.1980
   -0.0162
    0.2916
    0.0171
   -1.1610
    0.0630
    0.4644
    0.0819
   -0.0144
    0.2349
    0.0018
   -0.9927
   -0.0018
    0.1260
    0.1692
   -0.6444
    0.0565
   -0.0972
   -0.3564
    0.0549
   -0.4158
    0.0487
    0.0190
   -0.0020
   -0.3024
   -0.3051
   -0.5715
   -0.7704
   -0.5139
   -0.3798
   -0.2511
   -0.1440
   -0.0801
    0.0657
    0.1773
    0.3015
    0.3186
    0.3303
    0.3456
   0.0003];

% func = overall_joint_estimation_cost_function(lw_r, y, ysm, idind, X, E, age, mig_age);
lb = -inf*ones(size(guess_param));
lb([3 5 6]) = -0.9;
lb([4 7 8 9]) = 0;
ub =-1*lb;
ub([4 7 8 9]) = 1;
lb([1 end]) = 0;

 load('p_8_11_12am.mat');
guess_param = p;
[p fval history] = joint1(guess_param, lw_r2010, y, ysm, idind, X, E, age, mig_age, year_fe, mig_risk, lb, ub);




