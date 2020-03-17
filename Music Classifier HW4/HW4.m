clear; close all; clc;
%%
[y,Fs] = audioread("ETrial1.MP3");
cut=3;
Fs=Fs/cut;
y=y(:,1);
y=y(1:cut:end);
time=5;
y1= y(  length(y)/4:  length(y)/4+time*Fs);
y2= y(2*length(y)/4:2*length(y)/4+time*Fs);
y3= y(3*length(y)/4:3*length(y)/4+time*Fs);
t=linspace(0,5,length(y1)+1); t=t(1:length(y1));t=t(:);
k=(1/5)*[0:(length(y1)-1)/2 -(length(y1)-1)/2:-1]; ks=fftshift(k);

%%
p8 = audioplayer(y2,Fs);
playblocking(p8);

%%
a = 150;
times=150;

tslide=0:time/times:time;
Vgt_spec = zeros(length(tslide),length(y1));

for j=1:length(tslide)    
    g=exp(-a*(t-tslide(j)).^2);     
    Vg=g.*y3; 
    Vgt=fft(Vg);     
    Vgt_spec(j,:) = fftshift(abs(Vgt)); % We don't want to scale it
end

ET3 =Vgt_spec(:,:);
%%
[U,S,V] = svd(NCSI1, 'econ');

amount = 1;
a=U(:,1:amount)*S(1:amount,1:amount)*V(:,1:amount)';

s = diag(S);
plot(1:length(s),s,'ro');
xlabel(""); ylabel("Singular Value");
%%
%subplot(2,2,1);
pcolor(tslide,ks,ES1.')
shading interp 
set(gca,'Ylim',[0 2300],'Fontsize',16) 
colormap(hot)
%xlabel("Time [sec]"); ylabel("Frequency Hz");
title("NCSMH1");
%%
feature = 20;
[U,S,V] = svd([
    NCSI3, NCSI2, NCSI1, NCSMH1, NCSMH2, NCSMH3, 
    ES1, ES2, ES3 , ET1, ET2, ET3,  
    TPAG1, TPAG2, TPAG3 , TPRD1, TPRD2, TPRD3   ], 'econ');
songs = S*V';
U = U(:, 1:feature);
nNCS = 6; nE= 6; nTP= 6;
NCS = songs(1:feature, 1:nNCS);
E = songs(1:feature, nNCS+1: nNCS+nE);
TP = songs(1:feature, nNCS+nE+1: nNCS+nE+nTP);
mNCS= mean(NCS,2);
mE= mean(E,2);
mTP= mean(TP,2);
hold on
plot(1:nNCS               , NCS(1:feature,1:nNCS )  ,'ro');
plot(nNCS+1:nE+nNCS       , E(1:feature,1:nE)         ,'bo');
plot(1+nE+nNCS:nTP+nE+nNCS, TP(1:feature,1:nTP)      ,'go');



%%
Sw=0;
for k=1:nNCS
    Sw = Sw + (NCS(:,k)-mNCS)*(NCS(:,k)-mNCS)';
end
for k=1:nE
    Sw = Sw + (E(:,k)-mE)*(E(:,k)-mE)';
end
for k=1:nTP
    Sw = Sw + (TP(:,k)-mTP)*(TP(:,k)-mTP)';
end

Sb = (mNCS-mE)*(mNCS-mE)';
[V2, D] = eig(Sb, Sw);
[~, ind] = max(abs(diag(D)));
w = V2(:,ind); w = w/norm(w,2);

vNCS = w' * NCS;
vE = w' * E;
vTP = w' * TP;

%%
hold on
[U,S,V] = svd(TPAG1, 'econ');
plot(21:40,V(1:20,1:30),'bo')
[U,S,V] = svd(ES1, 'econ');
plot(41:60,V(1:20,1:30),'go')






