%% Reset
clear
close

%% Input parameter
load("setup.mat");
r = Set.phy_r;

A = Set.LQR_A;
B = Set.LQR_B;
Q = Set.LQR_Q;
R = Set.LQR_R;

x0 = Set.sim_x0;
tspan = Set.sim_tspan;

%% Solve LQR;
[K,~,~] = lqr(A,B,Q,R);

%% Solve ODE
[t,x2] = ode45(@(t,x) inverted_pendulum(t,x,Set,K),tspan,x0);

%% plot
f = figure;
set(0,"DefaultTextFontSize",30);
set(0,"DefaultAxesFontSize",30);
plot(t,x2(:,1),t,x2(:,2)*r,t,x2(:,3),t,x2(:,4)*r);
legend("\theta","x","d\theta/dt","dx/dt")

%% save
savefig("result.fig");

%% function
function dxdt = inverted_pendulum(t,x,Set,K)
mb = Set.phy_mb;
r = Set.phy_r;
l = Set.phy_l;
Jw = Set.phy_Jw;
D = Set.phy_D;
alpha = Set.phy_alpha;
g = Set.phy_g;

d1 = Set.phy_d1;
d2 = d1+mb*l*r*cos(x(1));
d3 = d1+2*mb*l*r*cos(x(1))+mb*l^2+Jw;
den = d2^2-d1*d3;
num1 = (D*x(4)-mb*l*r*sin(x(1))*x(3)^2-alpha*K*x)*d3+(mb*l*r*sin(x(1))*x(3)^2+mb*g*l*sin(x(1)))*d2;
num2 = (D*x(4)-mb*l*r*sin(x(1))*x(3)^2-alpha*K*x)*d2+(mb*l*r*sin(x(1))*x(3)^2+mb*g*l*sin(x(1)))*d1;

dxdt = [x(3);x(4);num1/den;-num2/den];
end