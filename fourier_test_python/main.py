import numpy as np
from matplotlib import pyplot as plt
import scipy.fftpack

# Change this params to see changes
noise_ampl = 10.0               # noise amplitude
freq = 20.0                   # real freq of signal
ampl = 3.0                     # amplitude of signal

# Data generation specifications
Fs = 1000.0                    # Sampling frequency
T = 1.0/Fs                     # Sampling period
L = 1000                     # Length of signal (number of samples)

def reconstruct_noisy_signal(noisy_signal, cut_max_percentage = 0.8):
    # Y = np.fft.fft(noisy_signal)
    Y = scipy.fftpack.fft(noisy_signal)

    value_to_zero = np.max( np.real(Y) ) * 0.8
    fY = Y
    fY[Y < value_to_zero] = 0

    # fY = Y
    ifY = scipy.fftpack.ifft(fY)
    cy = np.real(ifY)

    return cy

    

if __name__ == '__main__':

    # create time vector and cosine function with noise
    t = np.arange(L)*T  # Time vector
    noise = noise_ampl * (np.random.random_sample(t.shape[0])*2.0-1.0)    # Noise vector
    real_vals = ampl*np.cos(2*np.pi*freq*t)
    X = real_vals + noise

    
    X_recon = reconstruct_noisy_signal(X)

    # error
    err_fit = np.linalg.norm(X_recon - real_vals)
    err_fit_normalized = err_fit/L

    plt.plot(t, real_vals, label='real signal')
    plt.plot(t, X, label='noisy signal')
    plt.plot(t, X_recon, label='reconstructed signal. error: %f' % err_fit_normalized)
    plt.legend()
    plt.show()

