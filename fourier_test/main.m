Fs = 1000;                    % Sampling frequency
T = 1/Fs;                     % Sampling period
L = 1000;                     % Length of signal
t = (0:L-1)*T;                % Time vector
noise_ampl = 1.0;               % noise amplitude


noise = noise_ampl * randn(size(t)); % Noise vector

% Create a matrix where each row represents a cosine wave with scaled frequency. The result, X, is a 3-by-1000 matrix.
% The first row has a wave frequency of 50, the second row has a wave frequency of 150,
% and the third row has a wave frequency of 300.

real_vals = cos(2*pi*50*t);

X = real_vals + noise;          % First row wave
% X = real_vals


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
signal_frequency



X_rec = ifft(Y,n,dim);

value_to_zero = 100;

%% better with find
% fY = fix( Y/value_to_zero )*value_to_zero;

fY = Y;
fY(find(Y < value_to_zero)) = 0;

max( Y )
max( fY )

% fY = Y
ifY = ifft(fY);
cy = real(ifY);

%%% PLOTS

figure(1)
% Plot the first 100 entries from each row of X in a single figure in order and compare their frequencies.
subplot(2,1,1)
plot(t(1:100), X(1:100))
title(['Row ',num2str(i),' in the Time Domain'])
subplot(2,1,2)
plot(frequencies, spec)
title(['Row ',num2str(i),' in the Frequency Domain'])


figure(2)

subplot(2,1,1)
plot(t,real(Y),'--')
hold on
plot(t,real(fY),'-')
hold off
title('filter fft')
legend('fft with noise', 'fft filtered')

subplot(2,1,2)
plot(t(1:100),cy(1:100),'--')
hold on
plot(t(1:100),real_vals(1:100),'-')
hold off
legend('reconstructed signal', 'real signal')
title(['Row ',num2str(i),' in the Time Domain'])

