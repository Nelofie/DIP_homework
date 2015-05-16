function J=MyHisteq(I)
%input is a rgb image or gray image
%output is the gray image that has been eq
if(nargin<1)
    I=imread('MU1.jpg');
end

if(length(size(I)==3))
    G=rgb2gray(I);
else
    G=I;
end
[height,width]=size(G);
histgram=get_hist(G);
cdf=get_cdf(histgram,height*width);
G_eq=run_eq(G,cdf);
figure,
subplot(2,2,1),imshow(G);
subplot(2,2,2),imshow(G_eq);
subplot(2,2,3),imhist(G);
subplot(2,2,4),imhist(G_eq);
J=G_eq;
end

function G_eq=run_eq(G,cdf)
[height,width]=size(G);
G_eq=zeros(height,width);
for i=1:height
    for j=1:width
        val=G(i,j);
        G_eq(i,j)=cdf(val);
    end
end
G_eq=G_eq*256;
G_eq=uint8(G_eq);
end

function H=get_hist(G)
[height,width]=size(G);
H=zeros(1,256);
for i=1:height
    for j=1:width
        val=G(i,j);
        H(val)=H(val)+1;
    end
end
end

function cdf=get_cdf(H,total)
len=length(H);
cdf=zeros(1,len);
cdf(1)=H(1);
for i=2:len
    cdf(i)=cdf(i-1)+H(i);
end
cdf=cdf/total;
end


