function J=linear_transform(I,a,b)
% y=ax+b

if(nargin<3)
    I=rgb2gray(imread('MU1.jpg'));
    a=0.5;
    b=0.1;
end

if(length(size(I))>2)
    I=rgb2gray(I);
end

I=im2double(I);
J=I*a+b;
J(find(J>1))=1;
J(find(J<0))=0;
figure,imshow(J);
end