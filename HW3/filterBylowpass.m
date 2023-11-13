close all;
clear all;

ecg = load("ecg_hfn.dat");
slen = length(ecg);
fs = 1000;


lowpass_result=lowpass(ecg,60,fs);
figure
subplot(211)
plot((1:slen)/fs, ecg);
axis tight;
xlabel('Time in seconds');
ylabel('ECG');
subplot(212)
plot((1:slen)/fs, lowpass_result);
axis tight;
xlabel('Time in seconds');
ylabel('ECG after lowpass filter');


figure
fs = 1000;
slen = length(lowpass_result);
x=fft(lowpass_result);
f=(0:slen-1)*(fs/slen);
power=abs(x).^2/slen;
figure
subplot(211)
axis tight;
xlabel('Time in seconds');
ylabel('ECG');
subplot(212)
plot(f,10*log10(power));
axis([0 500 -105 50]);
xlabel('Hz')
ylabel('dB')

title("PSD after lowpass filter")


[H,f] = freqz(lowpass_result,ecg);
figure;
plot(f, 10*log10(H));
title('滤波器幅度响应');
xlabel('频率 (Hz)');
ylabel('幅度');
