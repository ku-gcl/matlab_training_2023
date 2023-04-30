function plotcircle(xc,yc,r)
theta = linspace(0,2*pi);
x = r*cos(theta)+xc;
y = r*sin(theta)+yc;
plot(x,y,"Color","k","LineWidth",2)
end