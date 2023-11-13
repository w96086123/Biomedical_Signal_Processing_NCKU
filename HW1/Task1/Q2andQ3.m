close all;
clear all;

% load o1 and o2, time is 4.72~5.71
o1 = load("eeg1-o1.dat");
o1 = o1(472:571);
o2 = load("eeg1-o2.dat");
o2 = o2(472:571);
f3 = load("eeg1-f3.dat");
f3 = f3(472:571);
N = length(o1);

% sampling rate is 100 HZ
fs = 100;

% main process
[c1,lag1] = xcorr(o1,o2,"coeff");
c1 =c1/max(c1);
[c2,lag2] = xcorr(o1,f3,"coeff");
c2 = c2/max(c2);

% plot
subplot(2,1,1);
lag1= lag1(N:2*N-1);
c1=c1(N:2*N-1);
plot(lag1/fs,c1);
title("o1 and o2")

subplot(2,1,2);
lag2= lag2(N:2*N-1);
c2=c2(N:2*N-1);
plot(lag2/fs,c2);
title("o1 and f3")



