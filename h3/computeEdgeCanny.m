function computeEdgeCanny(I,t1,t2)
% I should be a grayscale image
[height,width]=size(I);
if(nargin<3)
    t1=0.1;
    t2=0.25;
end
%% step 1. use gauss filter to smooth the grayscale image
sigma=1.6;
gaussFilter= fspecial('gaussian',[5 5],sigma);
J=imfilter(I,gaussFilter,'replicate');
%% step 2. to compute gradient of four direction
op0=[-1,0,1;-1,0,1;-1,0,1]; % 0 degree
op2=op0';                   % 90 degree
op1=[0,1,1;-1,0,1;-1,-1,0]; % 45 degree
op3=[1,1,0;1,0,-1;0,-1,-1]; % 135 degree
Grad0=MaskEdge(J,op0);
Grad1=MaskEdge(J,op1);
Grad2=MaskEdge(J,op2);
Grad3=MaskEdge(J,op3);
%figure,imshow(Grad0);figure,imshow(Grad1);figure,imshow(Grad2);figure,imshow(Grad3);
%% step 3. non-maxmal supperssion (NMS)
Grad=zeros(height,width);
for i=2:height-1
    for j=2:width-1
        % 0 degree
        if(Grad0(i,j)<Grad0(i,j-1)||Grad0(i,j)<Grad0(i,j+1))
            Grad0(i,j)=0;
        end
        % 45 degree
        if(Grad1(i,j)<Grad1(i-1,j+1)||Grad1(i,j)<Grad1(i+1,j-1))
            Grad1(i,j)=0;
        end
        % 90 degree
        if(Grad2(i,j)<Grad2(i-1,j)||Grad2(i,j)<Grad2(i+1,j))
            Grad2(i,j)=0;
        end
        % 135 degree
        if(Grad3(i,j)<Grad3(i-1,j-1)||Grad3(i,j)<Grad3(i+1,j+1))
            Grad3(i,j)=0;
        end
        
        Grad(i,j)=max([Grad0(i,j),Grad1(i,j),Grad2(i,j),Grad3(i,j)]);
    end
end
%figure,imshow(Grad0);figure,imshow(Grad1);figure,imshow(Grad2);figure,imshow(Grad3);
%figure,imshow(Grad);
Real=im2bw(Grad,t1);
False=im2bw(Grad,t2);
figure,imshow(Real);figure,imshow(False);
%% step 4. to remove some pseudo edges use a strict threshold and a loose threshold
pre=Real;
pos=pre;
max_iter=0;
iter=0;
while true
    for i=2:height-1
        for j=2:width-1
            if(pre(i,j)==1)
                if(False(i-1,j-1)==1)
                    pos(i-1,j-1)=1;
                end
                if(False(i-1,j)==1)
                    pos(i-1,j)=1;
                end
                if(False(i-1,j+1)==1)
                    pos(i-1,j+1)=1;
                end
                if(False(i+1,j-1)==1)
                    pos(i+1,j-1)=1;
                end
                if(False(i+1,j)==1)
                    pos(i+1,j)=1;
                end
                if(False(i,j-1)==1)
                    pos(i,j-1)=1;
                end
                if(False(i,j+1)==1)
                    pos(i,j+1)=1;
                end
                if(False(i+1,j+1)==1)
                    pos(i+1,j+1)=1;
                end
            end
        end
    end
    iter=iter+1;
    if(isequal(pre,pos))
        break;
    end
    if(iter>max_iter)
        break;
    end
end
figure,imshow(pos);
end



