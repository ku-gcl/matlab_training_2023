%% Reset
clear
close all

%% Input parameter
p = 10;
r = 28;
b = 8/3;
t0 = 0;
tf = 100;

tspan = [t0,tf];
x0 = [1;1;0];

%% Solve ODE
[t,x] = ode45(@(t,x) lorenz(t,x,p,r,b),tspan,x0);

%% plot
f = figure;
f.WindowState = 'maximized';
set(0,"DefaultTextFontSize",30);
set(0,"DefaultAxesFontSize",30);
plot(t,x)
legend("x","y","z")
xlabel("time t[s]")
ylabel("state")
savefig("time_history")
exportgraphics(gcf,"time_history.png","Resolution",220)

function dxdt = lorenz(t,x,p,r,b)
dxdt = [-p*x(1)+p*x(2);
        -x(1)*x(3)+r*x(1)-x(2);
        x(1)*x(2)-b*x(3)];
end