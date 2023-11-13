close all;
clear all;

hfn = load("ecg_hfn.dat");
org_hfn = hfn;
org_lag = (0:length(org_hfn)-1);
hfn = hfn(1:800);

lag = 0:length(hfn)-1;

subplot(5,1,1);
plot(hfn);
ylabel("Original");

subplot(5,1,2);
lag1 = [0,121,124,168,182,274,291,325,351,496,520,591,643,800];
y =    [0,0,  0.3,0.3,0,  0,  2,  -0.5,0, 0,  0.5, 0.5, 0,0];

y_interp = interp1(lag1, y, lag, 'linear');
y_interp = y_interp';
plot(y_interp);

ylabel("Model");

subplot(5,1,3);
b = weiner_hopf(hfn,y_interp,800);
b = filter(b,1,hfn);
plot(b);
xlabel("Time in ms");

subplot(5,1,4);
plot(org_lag/1000,org_hfn);
ylabel("Original")
% subplot(5,1,5);
b = weiner_hopf(org_hfn,y_interp,400);

% filter freqency response
[H,f] = freqz(b);
figure
plot(f, abs(H));
title('滤波器幅度响应');
xlabel('频率 (Hz)');
ylabel('幅度');

b = filter(b,1,org_hfn);
% plot(org_lag/1000,b);
% ylabel("EEG after winer filter")

figure
fs = 1000;
slen = length(org_hfn);
x=fft(org_hfn);
f=(0:slen-1)*(fs/slen);
power=abs(x).^2/slen;

figure
subplot(211)
plot(f, 10*log10(power))
axis tight;
xlabel('Hz');
ylabel('dB');
title("PSD of Original")
axis([0 500 -100 70]);

x=fft(b);
power=abs(x).^2/slen;

subplot(212)
plot(f,10*log10(power));
axis([0 500 -100 70]);
xlabel('Hz')
ylabel('dB')
title("PSD after Winer filter ")






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


