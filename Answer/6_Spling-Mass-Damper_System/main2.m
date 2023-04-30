%% Reset
clear
close

%% Input
load("setup.mat");

x0 = Set.sim_x0;
tspan = Set.sim_tspan;
frame = Set.sim_frame;
A = Set.LQR_A;
B = Set.LQR_B;
Q = Set.LQR_Q;
R = Set.LQR_R;

w1 = Set.ani_w1;
w2 = Set.ani_w2;
h1 = Set.ani_h1;
h2 = Set.ani_h2;
y01 = Set.ani_y01;
y02 = Set.ani_y02;

%% Solve LQR
[K,~,~] = lqr(A,B,Q,R);

%% Solve ODE
[t,x] = ode45(@(t,x) SMDS(t,x,A,B,K),tspan,x0);

%% plot
f = figure;
f.WindowState = 'maximized';
set(0,"DefaultTextFontSize",30);
set(0,"DefaultAxesFontSize",30);
for i = 1:length(t)
    Y1 = y01+x(i,1);
    Y2 = y02+x(i,2);
    plotrectangle(0,Y1,w1,h1);
    hold on;
    plotrectangle(0,Y2,w2,h2);
    axis([-1,1,0,3]);
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

%% Function
function dxdt = SMDS(t,x,A,B,K)
dxdt = A*x-B*K*x;
end