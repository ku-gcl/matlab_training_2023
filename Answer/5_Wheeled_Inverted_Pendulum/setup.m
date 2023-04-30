%% Reset
clear
close

%% Input parameter
mw = 2;
mb = 3;
r = 0.5;
l = 2;
Jw = 0.25;
Jb = 1;
D = 0.0001;
alpha = 0.1;
g = 9.80655;

x0 = [1;0;0;0];
t0 = 0;
tf = 20;
frame = 10;

% LQR
Q = eye(4);
R = 1;

%% Calculate parameter
d1 = (mw+mb)*r^2+Jw;
d2 = d1+mb*l*r;
d3 = d1+2*mb*l*r+mb*l^2+Jb;
den = d2^2-d1*d3;

A = [0,0,1,0;
     0,0,0,1;
     -d1*mb*g*l/den,0,0,-d2*D/den;
     d2*mb*g*l/den,0,0,d3*D/den];
B = [0;0;d2*alpha/den;-d3*alpha/den];

tspan = linspace(t0,tf,(tf-t0)*frame+1);

%% make structure
% Physics
Set.phy_mw = mw;
Set.phy_mb = mb;
Set.phy_r = r;
Set.phy_l = l;
Set.phy_Jw = Jw;
Set.phy_Jb = Jb;
Set.phy_D = D;
Set.phy_alpha = alpha;
Set.phy_g = g;
Set.phy_d1 = d1;
Set.phy_d2 = d2;
Set.phy_d3 = d3;
Set.phy_den = den;

% Simulate
Set.sim_x0 = x0;
Set.sim_t0 = t0;
Set.sim_tf = tf;
Set.sim_tspan = tspan;
Set.sim_frame = frame;

% LQR
Set.LQR_A = A;
Set.LQR_B = B;
Set.LQR_Q = Q;
Set.LQR_R = R;

%% Save
save("setup.mat","Set");