%% Compressing
clc
clear
close all
[x,fs] = audioread('M23.WAV');  %loading the audio
x = x';
dt = 1/fs;                       %period of sampling
t = 0:dt:(length(x)*dt)-dt;
%plotting
figure
plot(t,x)
title('Audio signal')
xlabel('time');ylabel('Amplitude')

frame = 25/1000;    % windowing interval
N = fs*frame;       % number of samples in an interval
row = ceil(length(x)/N);
col = N;
mem = 15;           %number of datas need to be saved regardless of pitch
bits = 20;          %quantization bits

sim('Compressing')

%% Reconstructing
load('data.mat')
data = data.Data;
[row,col] = size(data);
mem = col - 3;
N = data(1,end);
modified_x = zeros(1,row*N);
i = 1;
for i = 1:row
   sim('Reconstructing')
   modified_x((i-1)*N+1:i*N) = simout.signals.values;
end
figure;
plot(linspace(t(1), t(end), numel(modified_x)), modified_x)
title('Reconstructed signal')
xlabel('time');ylabel('Amplitude')

[freq,X] = Fourier_Transform(16000,modified_x);
figure
plot(freq,abs(X))
title('Reconstructed signal')
xlabel('frequency(HZ)');ylabel('Amplitude')

sound(modified_x,16000)
audiowrite('Test.wav',modified_x,16000)
%% Filtering
sim('Filtering')

filt_x = simout.signals.values;
figure;
plot(linspace(t(1), t(end), numel(filt_x)), filt_x)
title('Filtered Reconstructed signal')
xlabel('time');ylabel('Amplitude')

[freq,X] = Fourier_Transform(16000,filt_x);
figure
plot(freq,abs(X))
title('Filtered Reconstructed signal')
xlabel('frequency(HZ)');ylabel('Amplitude')

sound(filt_x,16000)
audiowrite('Test.wav',modified_x,16000)
