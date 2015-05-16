function J=MyImresize(I,tar_h,tar_w,param)
% implementation of imresize
% input: I the image to be imresized
% input: tar_h--> target height and tar_w --> target width
% input: param: 'nearest', 'bilinear'
% output: J resized image
if(nargin<4)
    I=imread('./img/tiger_sp.bmp');
    tar_h=128;tar_w=128;
    param='bilinear';
end

J=MyImresizeSingleDim(I,tar_h,tar_w,param);
end

function J=MyImresizeSingleDim(I,tar_h,tar_w,param)
I=im2double(I);
% I should be one dimision matrix (bw or grayscale image)
[height,width]=size(I);
J=zeros(tar_h,tar_w);
h_rate=tar_h/height;
w_rate=tar_w/width;
if(strcmp(param,'nearest')==1)
    for i=1:tar_h
        for j=1:tar_w
            tar_x=round(i/h_rate);
            tar_y=round(j/w_rate);
            if(tar_x<1)
                tar_x=1;
            elseif(tar_x>height)
                tar_x=height;
            end
            if(tar_y<1)
                tar_y=1;
            elseif(tar_y>width)
                tar_y=width;
            end
            J(i,j)=I(tar_x,tar_y);
        end
    end
elseif(strcmp(param,'bilinear')==1)
    for i=1:tar_h
        for j=1:tar_w
            tar_x=floor(i/h_rate);
            tar_y=floor(j/w_rate);
            if(tar_x<1)
                tar_x=1;
            elseif(tar_x>=height-1)
                tar_x=height-1;
            end
            if(tar_y<1)
                tar_y=1;
            elseif(tar_y>=width-1)
                tar_y=width-1;
            end
            u=i/h_rate-tar_x;
            v=j/w_rate-tar_y;
            J(i,j)=(1-u)*(1-v)*I(tar_x,tar_y)+(1-u)*v*I(tar_x,tar_y+1)+(1-v)*u*I(tar_x+1,tar_y);
            J(i,j)=J(i,j)+u*v*I(tar_x+1,tar_y+1);           
        end
    end
else
    fprintf('method not supported\n');
end
end