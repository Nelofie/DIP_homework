
I=im2double(imread('./img/tiger_sp.bmp'));
J=im_calibration();
filtered=im2double(imread('./img/point_sp_filter.bmp'));
pim=im2bw(imread('./img/point.bmp'));

figure,
subplot(2,2,1),imshow(pim*-1+1);
subplot(2,2,2),imshow(filtered);
subplot(2,2,3),imshow(I);
subplot(2,2,4),imshow(J);
