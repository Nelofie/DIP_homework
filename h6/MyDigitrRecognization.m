% paths
test_path='number.bmp';
train_path='train.bmp';
% read imgs
[I,map]=imread(test_path);
I=ind2gray(I,map);
threshold=180/255;
I=im2bw(I,threshold);
I=~I;

% propocessing
se=strel('disk',5);
I2 = imclose(I,se);
I2(333,296)=0;
I2=bwmorph(I2,'thin',Inf);
[L,num]=bwlabel(I2);

% get centroid
cenD=regionprops(L,'Image','Centroid');
len=length(cenD);
r.Centroid=[cenD.Centroid];
r.digit=zeros(len,1);
tmp_moments=zeros(10,1);

train_result=trainDigit(train_path);
for i=1:10
     train_moments(i,:)=MyInvmoments(train_result(i).Image);
end;

figure,
for i=1:len;
    [m,n]=size(cenD(i).Image);
    cenD(i).Image=imdilate(cenD(i).Image,ones(3,3));
    subplot(3,4,i);
    imshow(cenD(i).Image);
end;

figure,
for i=1:len
    test_moments(i,:)=MyInvmoments(cenD(i).Image); 
    temp=abs(train_moments(:,4)-test_moments(i,4));
    [a,b]=min(temp);
    index(i)=b;
    subplot(3,4,i);
    imshow(train_result(index(i)).Image);
end





