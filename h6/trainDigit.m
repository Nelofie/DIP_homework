function cenD=trainDigit(train_img_path)
[I,map]=imread(train_img_path);
I=~I;
%imshow(I);
I=bwmorph(I,'thin',Inf);
I=imdilate(I, ones(3,3));
[L,trash]=bwlabel(I);
cenD=regionprops(L,'Image','Centroid');
end