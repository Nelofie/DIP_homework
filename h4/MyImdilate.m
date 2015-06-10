function BW=Myimdilate(bw,se)
BW=zeros(size(bw));
[height,width]=size(bw);
[se_height,se_width]=size(se);
if(mod(se_height,2)==1)
    se_mid_h=ceil(se_height/2);
else
    fprintf('not supported se\n');
    return;
end

if(mod(se_width,2)==1)
    se_mid_w=ceil(se_width/2);
else
    fprintf('not supported se\n');
    return;
end

for se_x=1:se_height
    for se_y=1:se_width
        if(se(se_x,se_y)==1)
            BW=BW|pan(bw,se_x-se_mid_h,se_y-se_mid_w);
        end
    end
end

end

function BW=pan(bw,x_offset,y_offset)
BW=zeros(size(bw));
[height,width]=size(bw);
[x,y]=find(bw==1);
new_x=x+x_offset;
new_y=y+y_offset;
for i=1:length(new_x)
    temp_x=new_x(i);
    temp_y=new_y(i);
    if(temp_x>height||temp_x<1||temp_y>width||temp_y<1)
        continue;
    end
    BW(temp_x,temp_y)=1;
end

end