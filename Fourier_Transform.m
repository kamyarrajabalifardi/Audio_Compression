%//////////////inputs/////////////////////////////////
%t = time   fs = sample rate    f = a set of functions
%//////////////outputs////////////////////////////////
%F = fft of f   freq = frequency domain
function [freq,F]= Fourier_Transform(fs,f)
    s = fft(f(1,:));
    X = fftshift(s);
    X = X/fs;
    freq = linspace(-fs/2,fs/2,numel(abs(X)));
    [m,~] = size(f);
    if m == 1
       F = X; 
    end
    if m ~= 1
        F = zeros(m,length(freq));
        for i = 1:m
            s = fft(f(i,:));
            F(i,:) = fftshift(s);
            F(i,:) = F(i,:)/fs;  
        end
    end
end

