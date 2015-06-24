clear;
gray=imread('./imgs/lp_EXP_50.bmp');
% gray=imread('./imgs/hp_EXP_5.bmp');
gray=double(gray);
J=fft2(gray);
J=fftshift(J);
[M,N]=size(J);
n1=floor(M/2);
n2=floor(N/2);
D0=30;
D1=5;
D3=5;
w=20;
n=2;
for u=1:M
    for v=1:N
        d=sqrt((u-n1)^2+(v-n2)^2);
        R(u,v)=1/(1+(D1/d)^(2*n));
        G(u,v)=1/(1+(d/D0)^(2*n));
        B(u,v)=1-(1/(1+((d*w)/(d^2-D3^2))^(2*n)));
    end
end
R1=R.*J;
G1=G.*J;
B1=B.*J;
R=ifftshift(R1);
G=ifftshift(G1);
B=ifftshift(B1);
% R1=uint8(real(ifft2(R)+gray));
R1=uint8(real(ifft2(R)+gray));
G1=uint8(real(ifft2(G)));
B1=uint8(real(ifft2(B)));
figure(2),imshow(R1) ,print(2,'-djpeg','./imgs/Pseudo_R.bmp');
figure(3),imshow(G1),print(3,'-djpeg','./imgs/Pseudo_G.bmp');
figure(4),imshow(B1),print(4,'-djpeg','./imgs/Pseudo_B.bmp');
J=cat(3,R1,G1,B1);
figure(5),imshow(J),print(5,'-djpeg','./imgs/Pseudo_result.bmp')
