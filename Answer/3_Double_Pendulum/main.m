%% Reset
clear
close

%% Input parameter
m1 = 1;
m2 = 1;
l1 = 1;
l2 = 1;
g = 9.80665;
tspan = linspace(0,30,300);
x0 = [0.5;2;0;0];

%% solve ODE
[t,x] = ode45(@(t,x) double_pendulum(t,x,m1,m2,l1,l2,g),tspan,x0);

%% plot
f = figure;
f.WindowState = 'maximized';
set(0,"DefaultTextFontSize",30);
set(0,"DefaultAxesFontSize",30);
for i = 1:length(t)
    X1 = l1*sin(x(i,1));
    Y1 = -l1*cos(x(i,1));
    X2 = X1+l2*sin(x(i,2));
    Y2 = Y1-l2*cos(x(i,2));
    plot(X1,Y1,'o','MarkerSize',50,'Color','k');
    hold on;
    plot(X2,Y2,'o','MarkerSize',50,'Color','k');
    plot([0,X1],[0,Y1],'k','LineWidth',2);
    plot([X1,X2],[Y1,Y2],'k','LineWidth',2);
    axis([-2.5,2.5,-2.5,0]);
    daspect([1,1,1]);
    xticks(-2.5:0.5:2.5);
    yticks(-2.5:0.5:0);
    xlabel("x [m]");
    ylabel("y [m]");
    title("Pendulum Motion");
    text(1.8,-0.2,"t="+num2str(t(i),3)+"[s]")
    hold off;
    drawnow;
    
    % 動画フレームのキャプチャ
    F(i) = getframe(gcf);
end

%% save
writerObj = VideoWriter('pendulum_motion.avi');
writerObj.FrameRate = 10;
open(writerObj);
writeVideo(writerObj, F);
close(writerObj);

function dxdt = double_pendulum(t,x,m1,m2,l1,l2,g)
M = m1+m2;
S = sin(x(1)-x(2));
C = cos(x(1)-x(2));
dxdt = [x(3);
        x(4);
        (m2*g*C*sin(x(2))-M*g*sin(x(1))-m2*l1*S*C*x(3)^2-m2*l2*S*x(4)^2)/(M*l1-m2*l1*C^2);
        (M*g*sin(x(2))-M*g*C*sin(x(1))-M*l1*S*x(3)^2-m2*l2*S*C*x(4)^2)/(m2*l2*C^2-M*l2)];
end