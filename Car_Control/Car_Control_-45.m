test = readfis('Car_Control.fis');

rectangle('Position',[5,0,1,1],'FaceColor',[1 1 1],'EdgeColor','k','LineWidth',1)
rectangle('Position',[6,0,1,2],'FaceColor',[1 1 1],'EdgeColor','k','LineWidth',1)
rectangle('Position',[7,0,3,3],'FaceColor',[1 1 1],'EdgeColor','k','LineWidth',1)

hold on
plot(10,3.2,'r*','DisplayName','Target');

plot(4,0.4,'g*','DisplayName','Robot');


% Use 10mx4m simulation environment.
axis([0 10 0 4]);


xinit = 4;
yinit = 0.4;
theta = -45;

x(1) = xinit;
y(1) = yinit;

dH(1) = xinit;
dV(1) = yinit;
Theta(1) = theta;


for i=1:250


if ((5-dH(i)> 1) && yinit < 1)

dH(i+1) = dH(i) + 0.05*cos(0);
dV(i+1) = dV(i) + 0.05*sin(0);
Theta(i+1) = Theta(1);
x(i+1) = dH(i+1);
y(i+1) = dV(i+1);


elseif ((5-dH(i)<= 1) && (5-dH(i) >= 0)) && (yinit < 1)

dH(i+1) = dH(i) + 0.05*cos(Theta(i)*pi/180);
dV(i+1) = dV(i) + 0.05*sin(Theta(i)*pi/180);
DeltaTheta(i+1) = evalfis([5-dH(i) dV(i) Theta(i)], test);
Theta(i+1) = DeltaTheta(i+1) + Theta(i);

x(i+1) = dH(i+1);
y(i+1) = dV(i+1);

end

if ((6-dH(i)<= 1) && (6-dH(i) >= 0)) && ((2 - dV(i) <= 1) && (2 - dV(i)  >= 0))

dH(i+1) = dH(i) + 0.05*cos(Theta(i)*pi/180);
dV(i+1) = dV(i) + 0.05*sin(Theta(i)*pi/180);
DeltaTheta(i+1) = evalfis([5-dH(i) dV(i) Theta(i)], test);
Theta(i+1) = DeltaTheta(i+1) + Theta(i);

x(i+1) = dH(i+1);
y(i+1) = dV(i+1);

end


if ((6-dH(i)<= 1) && (6-dH(i) >= 0)) && ((3 - dV(i) <= 1) && (3 - dV(i)  >= 0))

dH(i+1) = dH(i) + 0.05*cos(Theta(i)*pi/180);
dV(i+1) = dV(i) + 0.05*sin(Theta(i)*pi/180);
DeltaTheta(i+1) = evalfis([5-dH(i) dV(i) Theta(i)], test);
Theta(i+1) = DeltaTheta(i+1) + Theta(i);

x(i+1) = dH(i+1);
y(i+1) = dV(i+1);

end


if ((6-dH(i)<= 1) && (6-dH(i) >= 0)) && ((3 - dV(i) <= 0))

dH(i+1) = dH(i) + 0.05*cos(Theta(i)*pi/180);
dV(i+1) = dV(i) + 0.05*sin(Theta(i)*pi/180);
DeltaTheta(i+1) = evalfis([5-dH(i) dV(i) Theta(i)], test);
Theta(i+1) = DeltaTheta(i+1) + Theta(i);

x(i+1) = dH(i+1);
y(i+1) = dV(i+1);



end

if (dV(i) > 3.2 && dV(i) <= 3.3)

dH(i+1) = dH(i) + 0.05*cos(0);
dV(i+1) = dV(i) + 0.05*sin(0);
Theta(i+1) = Theta(1);
x(i+1) = dH(i+1);
y(i+1) = dV(i+1);

end

if (dH(i) > 9.96 && dV(i) <3.3)
return;
end


hold on

plot(x(i+1),y(i+1),'b.','DisplayName','Orbit');

end

% Add labels, title, and legends.
xlabel('x (m)'),ylabel('y (m)')
title('Car Control with Fuzzy Logic')
hold off
legend({'Target','Robot','Orbit'},'Location','northwest','Orientation','horizontal')