%% Reset
clear
close

%% Input parameter
p = 10;
r = 28;
b = 8/3;

frame = 10;
tf = 100;
acc = 10;
playback_speed = 4;
N = tf*frame/playback_speed+1;
tspan = linspace(0,tf,tf*frame*acc+1);
x0 = [1;1;0];

%% Solve ODE
[t,x] = ode45(@(t,x) lorenz(t,x,p,r,b),tspan,x0);

%% plot
f = figure;
f.WindowState = 'maximized';
set(0,"DefaultTextFontSize",30);
set(0,"DefaultAxesFontSize",30);
for i = 1:N
    ii = playback_speed*acc*(i-1)+1;
    plot3(x(ii,1),x(ii,2),x(ii,3),'o','MarkerSize',10,'Color','k');
    hold on;
    plot3(x(1:ii,1),x(1:ii,2),x(1:ii,3));
    axis([-20,50,-20,50,-20,50]);
    daspect([1,1,1]);
    xlabel("x");
    ylabel("y");
    zlabel("z");
    title("Duffing equation");
    text(20,0,40,"t="+num2str(t(ii),3)+"[s]")
    hold off;
    drawnow;
    
    % 動画フレームのキャプチャ
    F(i) = getframe(gcf);
end
writerObj = VideoWriter('Lorenz.avi');
writerObj.FrameRate = frame;
open(writerObj);
writeVideo(writerObj, F);
close(writerObj);

function dxdt = lorenz(t,x,p,r,b)
dxdt = [-p*x(1)+p*x(2);
        -x(1)*x(3)+r*x(1)-x(2);
        x(1)*x(2)-b*x(3)];
end