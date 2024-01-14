function filtered_signal = BPF(signal,fs)
    f_low = 0.5;
    f_high = 50;
    order = 2;

    [b,a] = butter(order,[f_low,f_high]/(fs/2),"bandpass");

    filtered_signal = filtfilt(b,a,signal);
end