%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Ϊ��ʡ����ռ䣬������uint8�洢��8λ�޷�����������������ʱҪת��Ϊdouble�����������������������ʾͼ��Ҫ��ת����uint8������
%���http://blog.sina.com.cn/s/blog_484dbdec0101eqkb.html
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Ŀǰ�������⣺1.����ͼ���Ԥ����������Ҫ���������е���������Ҫ�ֳ����ɵ������ִ���
%                      2.����ģ����һ����С������ͼ���Ե������δ����𣺱�����ͼ���Ե������û����Ч��Ϣ
%                      3.�Ƿ�Ϊ��ٱ�Ե���о��У�����sigmaӦ����ĳһ���������ȡ�����ڱ�Ե����dӦ��һ����Thr�����ȡ���𣺿��ǵ�
%                         Ӧ�ó��ϵ������ԣ���ʶ��Ŀ��򵥣�ͨ�������ж���ٱ�Ե���������޵�ѡȡ�����������顣
%                      4.���ڼ����������ر�Ե��Ϣ��ο��ӻ��ı�ʾ����������ͼ�񲻶���������Ϊ��λ��ֻ��¼��Ե���꼴�ɣ�����
%                         ���Խ����ͼ��Ŵ��ʾ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%aa = imread('C:\Users\Administrator\Desktop\����\test.jpg');
%grayPic = rgb2gray(aa);%��ͼƬ��һ��
aa = zeros(100,100);
for ai = 1:100
    for aj = 1:50
        aa(ai,aj) = 255;
    end
end
grayPic = aa;
bb = edge(grayPic,'roberts');%�ȴ��Լ���Ե��Ϣ
grayPic = im2double(grayPic);%Ϊ����ת����������
%imshow(bb);
%function e2 = get2DEdge(a)
%aΪ������Ҷ�ͼ��
%e2Ϊ�����Ե��Ϣ�Ķ�ά����
row = 1;%e2���±�
col = 1;
e2(row,col) = 0;%��ʼ��e2
initPic = aa;%ԭʼͼƬ

