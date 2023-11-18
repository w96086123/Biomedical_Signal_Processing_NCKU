close all;
clear all;
run('ecg_hfn.m')

template = ecg(1:800);
tlen = 800;

% 利用傅立葉轉換得出頻譜圖
x = fft(template);
f = (0:tlen-1)*(fs/tlen);
power = abs(x) .^2/tlen;
% 未利用comb filter時得出的結果
figure
subplot(211)
plot(template)
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
comb=conv(template, h_comb);
Y_comb=fft(comb(1:tlen));
PS_comb=abs(Y_comb).^2;
PS_comb=PS_comb/PS_comb(1);

% 由comb filter之後的template當作wiener filter的model
b = weiner_hopf(ecg,comb,800);
b = filter(b,1,ecg);


figure
subplot(211)
plot((1:tlen)/fs,comb(1:tlen))
axis tight;
xlabel('Time in seconds');
ylabel('ECG after Comb filter');
subplot(212)
plot(f,10*log10(PS_comb(1:tlen)));
axis([0 500 -105 50])
xlabel('Hz');
ylabel('dB');
title("PSD after comb filter");

figure
subplot(311)
plot((1:tlen)/fs,template)
axis tight;
xlabel('Time in seconds');
ylabel('ECG');
subplot(312)
plot((1:tlen)/fs,comb(1:tlen));
axis tight
xlabel('Time in seconds');
ylabel('ECG after only Comb filter');

subplot(313)
plot((1:slen)/fs,b);

function b = weiner_hopf(x,y,maxlags)
    n = length(x);
    rxx = xcorr(x,maxlags,"coeff");
    l = length(rxx);
    rxx = rxx(maxlags+1:end-1);
    rxy = xcorr(x,y,maxlags);
    rxy = rxy(maxlags+1:end-1);
    rxx_matrix = toeplitz(rxx);
    b= rxx_matrix\rxy;
end
