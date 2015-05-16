function im_register(P,SP)
%% label the points by order and save the matched points to .mat file
% label the deformated photo first and the previous photo then
if(nargin<2)
    P=imread('./img/point.bmp');
    SP=imread('./img/point_sp.bmp');
end

p_bw=im2bw(P);
sp_bw=bwmorph((im2bw(SP)*-1+1),'shrink');

[height,width]=size(sp_bw);
% mark the point use human interaction
sp_bw=sp_bw*-1+1;
quarter_sp=sp_bw(1:height/2,1:width/2);
quarter_p=p_bw(1:height/2,1:width/2);

figure,imshow(quarter_sp);
[x,y]=ginput;
x_comp=x*-1+129;
y_comp=y*-1+129;
x=[x' x' x_comp' x_comp'];
y=[y' y_comp' y' y_comp'];
pos.x=x;
pos.y=y;
%save('pos.mat','pos');

figure,imshow(quarter_p);
[x,y]=ginput;
% according to left-up quarter to fill the last 3 quarters
x_comp=x*-1+129;
y_comp=y*-1+129;
x=[x' x' x_comp' x_comp'];
y=[y' y_comp' y' y_comp'];
pre.x=x;
pre.y=y;
%save('pre.mat','pre');

end