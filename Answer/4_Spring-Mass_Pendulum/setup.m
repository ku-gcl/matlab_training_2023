%% Reset
clear
close

%% Input
% parameter
M = 2;
m = 0.1;
l = 1;
k = 1;
g = 9.80665;

% simulate
x0 = [1.5;0.5;0;0];
t0 = 0;
tf = 20;
frame = 10;

% LQR
Q = eye(4);
R = 1;

%% Calculate
% simulate
tspan = linspace(t0,tf,(tf-t0)*frame+1);

% LQR
A = [0,0,1,0;0,0,0,1;-k/M,m*g/M,0,0;-k/(M*l),(M+m)*g/(M*l),0,0];
B = [0;0;1/M;1/(M*l)];

%% make structure
% Physics
Set.phy_M = M;
Set.phy_m = m;
Set.phy_l = l;
Set.phy_k = k;
Set.phy_g = g;

% Simulate
Set.sim_x0 = x0;
Set.sim_t0 = t0;
Set.sim_tf = tf;
Set.sim_frame = frame;
Set.sim_tspan = tspan;

% LQR
Set.LQR_A = A;
Set.LQR_B = B;
Set.LQR_Q = Q;
Set.LQR_R = R;

%% Save
save("setup.mat","Set");