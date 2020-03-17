clear; close all; clc;

load handel
y= y(:);
v = y;
tr_handel=length(y)/Fs;

n=length(y);
t=(tr_handel/n:tr_handel/n:tr_handel); t=t(:);
k=(1/tr_handel)*[0:(n-1)/2 -(n-1)/2:-1]; ks=fftshift(k);
%%
A = [100];
for i=1:length(A)
a=A(i);
times=200;
tslide=0:tr_handel/times:tr_handel;
Vgt_spec = zeros(length(tslide),n);

for j=1: length(tslide)    
    g=sin(-a*(t-tslide(j))).*(1./(t-tslide(j)));     
    Vg=g.*v;     
    Vgt=fft(Vg);     
    Vgt_spec(j,:) = fftshift(abs(Vgt)); % We don't want to scale it
end



subplot(1,1,i)
pcolor(tslide,ks,Vgt_spec.')
shading interp 
set(gca,'Ylim',[0 2000],'Fontsize',16) 
xlabel("Time [sec]"); ylabel("Frequency Hz");
colormap(hot)
end


