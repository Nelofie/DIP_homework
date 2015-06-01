function bw=MyEdge(I,method,t1)
% to implement a function like the edge() of malab toolbox
% supported edge dectection operators are:
% method should be 'sobel', 'prewitt', 'roberts', 'marr', 'canny'
if(nargin<3)
    t1=0.3;
end
I=im2double(I);
if(length(size(I))==3)
    I=rgb2gray(I);
end
Gradient=zeros(size(I));
[height,width]=size(I);
bw=Gradient;
if(strcmp(method,'roberts'))
    H1=[0,1;-1,0];
    H2=H1';
    Gradient=MaskEdge(I,H1)+MaskEdge(I,H2);
    t1=0.25;
    bw=im2bw(Gradient,t1);
    bw=bwmorph(bw,'skel');
elseif(strcmp(method,'prewitt'))
    H1=[-1,0,1;-1,0,1;-1,0,1];
    H2=H1';
    Gradient=MaskEdge(I,H1)+MaskEdge(I,H2);
    t1=0.65;
    bw=im2bw(Gradient,t1);
    bw=bwmorph(bw,'skel');
elseif(strcmp(method,'sobel'))
    H1=[-1,0,1;-2,0,2;-1,0,1];            
    H2=H1';
    Gradient=MaskEdge(I,H1)+MaskEdge(I,H2);
    t1=0.8;
    bw=im2bw(Gradient,t1);
    bw=bwmorph(bw,'skel');
elseif(strcmp(method,'marr'))
    %H=[0,0,-1,0,0;0,-1,-2,-1,0;-1,-2,16,-2,-1;0,-1,-2,-1,0;0,0,-1,0,0];
    sigma=1.6;
    gaussFilter= fspecial('gaussian',[5 5],sigma);
    I=imfilter(I,gaussFilter,'replicate');
    for i=3:height-2
        for j=3:width-2
            val=-1*I(i-2,j)-I(i,j-2)-I(i+2,j)-I(i,j+2);
            val=val-I(i-1,j-1)-I(i-1,j+1)-I(i+1,j-1)-I(i+1,j+1);
            val=val-2*I(i-1,j)-2*I(i+1,j)-2*I(i,j-1)-2*I(i,j+1);
            val=val+16*I(i,j);
            Gradient(i,j)=val;
        end
    end
    t1=0.1;
    bw=im2bw(Gradient,t1);
    bw=bwmorph(bw,'remove');
elseif(strcmp(method,'canny'))
    bw=cannyEdge(I);
else
    fprintf('method invalid \n');
    return;
end
end