[m,n] = size(grayPic);%ͼƬ��С
expandPic = zeros(m,n);%��ͼƬ����ʮ������չʾ��̽��������ر�Ե
m1 = 0;%���׻ҶȾ�
m2 = 0;
m3 = 0;
sigma = 0;%ϵ��
s = 0;
h1 = 0;%�Ҷ�1
h2 = 0;%�Ҷ�2
p1 = 0;%�Ҷ�1��Ӧ����
w0 = 0;%��Ȩֵ
w1 = 0.00913767235;
w2 = 0.021840193;
w3 = 0.025674188;
w4 = 0.025951560;
w5 = 0.025984481;
d = 0;%��Ե����
%a = 0;%��Ե��λ�Ƕ�
x0 = 0;%��λԲ�лҶ��������꣬���ڼ���Ƕ�a
y0 = 0;
%b = 0;%����d�õ��ĽǶ�
Thr = 7;%ĳһ��ֵ(�ݶ�Ϊ7)
for i = 4 : (m-3)
    for j = 4 : (n-3)
        %�ȿ��Ƿ�Ϊ����̽��ı�Ե ��������лҶȾ��жϣ������ж�
        if bb(i,j) > 0
            %���ȼ���m1 m2 m3
            m1 = w0*grayPic(i-3,j-3) + w1*grayPic(i-3,j-2) + w2*grayPic(i-3,j-1)...
            + w3*grayPic(i-3,j) + w2*grayPic(i-3,j+1) + w1*grayPic(i-3,j+2)...
            + w0*grayPic(i-3,j+3)...%��һ��
            + w1*grayPic(i-2,j-3) + w4*grayPic(i-2,j-2) + w5*grayPic(i-2,j-1)...
            + w5*grayPic(i-2,j) + w5*grayPic(i-2,j+1) + w4*grayPic(i-2,j+2)...
            + w1*grayPic(i-2,j+3)...%�ڶ���
            + w2*grayPic(i-1,j-3) + w5*grayPic(i-1,j-2) + w5*grayPic(i-1,j-1)...
            + w5*grayPic(i-1,j) + w5*grayPic(i-1,j+1) + w5*grayPic(i-1,j+2)...
            + w2*grayPic(i-1,j+3)...%������
            + w3*grayPic(i,j-3) + w5*grayPic(i,j-2) + w5*grayPic(i,j-1)...
            + w5*grayPic(i,j) + w5*grayPic(i,j+1) + w5*grayPic(i,j+2)...
            + w3*grayPic(i,j+3)...%������
            + w2*grayPic(i+1,j-3) + w5*grayPic(i+1,j-2) + w5*grayPic(i+1,j-1)...
            + w5*grayPic(i+1,j) + w5*grayPic(i+1,j+1) + w5*grayPic(i+1,j+2)...
            + w2*grayPic(i+1,j+3)...%������
            + w1*grayPic(i+2,j-3) + w4*grayPic(i+2,j-2) + w5*grayPic(i+2,j-1)...
            + w5*grayPic(i+2,j) + w5*grayPic(i+2,j+1) + w4*grayPic(i+2,j+2)...
            + w1*grayPic(i+2,j+3)...&������
            + w0*grayPic(i+3,j-3) + w1*grayPic(i+3,j-2) + w2*grayPic(i+3,j-1)...
            + w3*grayPic(i+3,j) + w2*grayPic(i+3,j+1) + w1*grayPic(i+3,j+2)...
            + w0*grayPic(i+3,j+3);%������
        
            m2 = w0*grayPic(i-3,j-3)^2 + w1*grayPic(i-3,j-2)^2 + w2*(grayPic(i-3,j-1)^2)...
            + w3*grayPic(i-3,j)^2 + w2*grayPic(i-3,j+1)^2 + w1*(grayPic(i-3,j+2)^2)...
            + w0*(grayPic(i-3,j+3)^2)...%��һ��
            + w1*grayPic(i-2,j-3)^2 + w4*grayPic(i-2,j-2)^2 + w5*(grayPic(i-2,j-1)^2)...
            + w5*grayPic(i-2,j)^2 + w5*grayPic(i-2,j+1)^2 + w4*(grayPic(i-2,j+2)^2)...
            + w1*(grayPic(i-2,j+3)^2)...%�ڶ���
            + w2*grayPic(i-1,j-3)^2 + w5*grayPic(i-1,j-2)^2 + w5*(grayPic(i-1,j-1)^2)...
            + w5*grayPic(i-1,j)^2 + w5*grayPic(i-1,j+1)^2 + w5*(grayPic(i-1,j+2)^2)...
            + w2*(grayPic(i-1,j+3)^2)...%������
            + w3*grayPic(i,j-3)^2 + w5*grayPic(i,j-2)^2 + w5*(grayPic(i,j-1)^2)...
            + w5*grayPic(i,j)^2 + w5*grayPic(i,j+1)^2 + w5*(grayPic(i,j+2)^2)...
            + w3*(grayPic(i,j+3)^2)...%������
            + w2*grayPic(i+1,j-3)^2 + w5*grayPic(i+1,j-2)^2 + w5*(grayPic(i+1,j-1)^2)...
            + w5*grayPic(i+1,j)^2 + w5*grayPic(i+1,j+1)^2 + w5*(grayPic(i+1,j+2)^2)...
            + w2*(grayPic(i+1,j+3)^2)...%������
            + w1*grayPic(i+2,j-3)^2 + w4*grayPic(i+2,j-2)^2 + w5*(grayPic(i+2,j-1)^2)...
            + w5*grayPic(i+2,j)^2 + w5*grayPic(i+2,j+1)^2 + w4*(grayPic(i+2,j+2)^2)...
            + w1*(grayPic(i+2,j+3)^2)...%������
            + w0*grayPic(i+3,j-3)^2 + w1*grayPic(i+3,j-2)^2 + w2*(grayPic(i+3,j-1)^2)...
            + w3*grayPic(i+3,j)^2 + w2*grayPic(i+3,j+1)^2 + w1*(grayPic(i+3,j+2)^2)...
            + w0*grayPic(i+3,j+3)^2;%������
        
            m3 = w0*grayPic(i-3,j-3)^3 + w1*grayPic(i-3,j-2)^3 + w2*(grayPic(i-3,j-1)^3)...
            + w3*grayPic(i-3,j)^3 + w2*grayPic(i-3,j+1)^3 + w1*(grayPic(i-3,j+2)^3)...
            + w0*(grayPic(i-3,j+3)^3)...%��һ��
            + w1*grayPic(i-2,j-3)^3 + w4*grayPic(i-2,j-2)^3 + w5*(grayPic(i-2,j-1)^3)...
            + w5*grayPic(i-2,j)^3 + w5*grayPic(i-2,j+1)^3 + w4*(grayPic(i-2,j+2)^3)...
            + w1*(grayPic(i-2,j+3)^3)...%�ڶ���
            + w2*grayPic(i-1,j-3)^3 + w5*grayPic(i-1,j-2)^3 + w5*(grayPic(i-1,j-1)^3)...
            + w5*grayPic(i-1,j)^3 + w5*grayPic(i-1,j+1)^3 + w5*(grayPic(i-1,j+2)^3)...
            + w2*(grayPic(i-1,j+3)^3)...%������
            + w3*grayPic(i,j-3)^3 + w5*grayPic(i,j-2)^3 + w5*(grayPic(i,j-1)^3)...
            + w5*grayPic(i,j)^3 + w5*grayPic(i,j+1)^3 + w5*(grayPic(i,j+2)^3)...
            + w3*(grayPic(i,j+3)^3)...%������
            + w2*grayPic(i+1,j-3)^3 + w5*grayPic(i+1,j-2)^3 + w5*(grayPic(i+1,j-1)^3)...
            + w5*grayPic(i+1,j)^3 + w5*grayPic(i+1,j+1)^3 + w5*(grayPic(i+1,j+2)^3)...
            + w2*(grayPic(i+1,j+3)^3)...%������
            + w1*grayPic(i+2,j-3)^3 + w4*grayPic(i+2,j-2)^3 + w5*(grayPic(i+2,j-1)^3)...
            + w5*grayPic(i+2,j)^3 + w5*grayPic(i+2,j+1)^3 + w4*(grayPic(i+2,j+2)^3)...
            + w1*(grayPic(i+2,j+3)^3)...%������
            + w0*grayPic(i+3,j-3)^3 + w1*grayPic(i+3,j-2)^3 + w2*(grayPic(i+3,j-1)^3)...
            + w3*grayPic(i+3,j)^3 + w2*grayPic(i+3,j+1)^3 + w1*(grayPic(i+3,j+2)^3)...
            + w0*grayPic(i+3,j+3)^3;%������
            %�ó�ϵ��
            sigma = sqrt(double(m2 - m1 * m1));
            %���ж�sigma�Ƿ����0�������ż��������жϣ������˳�����ѭ��
            %�ж�˳����sigma����abs��h2-h1��>2*sigma,����Եλ��d<=(2*Thr/N)
            %����THRΪһ��ֵ����d��NΪģ���С������ӦΪ7
            if sigma > 0
                 s = (m3 + 2*m1^3 - 3*m1*m2)/(sigma^3);
                %�ó����
          
            p1 = 0.5 * (1 + s*sqrt(double(1/(4 + s*s))));
            h1 = double(m1) - sigma*sqrt(double((1-p1) / p1));
            h2 = double(m1) + sigma*sqrt(double((1-p1) / p1));
            %�ڶ����ж�
           % if abs(h2 - h1)>2*sigma
                %�������d
                if p1>0.5
                    eq = strcat(strcat('x-0.5*sin(2*x)-pi*(1-',num2str(p1)),')==0');
                    b = solve(eq,'x');
                else
                    eq=strcat(strcat('x-0.5*sin(2*x)-pi*(',num2str(p1)),')==0');
                    b = solve(eq,'x');
                end
                d = cos(b);
                %�������ж�
                   % if d <= (2*Thr/7)
                        %�о�ȫ�����㣬������Ϊ��Ե����������������
                        %�ȼ����Ե��λ��a
                        I0 = 0;%��ŵ�λԲ�ڻҶ�ֵ�� (x0 y0�ķ�ĸ)
                        xx = 0;%��ż���x0�ķ���
                        yy = 0;%��ż���y0�ķ���
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
                        %������Ա�ʾ����Ե��λ�ǵ����һ�����
                        sa = y0 / (sqrt(double(x0*x0 + y0*y0)));
                        ca = x0 / (sqrt(double(x0*x0 + y0*y0)));
                        %������Ϣ(���ձ�������غ����꣬�����꣬�����ر�Ե�����꣬������˳�򴢴�)
                        e2(row,col) = i;col = col + 1;
                        e2(row,col) = j;col = col + 1;
                        e2(row,col) = (i + 3.5 * ca * d);col = col + 1;
                        e2(row,col) = (j + 3.5 * sa * d);
                        col = 1;
                        row = row + 1;
                        %���ñ�Ե����Ϣչʾ���� ���Ƚ�������Ŵ�ʮ�� ����������ȡ���ڽ�����expandPic����һ
                        %expandPic(round(10*(i + 3.5 * ca * d)),round(10*(j + 3.5 * sa * d))) = 255;
                        expandPic(round(i + 3.5 * ca * d),round(j + 3.5 * sa * d)) = 255;
                  %  end
                  
                
              %  end
            
            end
        end
    end
end
%չʾ���
subplot(1,3,1);
imshow(initPic),title('ԭʼͼƬ');
subplot(1,3,2);
imshow(bb),title('��������Ե��ϢͼƬ');
subplot(1,3,3);
imshow(expandPic),title('�Ŵ�ʮ����ı�Ե��ϢͼƬ');
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        