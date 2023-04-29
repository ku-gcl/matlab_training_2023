%% Reset
clear
close

%% Input parameter
m1 = 1;
m2 = 1;
l1 = 1;
l2 = 1;
g = 9.80665;
N = 100;
epsilon = 1E-4;
tf = 30;
flame = 10;

tspan = linspace(0,tf,tf*flame);
x0 = [0.5;2;0;0];
x = zeros(tf*flame,4,N);
Color = varycolor(N);

%% solve ODE
for ii = 1:N
    [t,x(:,:,ii)] = ode45(@(t,x) double_pendulum(t,x,m1,m2,l1,l2,g),tspan,x0);
    x0(2) = x0(2)+epsilon;
end

%% plot
f = figure;
f.WindowState = 'maximized';
set(0,"DefaultTextFontSize",30);
set(0,"DefaultAxesFontSize",30);
for i = 1:length(t)
    X1 = l1*sin(x(i,1,:));
    Y1 = -l1*cos(x(i,1,:));
    X2 = X1+l2*sin(x(i,2,:));
    Y2 = Y1-l2*cos(x(i,2,:));
    for ii = 1:N
        plot(X1(ii),Y1(ii),'o','MarkerSize',50,'Color',Color(ii,:));
        if ii ==1
            hold on
        end
        plot(X2(ii),Y2(ii),'o','MarkerSize',50,'Color',Color(ii,:));
        plot([0,X1(ii)],[0,Y1(ii)],'Color',Color(ii,:),'LineWidth',2);
        plot([X1(ii),X2(ii)],[Y1(ii),Y2(ii)],'Color',Color(ii,:),'LineWidth',2);
    end
    axis([-2.5,2.5,-2.5,0]);
    daspect([1,1,1]);
    xticks(-2.5:0.5:2.5);
    yticks(-2.5:0.5:0);
    xlabel("x [m]");
    ylabel("y [m]");
    title("Pendulum Motion");
    text(1.8,-0.2,"t="+num2str(t(i),3)+"[s]")
    hold off
    drawnow;
    
    % 動画フレームのキャプチャ
    F(i) = getframe(gcf);
end

%% save
writerObj = VideoWriter('100_pendulums_motion.avi');
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