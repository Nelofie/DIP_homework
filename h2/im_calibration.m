function I2=im_calibration(I,p,sp,pim)
% Input: I is the image to be corrected
%        p is the control point should have 2 part: p.x and p.y to indicate
%        the coordinate. So as sp
%        pim is the point image 
% Output: J is the corrected image

%% default input
if(nargin<2)
    I=imread('./img/tiger_sp.bmp');
    %load the registed points and deformated points
    load('pos.mat');
    load('pre.mat');
    pos.x=round(pos.x); pos.y=round(pos.y);
    pre.x=round(pre.x); pre.y=round(pre.y);
    k=find(mod(pre.x,10)==9);
    pre.x(k)=pre.x(k)+1;
    k=find(mod(pre.y,10)==9);
    pre.y(k)=pre.y(k)+1;
    pim=imread('./img/point.bmp');
else
    pre=p;
    pos=sp;
end
[imheight,imwidth]=size(I);
[pheight,pwidth]=size(pim);
%store backward mapping result
backProj_x=zeros(pheight,pwidth);
backProj_y=zeros(pheight,pwidth);
%store forward mapping result
frontProj_x=zeros(pheight,pwidth);
frontProj_y=zeros(pheight,pwidth);

I_norm=MyImresize(I,pheight,pwidth,'bilinear');
I_norm_trans=ones(pheight,pwidth);
%figure,imshow(I_norm);

for i=1:length(pos.x)
    frontProj_x(pre.y(i),pre.x(i))=pos.y(i);
    frontProj_y(pre.y(i),pre.x(i))=pos.x(i);
    backProj_x(pos.y(i),pos.x(i))=pre.y(i);
    backProj_y(pos.y(i),pos.x(i))=pre.x(i);
end
%figure,imshow(frontProj_x);
OO=im2bw(backProj_x);
imwrite(OO,'./img/point_sp_filter.bmp');

% frontProj.x=frontProj_x;
% frontProj.y=frontProj_y;
% save('frontProj','frontProj');

[x,y]=find(frontProj_x>0);
start_x=x(1);   start_y=y(1);
h_step=x(2)-x(1);   w_step=y(1+power(length(x),0.5))-y(1);
end_x=start_x+(power(length(x),0.5)-1)*h_step;
end_y=start_y+(power(length(x),0.5)-1)*w_step;
for i=start_x:h_step:end_x-h_step
    for j=start_y:w_step:end_y-w_step       
        h_more=i+h_step;
        w_more=j+w_step;
        if(h_more>pheight)
            h_more=pheight;
        end
        if(w_more>pwidth)
            w_more=pwidth;
        end
        %fprintf('%d %d %d %d %d\n',i,j,h_more,w_more,pwidth);
        lu_x=i;
        lu_y=j;
        ru_x=i;
        ru_y=w_more;
        lb_x=h_more;
        lb_y=j;
        rb_x=h_more;
        rb_y=w_more;
        % get the transformation vector
        %tar_x=[lu_x;ru_x;lb_x;rb_x];
        %tar_y=[lu_y;ru_y;lb_y;rb_y];
        %M=[frontProj_x(lu_x,lu_y),frontProj_y(lu_x,lu_y),frontProj_x(lu_x,lu_y)*frontProj_x(lu_x,lu_y),1;
        %    frontProj_x(ru_x,ru_y),frontProj_y(ru_x,ru_y),frontProj_x(ru_x,ru_y)*frontProj_y(ru_x,ru_y),1;
        %    frontProj_x(lb_x,lb_y),frontProj_y(lb_x,lb_y),frontProj_x(lb_x,lb_y)*frontProj_y(lb_x,lb_y),1;
        %    frontProj_x(rb_x,rb_y),frontProj_y(rb_x,rb_y),frontProj_x(rb_x,rb_y)*frontProj_y(rb_x,rb_y),1];
        tar_x=[frontProj_x(lu_x,lu_y);frontProj_x(ru_x,ru_y);frontProj_x(lb_x,lb_y);frontProj_x(rb_x,rb_y)];
        tar_y=[frontProj_y(lu_x,lu_y);frontProj_y(ru_x,ru_y);frontProj_y(lb_x,lb_y);frontProj_y(rb_x,rb_y)];
        M=[lu_x,lu_y,lu_x*lu_y,1;
            ru_x,ru_y,ru_x*ru_y,1;
            lb_x,lb_y,lb_x*lb_y,1;
            rb_x,rb_y,rb_x*rb_y,1];
        M_inverse=inv(M);
        paramX=M_inverse*tar_x;
        paramY=M_inverse*tar_y;       
        % recover the block
        for ii=i:h_more
            for jj=j:w_more
                vec=[ii,jj,ii*jj,1];
                x_new=round(vec*paramX);
                y_new=round(vec*paramY);
                if(x_new<1)
                    x_new=1;
                end
                if(x_new>pheight)
                    x_new=pheight;
                end
                if(y_new<1)
                    y_new=1;
                end
                if(y_new>pwidth)
                    y_new=pwidth;
                end
                %fprintf('i j x_new y_new %d %d %d %d\n',ii,jj,x_new,y_new);
                I_norm_trans(ii,jj)=I_norm(x_new,y_new);
            end
        end
    end
end
I_norm_trans(1:start_x,1:pwidth)=I_norm(1:start_x,1:pwidth);
I_norm_trans(end_x:pheight,1:pwidth)=I_norm(end_x:pheight,1:pwidth);
I_norm_trans(1:pheight,end_y:pwidth)=I_norm(1:pheight,end_y:pwidth);
I2=MyImresize(I_norm_trans,imheight,imwidth,'bilinear');
end
