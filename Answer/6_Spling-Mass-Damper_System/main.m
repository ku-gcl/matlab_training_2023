%% Reset
clear
close

%% Input
load("setup.mat");

x0 = Set.sim_x0;
tspan = Set.sim_tspan;
A = Set.LQR_A;
B = Set.LQR_B;
Q = Set.LQR_Q;
R = Set.LQR_R;

%% Solve LQR
[K,~,~] = lqr(A,B,Q,R);

%% Solve ODE
[t,x] = ode45(@(t,x) SMDS(t,x,A,B,K),tspan,x0);

f = figure;
f.WindowState = 'maximized';
set(0,"DefaultTextFontSize",30);
set(0,"DefaultAxesFontSize",30);
plot(t,x);
xlabel("time t")
ylabel("state x")
legend("x_1","x_2","v_1","v_2")

%% Save
savefig("time_history.fig")
exportgraphics(gcf,"time_history.png","Resolution",220)

%% Function
function dxdt = SMDS(t,x,A,B,K)
dxdt = A*x-B*K*x;
end