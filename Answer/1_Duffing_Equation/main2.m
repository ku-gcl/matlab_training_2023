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

frame = 10;
tf = 100;
acc = 10;
playback_speed = 4;
N = tf*frame/playback_speed+1;
tspan = linspace(0,tf,tf*frame*acc+1);
x0 = [0,1];

%% Solve ODE
[t,x] = ode45(@(t,x) Duffing(t,x,delta,alpha,beta,ganma,omega),tspan,x0);

%% plot
f = figure;
f.WindowState = 'maximized';
set(0,"DefaultTextFontSize",30);
set(0,"DefaultAxesFontSize",30);
for i = 1:N
    ii = playback_speed*acc*(i-1)+1;
    plot(x(ii,1),x(ii,2),'o','MarkerSize',10,'Color','k');
    hold on;
    plot(x(1:ii,1),x(1:ii,2));
    axis([-4,4,-8,8]);
    daspect([1,1,1]);
    xlabel("x");
    ylabel("v");
    title("Duffing equation");
    text(0.5,6.5,"t="+num2str(t(ii),3)+"[s]")
    hold off;
    drawnow;
    
    % 動画フレームのキャプチャ
    F(i) = getframe(gcf);
end
writerObj = VideoWriter('Duffing.avi');
writerObj.FrameRate = frame;
open(writerObj);
writeVideo(writerObj, F);
close(writerObj);

function dxdt = Duffing(t,x,delta,alpha,beta,ganma,omega)
dxdt = [x(2);
        -delta*x(2)-alpha*x(1)-beta*x(1)^3+ganma*cos(omega*t)];
end