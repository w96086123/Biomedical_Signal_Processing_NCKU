close all;
clear all;
run('ecg_hfn.m')

% 頻譜圖
x=fft(ecg);
f=(0:slen-1)*(fs/slen);
power=abs(x).^2/slen;
figure
subplot(211)
plot(t, ecg)
axis tight;
xlabel('Time in seconds');
ylabel('ECG');
subplot(212)
plot(f,10*log10(power));
axis([0 500 -105 50]);
xlabel('Hz')
ylabel('dB')

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

n = 1024; % Optimnal filter order
comb=comb.'
b = weiner_hopf(ecg,comb(1:slen),n);    % Apply Weiner Hopf Equations
result=conv(ecg,b);
figure
subplot(311)
plot((1:slen)/fs, ecg)
axis tight;
xlabel('Time in seconds');
ylabel('ECG');
subplot(312)
plot((1:slen)/fs,comb(1:slen))
axis tight;
xlabel('Time in seconds');
ylabel('ECG after Comb filter');
subplot(313)
plot((1:slen)/fs,result(1:slen))
axis tight;
xlabel('Time in seconds');
ylabel('ECG after Wiener filter');

figure
plot((1:slen)/fs, ecg,'k','DisplayName','original');
axis tight;
xlabel('Time in seconds');
ylabel('ECG');
hold on;
plot((1:slen)/fs,result(1:slen),'r','DisplayName','result');
hold on;
plot((1:slen)/fs,comb(1:slen),'DisplayName','template(Comb)');
legend({'original', 'result', 'template(Comb)'},'Location','northeast');

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

function b=weiner_hopf(x,y,maxlags)
% Function to compute LMS algol using Weiner-Hopf equations
% Inputs: x=input
% y=desired signal
% Maxlags=filter length
% Compute the autocorrelation matrix
n=length(x);
rxx=xcorr(x,maxlags,'coeff');
l=length(rxx);
rxx=rxx(maxlags+1:end-1);   % xcorr produces rxx(0) at maxlags+1
rxy=xcorr(x,y,maxlags,'normalized');
rxy=rxy(maxlags+1:end-1);
% Construct correl matrix and check if singular or ill conditioned
rxx_matrix=toeplitz(rxx);
% Calculate FIR coefficients
b=rxx_matrix\rxy;            % Levenson could be used here
end