I=imread('MU.jpg');
J=rgb2gray(I);
E1=MyEdge(J,'roberts');
E2=MyEdge(J,'sobel');
E3=MyEdge(J,'prewitt');
E4=MyEdge(J,'marr');
E5=MyEdge(J,'canny');
imwrite(E1,'./img/roberts.jpg');
imwrite(E2,'./img/sobel.jpg');
imwrite(E3,'./img/prewitt.jpg');
imwrite(E4,'./img/marr.jpg');
imwrite(E5,'./img/canny.jpg');
figure,imshow(I);
title('Ô­Í¼Ïñ');
figure,imshow(E1);
title('roberts');
figure,imshow(E2);
title('sobel');
figure,imshow(E3);
title('prewitt');
figure,imshow(E4);
title('marr');
figure,imshow(E5);
title('canny');


