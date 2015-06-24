% gray=im2double(imread('./imgs/lena_noise.bmp'));
% g=MyFDFilter(gray,'lp','I',10);
% imwrite(g,'./imgs/lp_Ideal_10.bmp');
% figure,imshow(g);

% gray=im2double(imread('./imgs/lena_blur.bmp'));
% g=MyFDFilter(gray,'hp','B',5);
% figure,imshow(g+gray);
% figure,imshow(gray);
% imwrite(g+gray,'./imgs/hp_BTWS_5.bmp');

