function BW=MyBwmorph(bw,operation,se1,se2)
% operation= 'dilate' , 'erode', 'close','open', 'hitmiss'
BW=zeros(size(bw));
if(nargin<4 && strcmp(operation,'hitmiss'))
	fprtinf('not enough input \n');
end
if(nargin~=3 && ~strcmp(operation,'hitmiss'))
    fprintf('too much input\n');
end

if(strcmp(operation,'dilate'))
    BW=MyImdilate(bw,se1);
elseif(strcmp(operation,'erode'))
    BW=MyImerode(bw,se1);
elseif(strcmp(operation,'open'))
    BW=MyImdilate(MyImerode(bw,se1),se1);
elseif(strcmp(operation,'close'))
    BW=MyImerode(MyImdilate(bw,se1),se1);
elseif(strcmp(operation,'hitmiss'))
    bw1=MyImerode(bw,se1);
    bw2=MyImdilate(bw,se2);
    BW=zeros(size(bw));
    %figure,imshow(bw1);
    %figure,imshow(bw2);
    k=find(bw1==1&bw2==0);
    BW(k)=1;
else
    fprintf('operation not support!\n');
end
end