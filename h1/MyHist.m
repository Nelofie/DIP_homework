function MyHist(I)
%input is a rgb image or gray image
if(nargin<1)
    I=imread('MU1.jpg');
end

if(length(size(I)==3))
    G=rgb2gray(I);
else
    G=I;
end

[height,width]=size(G);
H=zeros(1,256);
for i=1:height
    for j=1:width
        val=G(i,j);
        H(val)=H(val)+1;
    end
end

x=1:256;
bar(x,H);
end