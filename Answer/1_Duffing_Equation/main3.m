%% Reset
clear
close all

%% Input
mu = 1;
delta = 0.1;
alpha = -1/2;
ganma = 10;
omega = pi/3;

frame = 10;
tf = 100;
acc = 100;
N = 301;
beta = zeros(N,1);
tspan = linspace(0,tf,tf*acc+1);
x0 = [0;1];

x = zeros(tf*acc+1,2,N);
%% Solve ODE
for ii = 1:N
    beta(ii) = 0.01*(ii-1);
    [t,x(:,:,ii)] = ode45(@(t,x) Duffing(t,x,delta,alpha,beta(ii),ganma,omega),tspan,x0);
end

%% plot
f = figure;
f.WindowState = 'maximized';
set(0,"DefaultTextFontSize",30);
set(0,"DefaultAxesFontSize",30);
for ii = 1:N
    plot(x(:,1,ii),x(:,2,ii));
    axis([-15,15,-15,15]);
    daspect([1,1,1]);
    xlabel("x");
    ylabel("v");
    title("Duffing equation");
    text(10,13,"\beta="+num2str(beta(ii),3))
    drawnow;
    
    % 動画フレームのキャプチャ
    F(ii) = getframe(gcf);
end
writerObj = VideoWriter('Duffing_change_beta.avi');
writerObj.FrameRate = frame;
open(writerObj);
writeVideo(writerObj, F);
close(writerObj);

function dxdt = Duffing(t,x,delta,alpha,beta,ganma,omega)
dxdt = [x(2);
        -delta*x(2)-alpha*x(1)-beta*x(1)^3+ganma*cos(omega*t)];
end