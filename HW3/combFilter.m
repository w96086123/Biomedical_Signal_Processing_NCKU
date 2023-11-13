close all;
clear all;
run('ecg_hfn.m')
% 利用傅立葉轉換得出頻譜圖
x = fft(ecg);
f = (0:slen-1)*(fs/slen);
power = abs(x) .^2/slen;
% 未利用comb filter時得出的結果
figure
subplot(211)
plot(t,ecg)
axis tight;
xlabel("Time in seconds");
ylabel("ECG");
subplot(212);
plot(f,10*log10(power));
axis([0 500 -105 50]);
xlabel('Hz')
ylabel('dB')
% 利用comb filter時得出的結果
nfft=1024;
h_comb=[0.631 -0.2149 0.1512 -0.1288 0.1227 -0.1288 0.1512 -0.2149 0.6310];
comb=conv(ecg, h_comb);
Y_comb=fft(comb(1:slen));
PS_comb=abs(Y_comb).^2;
PS_comb=PS_comb/PS_comb(1);
figure
subplot(211)
plot((1:slen)/fs,comb(1:slen))
axis tight;
xlabel('Time in seconds');
ylabel('ECG after Comb filter');
subplot(212)
plot(f,10*log10(PS_comb(1:slen)));
axis([0 500 -105 50])
xlabel('Hz');
ylabel('dB');
title("PSD after comb filter");

figure
subplot(211)
plot((1:slen)/fs,ecg)
axis tight;
xlabel('Time in seconds');
ylabel('ECG');
subplot(212)
plot((1:slen)/fs,comb(1:slen));
axis tight
xlabel('Time in seconds');
ylabel('ECG after Comb filter');
