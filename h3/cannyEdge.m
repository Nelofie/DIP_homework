function imagedata=cannyEdge(I)
%I is a grayscale image
%% gauss smooth
[row,line] = size(I);
temp = zeros(row+8,line+8);
imagedata = zeros(row,line);
% compute 9*9 gauss kernal
GaussianDieOff = .0001;
sigma = 1;
pw = 1:30; % possible widths
ssq = sigma^2;
width = find(exp(-(pw.*pw)/(2*ssq))>GaussianDieOff,1,'last');
if isempty(width)
  width = 1;  % the user entered a really small sigma
end
t = (-width:width);
gau = exp(-(t.*t)/(2*ssq))/(2*pi*ssq); 
kernel = gau' * gau;
kernel = im2single(kernel);

for q = 5:row+4 
    for p = 5:line+4
        temp(q,p) = I(q-4,p-4);
    end
end
for q = 1:row+8
    for p = 5:line+4
        if(q<5) 
            temp(q,p) = temp(5,p);
        end
        if(q>row+4) 
            temp(q,p) = temp(row+4,p); 
        end
    end
end
for q = 1:row+8
    for p = 1:line+8
        if(p<5) 
            temp(q,p) = temp(q,5); 
        end
        if(p>line+4) 
            temp(q,p) = temp(q,line+4); 
        end
    end
end
%% Convolution
for q = 1:row
    for p = 1:line
        for n = 1:9
            for m = 1:9
                imagedata(q,p) = imagedata(q,p) + kernel(n,m) * temp(q+n-1,p+m-1);
            end
        end
    end
end
%% compute Gradient of x direction and y direction
dx = zeros(size(I)); 
dy = zeros(size(I)); 
[x,y]=meshgrid(-width:width,-width:width);
dgau2D=-x.*exp(-(x.*x+y.*y)/(2*ssq))/(pi*ssq);
for q = 5:row+4
    for p = 5:line+4
        temp(q,p) = imagedata(q-4,p-4);
    end
end
for q = 1:row+8
    for p = 5:line+4
        if(q<5) 
            temp(q,p) = temp(5,p); 
        end
        if(q>row+4) 
            temp(q,p) = temp(row+4,p); 
        end
    end
end
for q = 1:row+8
    for p = 1:line+8
        if(p<5) 
            temp(q,p) = temp(q,5); 
        end
        if(p>line+4) 
            temp(q,p) = temp(q,line+4); 
        end
    end
end
for q = 1:row  % Convolution of X
    for p = 1:line
        for n = 1:9
            for m = 1:9
                dx(q,p) = dx(q,p) + dgau2D(n,m) * temp(q+n-1,p+m-1);
            end
        end
    end
end
dgau2D = dgau2D';
for q = 1:row  % Convolution of Y
    for p = 1:line
        for n = 1:9
            for m = 1:9
                dy(q,p) = dy(q,p) + dgau2D(n,m) * temp(q+n-1,p+m-1);
            end
        end
    end
end

%% compute the adaptative threshold
value = sqrt(dx.^2 + dy.^2);
value = double(value);
value = value/max(max(value));
temp_value = value;
counts=imhist(value, 64);
high_threshold = find(cumsum(counts) > 0.7*row*line,1,'first') / 64;
low_threshold = 0.4 * high_threshold;

%% use low and high threshold to link the edge
num = 0; 
flag = zeros(80000,2);     
temp_flag = zeros(80000,2); 
imagedata = zeros(row,line); 
% 0--0бу~45бу
% 1--45бу~90бу
% 2--90бу~135бу
% 3--135бу~180бу
direction = zeros(size(I));
for q = 2:row-1
    for p = 2:line-1
        if((dy(q,p)<=0 && dx(q,p)>-dy(q,p))  || (dy(q,p)>=0 && dx(q,p)<-dy(q,p)))
            d = abs(dy(q,p)/dx(q,p));  % 0бу-45бу
            gradmag = temp_value(q,p);
            gradmag1 = temp_value(q,p+1)*(1-d) + temp_value(q-1,p+1)*d; 
            gradmag2 = temp_value(q,p-1)*(1-d) + temp_value(q+1,p-1)*d;
        elseif((dx(q,p)>0 && -dy(q,p)>=dx(q,p))  || (dx(q,p)<0 && -dy(q,p)<=dx(q,p)))
            d = abs(dx(q,p)/dy(q,p));  % 45бу-90бу
            gradmag = temp_value(q,p);
            gradmag1 = temp_value(q-1,p)*(1-d) + temp_value(q-1,p+1)*d; 
            gradmag2 = temp_value(q+1,p)*(1-d) + temp_value(q+1,p-1)*d;
        elseif((dx(q,p)<=0 && dx(q,p)>dy(q,p)) || (dx(q,p)>=0 && dx(q,p)<dy(q,p)))
            d = abs(dx(q,p)/dy(q,p));  % 90бу-135бу
            gradmag = temp_value(q,p);
            gradmag1 = temp_value(q-1,p)*(1-d) + temp_value(q-1,p-1)*d; 
            gradmag2 = temp_value(q+1,p)*(1-d) + temp_value(q+1,p+1)*d;
        elseif((dy(q,p)<0 && dx(q,p)<=dy(q,p)) || (dy(q,p)>0 && dx(q,p)>=dy(q,p)))
            d = abs(dy(q,p)/dx(q,p));  % 135бу-180бу
            gradmag = temp_value(q,p);
            gradmag1 = temp_value(q,p-1)*(1-d) + temp_value(q-1,p-1)*d; 
            gradmag2 = temp_value(q,p+1)*(1-d) + temp_value(q+1,p+1)*d;
        end
        if(gradmag>=gradmag1 && gradmag>=gradmag2)
            if(gradmag >= high_threshold)
                value(q,p) = 255;
            elseif(gradmag >= low_threshold)
                value(q,p) = 125;
            else
                value(q,p) = 0; 
            end
        else
            value(q,p) = 0; % NMS
        end
    end 
