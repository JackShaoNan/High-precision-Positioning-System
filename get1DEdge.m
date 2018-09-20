function e1 = get1DEdge(y)
%%y 是一条直线的灰度信息, 该函数将找到这条直线上的精确的亚像素级别的边缘（阶跃）信息
n = length(y);%得到像素个数
%下面根据公式推导求出精确位置e1
m1 = 0;
m2 = 0;
m3 = 0;
for i = 1 : n
    m1 = m1 + y(i);
    m2 = m2 + y(i)*y(i);
    m3 = m3 + y(i)*y(i)*y(i);
end
m1 = m1/n;
m2 = m2/n;
m3 = m3/n;
sigma = sqrt(m2 - m1*m1);
s = (m3+2*m1^3-3*m1*m2)/(sigma^3);
e1 = (0.5*n*s*sqrt(1/(4+s*s))+(n-1)/2);