
% Change this params to see changes
noise_ampl = 10.0;               % noise amplitude
freq = 100;                   % real freq of signal
ampl = 3;                     % amplitude of signal


% Data generation specifications
Fs = 1000;                    % Sampling frequency
T = 1/Fs;                     % Sampling period
L = 1000;                     % Length of signal


% create time vector and cosine function with noise
t = (0:L-1)*T;                          % Time vector
noise = noise_ampl * randn(size(t));    % Noise vector
real_vals = ampl*cos(2*pi*freq*t);
X = real_vals + noise;


% For algorithm performance purposes, fft allows you to pad the input with trailing zeros.
% In this case, pad each row of X with zeros so that the length of each row is the next higher power of 2 from the current length.
% Define the new length using the nextpow2 function.
n = 2^nextpow2(L);

% Specify the dim argument to use fft along the rows of X, that is, for each signal.
dim = 2;

% Compute the Fourier transform of the signals.
Y = fft(X);

% Calculate the double-sided spectrum and single-sided spectrum of each signal.
P2 = abs(Y/L);
P1 = P2(1:n/2+1);
P1(2:end-1) = 2*P1(2:end-1);

frequencies = 0:(Fs/n):(Fs/2-Fs/n);
spec = P1(1:n/2);


% get frequency of signal
[argvalue, signal_frequency] = max(spec);
% dont know why
signal_frequency = signal_frequency - 1

X_rec = ifft(Y,n,dim);


value_to_zero = max( real(Y) ) / 1.5;
fY = Y;
fY(find(Y < value_to_zero)) = 0;

% fY = Y
ifY = ifft(fY);
cy = real(ifY);

% error
err_fit = norm(cy - real_vals)
err_fit_normalized = err_fit/L

%%% PLOTS

figure(1)
% Plot the first 100 entries from each row of X in a single figure in order and compare their frequencies.
subplot(2,1,1)
plot(t(1:100), X(1:100))
hold on
plot(t(1:100), real_vals(1:100))
hold off
legend('noisy signal', 'real signal')
title('signal visualization')
subplot(2,1,2)
plot(frequencies, spec)
title('frequency analysis')


figure(2)
subplot(2,1,1)
plot(t,real(Y),'--')
hold on
plot(t,real(fY),'-')
hold off
title('filter fft')
legend('fft with noise', 'fft filtered')

subplot(2,1,2)
plot(t(1:100),cy(1:100),'-x')
hold on
plot(t(1:100),real_vals(1:100),'-')
hold off
legend(sprintf('reconstructed signal, error %f',err_fit_normalized), 'real signal')
title('Signal reconstruction')

