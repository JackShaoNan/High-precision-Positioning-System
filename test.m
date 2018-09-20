function I=test()
for n=0:1:3
for k=0:1:3
    if (cos((2*n+1)*k*pi)/8 >0)
        I(n+1,k+1)=cos((2*n+1)*k*pi)/8;
    end
end
end