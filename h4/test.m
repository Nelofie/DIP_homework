clear;
warning off;
I=imread('test.png');
bw=im2bw(I);
%figure,imshow(bw);

% call imdilate
se=ones(3);
se(1,3)=0;
dila1=imdilate(bw,se);
dila2=MyImdilate(bw,se);
fprintf('matlab imdilate vs. MyImdilate. Is equal? %d\n',isequal(dila1,dila2));

% call imerode
se=ones(3);
se(1,3)=0;
erode1=imerode(bw,se);
erode2=MyImerode(bw,se);
fprintf('matlab imerode vs. MyImerode. is equal? %d\n',isequal(erode1,erode2));

% call hitmiss
HMbw=im2bw(imread('testhitmiss.png'));
se1=zeros(5);
se1(2:4,2:4)=1;
se2=ones(5);
se2(2:4,2:4)=0;
HM1=bwhitmiss(HMbw,se1,se2);
HM2=MyBwmorph(HMbw,'hitmiss',se1,se2);
imwrite(HM1,'myhm.png');
fprintf('matlab bwhitmiss vs. MyBwmorph(operation=hitmiss). Is equal? %d\n',isequal(HM1,HM2));


% call MyBwthin
word_bw=im2bw(imread('word_bw.bmp'));
word_thin=MyBwthin(word_bw);
imwrite(word_thin,'word_thin.png');
figure,imshow(word_thin);

