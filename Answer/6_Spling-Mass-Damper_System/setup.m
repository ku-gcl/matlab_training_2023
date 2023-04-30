%% Reset
clear
close

%% Input
m1 = 1;
m2 = 2;
k1 = 2;
k2 = 2;
c1 = 0.1;
c2 = 0.1;
x0 = [0.5;0;0;0];
t0 = 0;
tf = 10;
frame = 10;
Q = eye(4);
R = 1;
B = [0;0;1;1];

w1 = 0.8;
w2 = 0.8;
h1 = 0.4;
h2 = 0.4;
y01 = 2;
y02 = 1;
ceiling = 3;

%% Calculate
tnum = (tf-t0)*10+1;
tspan = linspace(0,tf,tnum);

A = [0,0,1,0;0,0,0,1;-(k1+k2)/m1,k2/m1,-(c1+c2)/m1,c2/m1;k2/m2,-k2/m2,c2/m2,-c2/m2];

%% make structure
Set.phy_m1 = m1;
Set.phy_m2 = m2;
Set.phy_k1 = k1;
Set.phy_k2 = k2;
Set.phy_c1 = c1;
Set.phy_c2 = c2;

Set.sim_x0 = x0;
Set.sim_t0 = t0;
Set.sim_tf = tf;
Set.sim_frame = frame;
Set.sim_tspan = tspan;

Set.LQR_A = A;
Set.LQR_B = B;
Set.LQR_Q = Q;
Set.LQR_R = R;

Set.ani_w1 = w1;
Set.ani_w2 = w2;
Set.ani_h1 = h1;
Set.ani_h2 = h2;
Set.ani_y01 = y01;
Set.ani_y02 = y02;
Set.ani_ceiling = ceiling;

%% Save
save("setup.mat","Set");