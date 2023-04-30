function plotrectangle(xc,yc,h,v)
x1 = xc-h/2;
y1 = yc-v/2;
x2 = xc+h/2;
y2 = yc+v/2;

plot([x1,x1],[y1,y2],"Color","k","LineWidth",2);
hold on
plot([x1,x2],[y1,y1],"Color","k","LineWidth",2);
plot([x1,x2],[y2,y2],"Color","k","LineWidth",2);
plot([x2,x2],[y1,y2],"Color","k","LineWidth",2);
hold off
end