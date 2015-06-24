function [g,G]=MyFDFilter(I,METHOD,FLT,D0,n,W)
% METHOD specifies the frequency dormant operation method like high pass, low
% pass, band pass and band elimination.
% FLT specifies the filter
% D0 specifies the radius
% if bp or be, n is D1 actually
if(nargin<5)
    n=1;
elseif(nargin<6)
    W=10;
end
if((strcmp(METHOD,'be')==1)||(strcmp(METHOD,'bp')==1))
    D1=n;
end
if(length(size(I))==3)
    gray=rgb2gray(I);
else
    gray=I;
end
[M,N]=size(gray);
%% Fourier transform
P=2*M;
Q=2*N;
fc= zeros(M,N);
for x=1:1:M
    for y=1:1:N
        fc(x,y)=gray(x,y)*(-1)^(x+y);
    end
end
F=fft2(fc,P,Q);

%% frequency transformation
if(strcmp(METHOD,'hp')==1)
    H=ones(P,Q);
    % hp=high pass
    if(strcmp(FLT,'I')==1)
        % ideal
        for x=(-P/2):1:(P/2)-1
            for y=(-Q/2):1:(Q/2)-1
                D=(x^2 + y^2)^(0.5);
                if(D<=D0)
                    H(x+(P/2)+1,y+(Q/2)+1)=0;
                else
                    H(x+(P/2)+1,y+(Q/2)+1)=1;
                end
            end
        end
    elseif(strcmp(FLT,'B')==1)
        % Butterworth
        for x=(-P/2):1:(P/2)-1
            for y=(-Q/2):1:(Q/2)-1
                D=(x^2 + y^2)^(0.5);
                H(x+(P/2)+1,y+(Q/2)+1)=1/(1+(D0/D)^(2*n));
            end
        end
    elseif(strcmp(FLT,'E')==1)
        % exponential
        for x=(-P/2):1:(P/2)-1
            for y=(-Q/2):1:(Q/2)-1
                D=(x^2+y^2)^(0.5);
                H(x+(P/2)+1,y+(Q/2)+1)=exp(-1*((D0/D)^(2*n)));
            end
        end
    elseif(strcmp(FLT,'G')==1)
        % gauss
        for x=(-P/2):1:(P/2)-1
            for y=(-Q/2):1:(Q/2)-1
                D=(x^2+y^2)^(0.5);
                H(x+(P/2)+1,y+(Q/2)+1)=1-exp(-(D*D)/(2*D0*D0));
            end
        end
    else
        fprintf('high pass error: filter not supported\n');
    end
elseif(strcmp(METHOD,'lp')==1)
    % lp=low pass
    H=zeros(P,Q);
    if(strcmp(FLT,'I')==1)
        % ideal
        for x=(-P/2):1:(P/2)-1
            for y=(-Q/2):1:(Q/2)-1
                D=(x^2 + y^2)^(0.5);
                if(D<=D0)
                    H(x+(P/2)+1,y+(Q/2)+1)=1;
                else
                    H(x+(P/2)+1,y+(Q/2)+1)=0;
                end
            end
        end
    elseif(strcmp(FLT,'B')==1)
        % Butterworth
        for x=(-P/2):1:(P/2)-1
            for y=(-Q/2):1:(Q/2)-1
                D=(x^2+y^2)^(0.5);
                H(x+(P/2)+1,y+(Q/2)+1)=1/(1+(D/D0)^(2*n));
            end
        end
    elseif(strcmp(FLT,'E')==1)
        % exponential
        for x=(-P/2):1:(P/2)-1
            for y=(-Q/2):1:(Q/2)-1
                D=(x^2+y^2)^(0.5);
                H(x+(P/2)+1,y+(Q/2)+1)=exp(-1*((D/D0)^(2*n)));
            end
        end
    else
        fprintf('low pass error: filter not supported\n');
    end
elseif(strcmp(METHOD,'bp')==1)
    % bp=band pass
    H=ones(P,Q);
    if(strcmp(FLT,'I')==1)
        % ideal
        for x=(-P/2):1:(P/2)-1
            for y=(-Q/2):1:(Q/2)-1
                D=(x^2 + y^2)^(0.5);
                if(D>=D0&&D<D1)
                    H(x+(P/2)+1,y+(Q/2)+1)=1;
                else
                    H(x+(P/2)+1,y+(Q/2)+1)=0;
                end
            end
        end
    elseif(strcmp(FLT,'B')==1)
        % Butterworth
        for x=(-P/2):1:(P/2)-1
            for y=(-Q/2):1:(Q/2)-1
                D=(x^2+y^2)^(0.5);
                H(x+(P/2)+1,y+(Q/2)+1)=1/(1+((D*W)/((D*D)-(D0*D0)))^(2*n));
            end
        end
    elseif(strcmp(FLT,'E')==1)
        % exponential
    else
        fprintf('band pass error: filter not supported\n');
    end
elseif(strcmp(METHOD,'be')==1)
    % be=band elimination
    H=zeros(P,Q);
    if(strcmp(FLT,'I')==1)
        % ideal
        for x=(-P/2):1:(P/2)-1
            for y=(-Q/2):1:(Q/2)-1
                D=(x^2 + y^2)^(0.5);
                if(D>=D0&&D<D1)
                    H(x+(P/2)+1,y+(Q/2)+1)=0;
                else
                    H(x+(P/2)+1,y+(Q/2)+1)=1;
                end
            end
        end
    elseif(strcmp(FLT,'B')==1)
        % Butterworth
        for x=(-P/2):1:(P/2)-1
            for y=(-Q/2):1:(Q/2)-1
                D=(x^2+y^2)^(0.5);
                H(x+(P/2)+1,y+(Q/2)+1)=1/(1+((D*W)/((D0*D0)-(D*D)))^(2*n));
            end
        end
    else
        fprintf('band elimination error: filter not supported\n');
    end
else
    fpritnf('error: METHOR not supported\n');
end

G= H.* F;
%% Fourier inverse transform
g=real(ifft2(G));
g=g(1:1:M,1:1:N);
for x = 1:1:M
    for y = 1:1:N
        g(x,y) = g(x,y) * (-1)^(x+y);
    end
end
end

