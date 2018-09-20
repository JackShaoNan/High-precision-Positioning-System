x=-3:0.1:3;
PI = 3.1415926535;
y1 = 0.*(x< -PI/2) + (sin(x)+1)/2.*(x>= -PI/2 & x<PI/2) + 1.*(x>=PI/2);
y2 = 0.*(x<-1) + (0.5*x+0.5).*(x>=-1 & x<=1) + 1.*(x>1);
y3 = atan(x) + 0.5;
n1 = awgn(y1,20);
n2 = awgn(y2,20);
n3 = awgn(y3,20);
xlim([-3,3]);
ylim([-0.5,0.5]);
subplot(3,1,1)
plot(x,y1,'b',x,n1,'r');
ylabel('Grayscale');
set(gca,'FontSize',12);
legend('Sine Function','Noise Added','Location','southeast');
title('Sine Funciton')
subplot(3,1,2)
plot(x,y2,'b',x,n2,'r');
ylabel('Grayscale');
set(gca,'FontSize',12);
legend('Linear Function','Noise Added','Location','southeast');
title('Linear Function')
subplot(3,1,3)
plot(x,y3,'b',x,n3,'r');
ylabel('Grayscale');
set(gca,'FontSize',12);
legend('Arc-tangent Function','Noise Added','Location','southeast');
title('Arc-tangent Function')

p1 = get1DEdge(n1);
p2 = get1DEdge(n2);
p3 = get1DEdge(n3);
n = length(x);
e1 = -3 + 0.1*p1*n;
e2 = -3 + 0.1*p2*n;
e3 = -3 + 0.1*p3*n;
