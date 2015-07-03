function phi=MyInvmoments(I)
% Visual Pattern Recognition by Moment Invariants
% from Hu's book
I=double(I);
[height,with]=size(I);
[X,Y]=meshgrid(1:height,1:with);
X=X(:);
Y = Y(:);
I = I(:);
m.m00 = sum(I);
m.m10 = sum(X.*I);
m.m01 = sum(Y.*I);
m.m11 = sum(X.*Y.*I);
m.m20 = sum(X.^2.*I);
m.m02 = sum(Y.^2.*I);
m.m30 = sum(X.^3.*I);
m.m03 = sum(Y.^3.*I);
m.m12 = sum(X.*Y.^2.*I);
m.m21 = sum(X.^2.*Y.*I);

xbar = m.m10/m.m00;
ybar = m.m01/m.m00;
e.eta11 = (m.m11 - ybar*m.m10) / m.m00^2;
e.eta20 = (m.m20 - xbar*m.m10) / m.m00^2;
e.eta02 = (m.m02 - ybar*m.m01) / m.m00^2;
e.eta30 = (m.m30 - 3*xbar*m.m20 + 2*xbar^2*m.m10) / m.m00^2.5;
e.eta03 = (m.m03 - 3*ybar*m.m02 + 2*ybar^2*m.m01) / m.m00^2.5;
e.eta21 = (m.m21 - 2*xbar*m.m11 -ybar*m.m20 + 2*xbar^2*m.m01) / m.m00^2.5;
e.eta12 =  (m.m12 - 2*ybar*m.m11 -xbar*m.m02 + 2*ybar^2*m.m10) / m.m00^2.5;

phi(1) = e.eta20 + e.eta02;
phi(2) = (e.eta20 - e.eta02)^2 + 4*e.eta11^2;
phi(3) = (e.eta30 - 3*e.eta12)^2 + (3*e.eta21 - e.eta03)^2;
phi(4) = (e.eta30 + e.eta12)^2 + (e.eta21 + e.eta03)^2;

phi(5) = (e.eta30 - 3*e.eta12)*(e.eta30 + e.eta12)*...
        ((e.eta30 + e.eta12)^2 - 3*(e.eta21 + e.eta03)^2)+...
        (3*e.eta21 - e.eta03)*(e.eta21 + e.eta03)*...
        (3*(e.eta30 + e.eta12)^2 - (e.eta21 + e.eta03)^2);
phi(6) = (e.eta20 - e.eta02) * ((e.eta30 + e.eta12)^2-...
    (e.eta21 + e.eta03)^2)+...
    4*e.eta11*(e.eta30 + e.eta12)*(e.eta21 + e.eta03);
phi(7) = (3*e.eta21 - e.eta03) * (e.eta30 + e.eta12) * ...
        ( (e.eta30 + e.eta12)^2 - 3*(e.eta21 + e.eta03)^2) +...
         (3*e.eta12 - e.eta30)*(e.eta21 + e.eta03)*...
         (3*(e.eta30 + e.eta12)^2 - (e.eta21 + e.eta03)^2);
end