end
for q = 2:row-1     
    for p = 2:line-1
        if(value(q,p) == 255)
            imagedata(q,p) = 255;
            if(value(q-1,p-1) == 125)
                value(q-1,p-1) = 255;
                imagedata(q-1,p-1) = 255;
                if((q-1 > 1) && (p-1 > 1))
                    num = num + 1;
                    flag(num,1) = q-1;
                    flag(num,2) = p-1;
                end
            end
            if(value(q-1,p) == 125)
                value(q-1,p) = 255;
                imagedata(q-1,p) = 255;
                if(q-1 > 1)
                    num = num + 1;
                    flag(num,1) = q-1;
                    flag(num,2) = p;
                end
            end
            if(value(q-1,p+1) == 125)
                value(q-1,p+1) = 255;
                imagedata(q-1,p+1) = 255;
                if((q-1 > 1) && (p+1 < line))
                    num = num + 1;
                    flag(num,1) = q-1;
                    flag(num,2) = p+1;
                end
            end
            if(value(q,p-1) == 125)
                value(q,p-1) = 255;
                imagedata(q,p-1) = 255;
                if(p-1 > 1)
                    num = num + 1;
                    flag(num,1) = q;
                    flag(num,2) = p-1;
                end
            end
            if(value(q,p+1) == 125)
                value(q,p+1) = 255;
                imagedata(q,p+1) = 255;
                if(p+1 < line)
                    num = num + 1;
                    flag(num,1) = q;
                    flag(num,2) = p+1;
                end
            end
            if(value(q+1,p-1) == 125)
                value(q+1,p-1) = 255;
                imagedata(q+1,p-1) = 255;
                if((q+1 < row) && (p-1 > 1))
                    num = num + 1;
                    flag(num,1) = q+1;
                    flag(num,2) = p-1;
                end
            end
            if(value(q+1,p) == 125)
                value(q+1,p) = 255;
                imagedata(q+1,p) = 255;
                if(q+1 < row)
                    num = num + 1;
                    flag(num,1) = q+1;
                    flag(num,2) = p;
                end
            end
            if(value(q+1,p+1) == 125)
                value(q+1,p+1) = 255;
                imagedata(q+1,p+1) = 255;
                if((q+1 < row) && (p+1 < line))
                    num = num + 1;
                    flag(num,1) = q+1;
                    flag(num,2) = p+1;
                end
            end
        end
    end
end
done = num; 
while done ~= 0
    num = 0;
    for temp_num = 1:done
        q = flag(temp_num,1);
        p = flag(temp_num,2);
        if(value(q-1,p-1) == 125)
            value(q-1,p-1) = 255;
            imagedata(q-1,p-1) = 255;
            if((q-1 > 1) && (p-1 > 1))
                num = num + 1;
                temp_flag(num,1) = q-1;
                temp_flag(num,2) = p-1;
            end
        end
        if(value(q-1,p) == 125)
            value(q-1,p) = 255;
            imagedata(q-1,p) = 255;
            if(q-1 > 1)
                num = num + 1;
                temp_flag(num,1) = q-1;
                temp_flag(num,2) = p;
            end
        end
        if(value(q-1,p+1) == 125)
            value(q-1,p+1) = 255;
            imagedata(q-1,p+1) = 255;
            if((q-1 > 1) && (p+1 < line))
                num = num + 1;
                temp_flag(num,1) = q-1;
                temp_flag(num,2) = p+1;
            end
        end
        if(value(q,p-1) == 125)
            value(q,p-1) = 255;
            imagedata(q,p-1) = 255;
            if(p-1 > 1)
                num = num + 1;
                temp_flag(num,1) = q;
                temp_flag(num,2) = p-1;
            end
        end
        if(value(q,p+1) == 125)
            value(q,p+1) = 255;
            imagedata(q,p+1) = 255;
            if(p+1 < line)
                num = num + 1;
                temp_flag(num,1) = q;
                temp_flag(num,2) = p+1;
            end
        end
        if(value(q+1,p-1) == 125)
            value(q+1,p-1) = 255;
            imagedata(q+1,p-1) = 255;
            if((q+1 < row) && (p-1 > 1))
                num = num + 1;
                temp_flag(num,1) = q+1;
                temp_flag(num,2) = p-1;
            end
        end
        if(value(q+1,p) == 125)
            value(q+1,p) = 255;
            imagedata(q+1,p) = 255;
            if(q+1 < row)
                num = num + 1;
                temp_flag(num,1) = q+1;
                temp_flag(num,2) = p;
            end
        end
        if(value(q+1,p+1) == 125)
            value(q+1,p+1) = 255;
            imagedata(q+1,p+1) = 255;
            if((q+1 < row) && (p+1 < line))
                num = num + 1;
                temp_flag(num,1) = q+1;
                temp_flag(num,2) = p+1;
            end
        end
    end
    done = num;
    flag = temp_flag;
end
imagedata = uint8(imagedata);
end