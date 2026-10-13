function [f, amp] = myFFT(x, Fs)

    x = x(:);
    x = x - mean(x);   % remove DC
    
    N = length(x);
    X = fft(x);
    
    f = Fs*(0:(N/2))/N;
    
    amp = abs(X/N);
    amp = amp(1:N/2+1);
    amp(2:end-1) = 2*amp(2:end-1);

end