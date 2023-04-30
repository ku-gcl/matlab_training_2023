%% Reset
clear
close

%% Input
load("setup.mat");

m1 = Set.phy_m1;
m2 = Set.phy_m2;
k1 = Set.phy_k1;
k2 = Set.phy_k2;
g = 0;

x0 = Set.sim_x0;
tspan = Set.sim_tspan;
A = Set.LQR_A;
B = Set.LQR_B;
Q = Set.LQR_Q;
R = Set.LQR_R;

y01 = Set.ani_y01;
y02 = Set.ani_y02;
ceiling = Set.ani_ceiling;

%% Solve LQR
[K,~,~] = lqr(A,B,Q,R);

%% Solve ODE
[t,x] = ode45(@(t,x) SMDS(t,x,A,B,K),tspan,x0);

E = nan(length(t),9);
for ii = 1:length(t)
    E(ii,1) = 0.5*m1*x(ii,3)^2; %T1
    E(ii,2) = 0.5*m2*x(ii,4)^2; %T2
    E(ii,3) = m1*g*(y01+x(ii,1))+0.5*k1*x(ii,1)^2; %U1
    E(ii,4) = m2*g*(y02+x(ii,2))+0.5*k2*x(ii,2)^2; %U2
    E(ii,5) = E(ii,1)+E(ii,3); %H1
    E(ii,6) = E(ii,2)+E(ii,4); %H2
    E(ii,7) = E(ii,1)+E(ii,2); %T
    E(ii,8) = E(ii,3)+E(ii,4); %U
    E(ii,9) = E(ii,5)+E(ii,6); %H
end

f = figure;
f.WindowState = 'maximized';
set(0,"DefaultTextFontSize",30);
set(0,"DefaultAxesFontSize",30);
plot(t,E(:,9));
xlabel("time t[s]")
ylabel("Energy E[J]")
% legend("Energy")

%% Save
savefig("energy.fig")
exportgraphics(gcf,"energy.png","Resolution",220)

%% Function
function dxdt = SMDS(t,x,A,B,K)
dxdt = A*x-B*K*x;
end