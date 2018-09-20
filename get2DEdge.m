%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%为节省储存空间，像素用uint8存储（8位无符号整数），而计算时要转换为double，否则会产生溢出！计算完显示图像要在转换回uint8！！！
%详见http://blog.sina.com.cn/s/blog_484dbdec0101eqkb.html
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%目前存在问题：1.输入图像的预处理（论文中要求数据数列单调，否则要分成若干单调部分处理）
%                      2.由于模板有一定大小，对于图像边缘部分如何处理？答：被处理图像边缘往往并没有有效信息
%                      3.是否为虚假边缘的判据中：对于sigma应大于某一常数，如何取？对于边缘距离d应有一上限Thr，如何取？答：考虑到
%                         应用场合的特殊性，被识别目标简单，通常无需判断虚假边缘，另外上限的选取可以自行试验。
%                      4.对于检测出的亚像素边缘信息如何可视化的表示？（看到的图像不都是以像素为单位吗？只记录边缘坐标即可？）答：
%                         可以将结果图像放大表示。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%aa = imread('C:\Users\Administrator\Desktop\毕设\test.jpg');
%grayPic = rgb2gray(aa);%将图片归一化
aa = zeros(100,100);
for ai = 1:100
    for aj = 1:50
        aa(ai,aj) = 255;
    end
end
grayPic = aa;
bb = edge(grayPic,'roberts');%先粗略检测边缘信息
grayPic = im2double(grayPic);%为计算转换数据类型
%imshow(bb);
%function e2 = get2DEdge(a)
%a为待处理灰度图像
%e2为保存边缘信息的二维矩阵
row = 1;%e2的下标
col = 1;
e2(row,col) = 0;%初始化e2
initPic = aa;%原始图片

