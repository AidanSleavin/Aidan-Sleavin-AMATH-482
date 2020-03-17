clear; close all; clc;

[y,Fs] = audioread("music1.wav");
tr_piano=length(y)/Fs; % record time in seconds
%plot((1:length(y))/Fs,y);
%xlabel("Time [sec]"); ylabel("Amplitude");
%title("Mary had a little lamb (piano)");
%p8 = audioplayer(y,Fs); playblocking(p8);


n=length(y);
t=linspace(0,tr_piano,n+1); t=t(1:n);t=t(:);
k=(1/tr_piano)*[0:n/2-1 -n/2:-1]; ks=fftshift(k);
%%
close; clear all; clc;
[y,Fs] = audioread("music2.wav");
tr_piano=length(y)/Fs; % record time in seconds
%plot((1:length(y))/Fs,y);
%xlabel("Time [sec]"); ylabel("Amplitude");
%title("Mary had a little lamb (piano)");
%p8 = audioplayer(y,Fs); playblocking(p8);


n=length(y);
t=linspace(0,tr_piano,n+1); t=t(1:n);t=t(:);
k=(1/tr_piano)*[0:n/2-1 -n/2:-1]; ks=fftshift(k);
%%
close; clear all; clc;
[y,Fs] = audioread("flat.wav");
y=y(:,2);
tr_piano=length(y)/Fs; % record time in seconds
%plot((1:length(y))/Fs,y);
%xlabel("Time [sec]"); ylabel("Amplitude");
%title("Mary had a little lamb (piano)");
%p8 = audioplayer(y,Fs); playblocking(p8);


n=length(y);
t=linspace(0,tr_piano,n+1); t=t(1:n);t=t(:);
k=(1/tr_piano)*[0:n/2-1 -n/2:-1]; ks=fftshift(k);
%%
a = 150;
times=100;
start=0;
tslide=start:(tr_piano-start)/times:tr_piano;
Vgt_spec = zeros(length(tslide),n);
%%
for j=1:length(tslide)    
    g=exp(-a*(t-tslide(j)).^2);     
    Vg=g.*y; 
    Vgt=fft(Vg);     
    Vgt_spec(j,:) = fftshift(abs(Vgt)); % We don't want to scale it
end
%%

%%
pcolor(tslide,ks,Vgt_spec.')
shading interp 
set(gca,'Ylim',[0 2500],'Fontsize',16) 
colormap(hot)
xlabel("Time [sec]"); ylabel("Frequency Hz");
title("Piano a=150 100 time steps");








