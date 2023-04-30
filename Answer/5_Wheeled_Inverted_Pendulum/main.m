%% Reset
clear
close

%% Input parameter
load("setup.mat");
r = Set.phy_r;
l = Set.phy_l;

A = Set.LQR_A;
B = Set.LQR_B;
Q = Set.LQR_Q;
R = Set.LQR_R;

x0 = Set.sim_x0;
tspan = Set.sim_tspan;
frame = Set.sim_frame;

%% Solve LQR;
[K,~,~] = lqr(A,B,Q,R);

%% Solve ODE
[tl,xl] = ode45(@(t,x) linered_inverted_pendulum(t,x,A,B,K),tspan,x0);
[t,x] = ode45(@(t,x) inverted_pendulum(t,x,Set,K),tspan,x0);

%% plot
% plot linear control history
f1 = figure;
f1.WindowState = 'maximized';
set(0,"DefaultTextFontSize",30);
set(0,"DefaultAxesFontSize",30);
plot(tl,xl)
legend("\theta","\phi","d\theta/dt","d\phi/dt")
xlabel("time t[s]")
ylabel("state")
savefig("linear")
exportgraphics(gcf,"linear.png","Resolution",220)

% plot nonlinear control history
f2 = figure;
f2.WindowState = 'maximized';
plot(t,x)
legend("\theta","\phi","d\theta/dt","d\phi/dt")
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
    X1 = r*x(i,2);
    Y1 = r;
    X2 = X1+l*sin(x(i,1));
    Y2 = Y1+l*cos(x(i,1));
    plotcircle(X1,Y1,r);
    hold on;
    plot([X1,X2],[Y1,Y2],"Color","k","LineWidth",2)
    axis([-1,7,0,3]);
    daspect([1,1,1]);
    xlabel("x [m]");
    ylabel("y [m]");
    title("Inverted Pendulum Motion");
    text(6,2.5,"t="+num2str(t(i),3)+"[s]")
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

function dxdt = linered_inverted_pendulum(t,x,A,B,K)
dxdt = (A-B*K)*x;
end

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