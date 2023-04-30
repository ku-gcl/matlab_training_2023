%% Reset
clear
close all

%% Input data
load("setup.mat");
l = Set.phy_l;
h = 1;
v = 0.5;

A = Set.LQR_A;
B = Set.LQR_B;
Q = Set.LQR_Q;
R = Set.LQR_R;

x0 = Set.sim_x0;
tspan = Set.sim_tspan;
frame = Set.sim_frame;

%% Solve LQR
[K,~,~] = lqr(A,B,Q,R);

%% Solve ODE
[tl,xl] = ode45(@(t,x) LSCIP(t,x,A,B,K),tspan,x0);
[t,x] = ode45(@(t,x) SCIP(t,x,Set,K),tspan,x0);

%% plot
% plot linear control history
f1 = figure;
f1.WindowState = 'maximized';
set(0,"DefaultTextFontSize",30);
set(0,"DefaultAxesFontSize",30);
plot(tl,xl)
legend("x","\theta","dx/dt","d\theta/dt")
xlabel("time t[s]")
ylabel("state")
savefig("linear")
exportgraphics(gcf,"linear.png","Resolution",220)

% plot nonlinear control history
f2 = figure;
f2.WindowState = 'maximized';
plot(t,x)
legend("x","\theta","dx/dt","d\theta/dt")
xlabel("time t[s]")
ylabel("state")
savefig("nonlinear")
exportgraphics(gcf,"nonlinear.png","Resolution",220)

% make animation
f3 = figure;
f3.WindowState = 'maximized';
set(0,"DefaultTextFontSize",30);
set(0,"DefaultAxesFontSize",30);
for i = 1:length(t)
    X1 = x(i,1);
    Y1 = v/2;
    X2 = X1+l*sin(x(i,2));
    Y2 = Y1+l*cos(x(i,2));
    plotrectangle(X1,Y1,h,v);
    hold on;
    plot([X1,X2],[Y1,Y2],'k','LineWidth',2);
    axis([-3,1,0,1.5]);
    daspect([1,1,1]);
    xlabel("x [m]");
    ylabel("y [m]");
    title("Inverted Pendulum Motion");
    text(0.5,1.4,"t="+num2str(t(i),3)+"[s]")
    hold off;
    drawnow;

    % 動画フレームのキャプチャ
    F(i) = getframe(gcf);
end

%% save
writerObj = VideoWriter('result.avi');
writerObj.FrameRate = frame;
open(writerObj);
writeVideo(writerObj, F);
close(writerObj);

%% function
function dxdt = LSCIP(t,x,A,B,K)
dxdt = A*x-B*K*x;
end

function dxdt = SCIP(t,x,Set,K)
M = Set.phy_M;
m = Set.phy_m;
l = Set.phy_l;
k = Set.phy_k;
g = Set.phy_g;

den = M+(1-cos(x(2))^2)*m;
num1 = m*g*sin(x(2))*cos(x(2))-m*l*x(4)^2*sin(x(2))-k*x(1)-K*x;
num2 = (M+m)*g*sin(x(2))-m*l*x(4)^2*sin(x(2))*cos(x(2))-k*x(1)*cos(x(2))-K*x;
dxdt = [x(3);x(4);num1/den;num2/(den*l)];
end