%% Reset
clear
close all
set(0,"DefaultTextFontSize",30);
set(0,"DefaultAxesFontSize",30);

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
% xy plane
f1 = figure;
f1.WindowState = 'maximized';
plot(x(:,1),x(:,2))
xlabel("x")
ylabel("y")
savefig("xy")
exportgraphics(gcf,"xy.png","Resolution",220)

% yz plane
f2 = figure;
f2.WindowState = 'maximized';
plot(x(:,2),x(:,3))
xlabel("y")
ylabel("z")
savefig("yz")
exportgraphics(gcf,"yz.png","Resolution",220)

% zx plane
f3 = figure;
f3.WindowState = 'maximized';
plot(x(:,1),x(:,3))
xlabel("x")
ylabel("z")
savefig("zx")
exportgraphics(gcf,"zx.png","Resolution",220)

function dxdt = lorenz(t,x,p,r,b)
dxdt = [-p*x(1)+p*x(2);
        -x(1)*x(3)+r*x(1)-x(2);
        x(1)*x(2)-b*x(3)];
end