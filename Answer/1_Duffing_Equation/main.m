%% Reset
clear
close all

%% Input
mu = 1;
delta = 0.1;
alpha = -1/2;
beta = 2;
ganma = 10;
omega = pi/3;
tspan = [0,100];
x0 = [0,1];

%% Solve ODE
[t,x] = ode45(@(t,x) Duffing(t,x,delta,alpha,beta,ganma,omega),tspan,x0);

%% plot
f = figure;
f.WindowState = 'maximized';
set(0,"DefaultTextFontSize",30);
set(0,"DefaultAxesFontSize",30);
plot(t,x)
legend("x","v")
xlabel("time t[s]")
ylabel("state")
savefig("time_history")
exportgraphics(gcf,"time_history.png","Resolution",220)

function dxdt = Duffing(t,x,delta,alpha,beta,ganma,omega)
dxdt = [x(2);
        -delta*x(2)-alpha*x(1)-beta*x(1)^3+ganma*cos(omega*t)];
end