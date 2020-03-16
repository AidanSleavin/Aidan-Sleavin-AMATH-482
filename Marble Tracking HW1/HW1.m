clear; close all; clc;
load Testdata

L=15; % spatial domain
n=64; % Fourier modes
x2=linspace(-L,L,n+1); x=x2(1:n); y=x; z=x;
k=(2*pi/(2*L))*[0:(n/2-1) -n/2:-1]; ks=fftshift(k);

[X,Y,Z]=meshgrid(x,y,z);
[Kx,Ky,Kz]=meshgrid(k,k,k);


ave=zeros(n,n,n);%creates array to turn into average
for j=1:20
    Un(:,:,:)=reshape(Undata(j,:),n,n,n);
    Unt=fftn(Un);%makes an FFT
    ave = ave+Unt;%adds the FFT to the average
end
ave = abs(ave)./20;

[C,I] = max(ave(:)) %C is max value I is the location index
Xo=Kx(I)
Yo=Ky(I)
Zo=Kz(I)

%this creates a number for the average magnatude of all points in frequency
%space so for a sanity check one can see that C is in deed much greater
%than the background noise
avemag=0;
timesthrough=0;
for i= 1:n*n*n
    avemag= avemag+ave(i);
end
avemag=avemag/(n*n*n)


%this creates a filter for the data at point Xo,Yo,Zo
tau=.3;
Filter= exp(-tau*((Kx-Xo).^2+(Ky-Yo).^2+(Kz-Zo).^2));

%creating positons for the marble in different times
Xm=zeros(1,20);
Ym=zeros(1,20);
Zm=zeros(1,20);

%goes through each of the 20 time points takes the FFT applies the filter
%then uses iFFT to get a clear location on the marble
for j=1:20
    Un(:,:,:)=reshape(Undata(j,:),n,n,n);
    Unt=fftn(Un);
    UnFt=Unt.*Filter;
    UnF=abs(ifftn(UnFt));
    [M,Im] = max(UnF(:));%Im is the marble index location in space
    Xm(1,j)=X(Im);
    Ym(1,j)=Y(Im);
    Zm(1,j)=Z(Im);
    isosurface(X,Y,Z,abs(UnF),.5)%plotting the marble as an isosurfate
    axis([-20 20 -20 20 -20 20]), grid on, drawnow
    hold on
end


%plotting path as well as start in green and end in red
plot3(Xm,Ym,Zm,'linewidth',2)
hold on
plot3(Xm(20),Ym(20),Zm(20),'ro',Xm(1),Ym(1),Zm(1),'go')
axis([-15 15 -15 15 -15 15]), grid on, drawnow
xlabel('Xpos')
ylabel('Ypos')
zlabel('Zpos')














