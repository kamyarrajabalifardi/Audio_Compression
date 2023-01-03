clc
clear
close all
[x,fs] = audioread('M23.WAV');  %loading the audio
x = x';
dt = 1/fs;                       %period of sampling
t = 0:dt:(length(x)*dt)-dt;
frame = 25/1000;
N = fs*frame;
row = ceil(length(x)/N);
col = N;
y = [x,zeros(1,col*row-length(x))];
part_x = zeros(row,col);
w = hamming(col)';
for i = 1:row
    part_x(i,:) = y((i-1)*col+1:(i)*col).* w; 
end

mem = 15;
data = zeros(row,mem + 2 + 1);
for i = 1:row
   [temp1,~] = rceps(part_x(i,:)); 
   temp2 = temp1(1:col/2);
   data(i,1:mem) = temp2(1:mem);
   temp2(1:mem) = 0;
   [data(i,mem+1),data(i,mem+2)] = max(temp2);
   data(i,mem + 3) = col;
end

bits = 16;
B = bits -1;
Xm = max(max(abs(data)));
delta = Xm/2^B;
data(:,1:mem+1) = delta.*round(data(:,1:mem+1)./delta);


save('data.mat','data')
clear all
%%
clc
clear
close all
load('data.mat')
[row,col] = size(data);
mem = col - 3;
N = data(1,end);

C_x = zeros(row,N);
C_x(:,1:mem) = data(:,1:mem);
for i = 1:2
    C_x(i,data(i,mem+2)) = data(i,mem+1); 
end
C_x = 2.*C_x;
C_x(:,1) = C_x(:,1)./2;
C_x(:,N/2) = C_x(:,N/2)./2;

x = zeros(1,row*N);
for i = 1:row
    temp = icceps(C_x(i,:),0);
    x(i*N:(i+1)*N-1) = temp;
end

[freq,X] = Fourier_Transform(16000,x);
plot(freq,abs(X))

sound(x,16000);