[m,n] = size(grayPic);%图片大小
expandPic = zeros(m,n);%将图片扩大十倍便于展示所探测的亚像素边缘
m1 = 0;%三阶灰度矩
m2 = 0;
m3 = 0;
sigma = 0;%系数
s = 0;
h1 = 0;%灰度1
h2 = 0;%灰度2
p1 = 0;%灰度1对应比例
w0 = 0;%各权值
w1 = 0.00913767235;
w2 = 0.021840193;
w3 = 0.025674188;
w4 = 0.025951560;
w5 = 0.025984481;
d = 0;%边缘距离
%a = 0;%边缘方位角度
x0 = 0;%单位圆中灰度重心坐标，用于计算角度a
y0 = 0;
%b = 0;%计算d用到的角度
Thr = 7;%某一阈值(暂定为7)
for i = 4 : (m-3)
    for j = 4 : (n-3)
        %先看是否为粗略探测的边缘 若是则进行灰度矩判断，否则不判断
        if bb(i,j) > 0
            %首先计算m1 m2 m3
            m1 = w0*grayPic(i-3,j-3) + w1*grayPic(i-3,j-2) + w2*grayPic(i-3,j-1)...
            + w3*grayPic(i-3,j) + w2*grayPic(i-3,j+1) + w1*grayPic(i-3,j+2)...
            + w0*grayPic(i-3,j+3)...%第一行
            + w1*grayPic(i-2,j-3) + w4*grayPic(i-2,j-2) + w5*grayPic(i-2,j-1)...
            + w5*grayPic(i-2,j) + w5*grayPic(i-2,j+1) + w4*grayPic(i-2,j+2)...
            + w1*grayPic(i-2,j+3)...%第二行
            + w2*grayPic(i-1,j-3) + w5*grayPic(i-1,j-2) + w5*grayPic(i-1,j-1)...
            + w5*grayPic(i-1,j) + w5*grayPic(i-1,j+1) + w5*grayPic(i-1,j+2)...
            + w2*grayPic(i-1,j+3)...%第三行
            + w3*grayPic(i,j-3) + w5*grayPic(i,j-2) + w5*grayPic(i,j-1)...
            + w5*grayPic(i,j) + w5*grayPic(i,j+1) + w5*grayPic(i,j+2)...
            + w3*grayPic(i,j+3)...%第四行
            + w2*grayPic(i+1,j-3) + w5*grayPic(i+1,j-2) + w5*grayPic(i+1,j-1)...
            + w5*grayPic(i+1,j) + w5*grayPic(i+1,j+1) + w5*grayPic(i+1,j+2)...
            + w2*grayPic(i+1,j+3)...%第五行
            + w1*grayPic(i+2,j-3) + w4*grayPic(i+2,j-2) + w5*grayPic(i+2,j-1)...
            + w5*grayPic(i+2,j) + w5*grayPic(i+2,j+1) + w4*grayPic(i+2,j+2)...
            + w1*grayPic(i+2,j+3)...&第六行
            + w0*grayPic(i+3,j-3) + w1*grayPic(i+3,j-2) + w2*grayPic(i+3,j-1)...
            + w3*grayPic(i+3,j) + w2*grayPic(i+3,j+1) + w1*grayPic(i+3,j+2)...
            + w0*grayPic(i+3,j+3);%第七行
        
            m2 = w0*grayPic(i-3,j-3)^2 + w1*grayPic(i-3,j-2)^2 + w2*(grayPic(i-3,j-1)^2)...
            + w3*grayPic(i-3,j)^2 + w2*grayPic(i-3,j+1)^2 + w1*(grayPic(i-3,j+2)^2)...
            + w0*(grayPic(i-3,j+3)^2)...%第一行
            + w1*grayPic(i-2,j-3)^2 + w4*grayPic(i-2,j-2)^2 + w5*(grayPic(i-2,j-1)^2)...
            + w5*grayPic(i-2,j)^2 + w5*grayPic(i-2,j+1)^2 + w4*(grayPic(i-2,j+2)^2)...
            + w1*(grayPic(i-2,j+3)^2)...%第二行
            + w2*grayPic(i-1,j-3)^2 + w5*grayPic(i-1,j-2)^2 + w5*(grayPic(i-1,j-1)^2)...
            + w5*grayPic(i-1,j)^2 + w5*grayPic(i-1,j+1)^2 + w5*(grayPic(i-1,j+2)^2)...
            + w2*(grayPic(i-1,j+3)^2)...%第三行
            + w3*grayPic(i,j-3)^2 + w5*grayPic(i,j-2)^2 + w5*(grayPic(i,j-1)^2)...
            + w5*grayPic(i,j)^2 + w5*grayPic(i,j+1)^2 + w5*(grayPic(i,j+2)^2)...
            + w3*(grayPic(i,j+3)^2)...%第四行
            + w2*grayPic(i+1,j-3)^2 + w5*grayPic(i+1,j-2)^2 + w5*(grayPic(i+1,j-1)^2)...
            + w5*grayPic(i+1,j)^2 + w5*grayPic(i+1,j+1)^2 + w5*(grayPic(i+1,j+2)^2)...
            + w2*(grayPic(i+1,j+3)^2)...%第五行
            + w1*grayPic(i+2,j-3)^2 + w4*grayPic(i+2,j-2)^2 + w5*(grayPic(i+2,j-1)^2)...
            + w5*grayPic(i+2,j)^2 + w5*grayPic(i+2,j+1)^2 + w4*(grayPic(i+2,j+2)^2)...
            + w1*(grayPic(i+2,j+3)^2)...%第六行
            + w0*grayPic(i+3,j-3)^2 + w1*grayPic(i+3,j-2)^2 + w2*(grayPic(i+3,j-1)^2)...
            + w3*grayPic(i+3,j)^2 + w2*grayPic(i+3,j+1)^2 + w1*(grayPic(i+3,j+2)^2)...
            + w0*grayPic(i+3,j+3)^2;%第七行
        
            m3 = w0*grayPic(i-3,j-3)^3 + w1*grayPic(i-3,j-2)^3 + w2*(grayPic(i-3,j-1)^3)...
            + w3*grayPic(i-3,j)^3 + w2*grayPic(i-3,j+1)^3 + w1*(grayPic(i-3,j+2)^3)...
            + w0*(grayPic(i-3,j+3)^3)...%第一行
            + w1*grayPic(i-2,j-3)^3 + w4*grayPic(i-2,j-2)^3 + w5*(grayPic(i-2,j-1)^3)...
            + w5*grayPic(i-2,j)^3 + w5*grayPic(i-2,j+1)^3 + w4*(grayPic(i-2,j+2)^3)...
            + w1*(grayPic(i-2,j+3)^3)...%第二行
            + w2*grayPic(i-1,j-3)^3 + w5*grayPic(i-1,j-2)^3 + w5*(grayPic(i-1,j-1)^3)...
            + w5*grayPic(i-1,j)^3 + w5*grayPic(i-1,j+1)^3 + w5*(grayPic(i-1,j+2)^3)...
            + w2*(grayPic(i-1,j+3)^3)...%第三行
            + w3*grayPic(i,j-3)^3 + w5*grayPic(i,j-2)^3 + w5*(grayPic(i,j-1)^3)...
            + w5*grayPic(i,j)^3 + w5*grayPic(i,j+1)^3 + w5*(grayPic(i,j+2)^3)...
            + w3*(grayPic(i,j+3)^3)...%第四行
            + w2*grayPic(i+1,j-3)^3 + w5*grayPic(i+1,j-2)^3 + w5*(grayPic(i+1,j-1)^3)...
            + w5*grayPic(i+1,j)^3 + w5*grayPic(i+1,j+1)^3 + w5*(grayPic(i+1,j+2)^3)...
            + w2*(grayPic(i+1,j+3)^3)...%第五行
            + w1*grayPic(i+2,j-3)^3 + w4*grayPic(i+2,j-2)^3 + w5*(grayPic(i+2,j-1)^3)...
            + w5*grayPic(i+2,j)^3 + w5*grayPic(i+2,j+1)^3 + w4*(grayPic(i+2,j+2)^3)...
            + w1*(grayPic(i+2,j+3)^3)...%第六行
            + w0*grayPic(i+3,j-3)^3 + w1*grayPic(i+3,j-2)^3 + w2*(grayPic(i+3,j-1)^3)...
            + w3*grayPic(i+3,j)^3 + w2*grayPic(i+3,j+1)^3 + w1*(grayPic(i+3,j+2)^3)...
            + w0*grayPic(i+3,j+3)^3;%第七行
            %得出系数
            sigma = sqrt(double(m2 - m1 * m1));
            %先判断sigma是否大于0，成立才继续运算判断，否则退出本次循环
            %判断顺序：先sigma，再abs（h2-h1）>2*sigma,最后边缘位置d<=(2*Thr/N)
            %其中THR为一阈值限制d，N为模板大小此例中应为7
            if sigma > 0
                 s = (m3 + 2*m1^3 - 3*m1*m2)/(sigma^3);
                %得出结果
          
            p1 = 0.5 * (1 + s*sqrt(double(1/(4 + s*s))));
            h1 = double(m1) - sigma*sqrt(double((1-p1) / p1));
            h2 = double(m1) + sigma*sqrt(double((1-p1) / p1));
            %第二步判断
           % if abs(h2 - h1)>2*sigma
                %计算距离d
                if p1>0.5
                    eq = strcat(strcat('x-0.5*sin(2*x)-pi*(1-',num2str(p1)),')==0');
                    b = solve(eq,'x');
                else
                    eq=strcat(strcat('x-0.5*sin(2*x)-pi*(',num2str(p1)),')==0');
                    b = solve(eq,'x');
                end
                d = cos(b);
                %第三步判断
                   % if d <= (2*Thr/7)
                        %判据全部满足，可以视为边缘并计算亚像素坐标
                        %先计算边缘方位角a
                        I0 = 0;%存放单位圆内灰度值和 (x0 y0的分母)
                        xx = 0;%存放计算x0的分子
                        yy = 0;%存放计算y0的分子
                        for ii = (i-3) : (i+3)
                            for jj = (j-3) : (j+3)
                                I0 = I0 + grayPic(ii,jj);
                                xx = xx + ii * grayPic(ii,jj);
                                yy = yy + jj * grayPic(ii,jj);
                            end
                        end
                        I0 = I0 - grayPic(i-3,j-3) - grayPic(i-3,j+3) - grayPic(i+3,j-3) - grayPic(i+3,j+3);
                        xx = xx - (i-3)*grayPic(i-3,j-3) - (i-3)*grayPic(i-3,j+3) - (i+3)*grayPic(i+3,j-3) - (i+3)*grayPic(i+3,j+3);
                        yy = yy - (j-3)*grayPic(i-3,j-3) - (j-3)*grayPic(i+3,j-3) - (j+3)*grayPic(i-3,j+3) - (j+3)*grayPic(i+3,j+3);
                        x0 = xx / I0;
                        y0 = yy / I0;
                        %下面可以表示出边缘方位角的正弦或余弦
                        sa = y0 / (sqrt(double(x0*x0 + y0*y0)));
                        ca = x0 / (sqrt(double(x0*x0 + y0*y0)));
                        %保存信息(按照被检测像素横坐标，纵坐标，亚像素边缘横坐标，纵坐标顺序储存)
                        e2(row,col) = i;col = col + 1;
                        e2(row,col) = j;col = col + 1;
                        e2(row,col) = (i + 3.5 * ca * d);col = col + 1;
                        e2(row,col) = (j + 3.5 * sa * d);
                        col = 1;
                        row = row + 1;
                        %将该边缘点信息展示出来 即先将其坐标放大十倍 再四舍五入取最邻近点在expandPic中置一
                        %expandPic(round(10*(i + 3.5 * ca * d)),round(10*(j + 3.5 * sa * d))) = 255;
                        expandPic(round(i + 3.5 * ca * d),round(j + 3.5 * sa * d)) = 255;
                  %  end
                  
                
              %  end
            
            end
        end
    end
end
%展示结果
subplot(1,3,1);
imshow(initPic),title('原始图片');
subplot(1,3,2);
imshow(bb),title('初步检测边缘信息图片');
subplot(1,3,3);
imshow(expandPic),title('放大十倍后的边缘信息图片');
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        