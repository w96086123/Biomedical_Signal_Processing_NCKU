close all;
clear all;


% load f3 and o1
f3 = load("eeg1-f3.dat");
f3 = f3(420:496);
f3Len = length(f3);
o1 = load("eeg1-o1.dat");
o1 = o1(420:496);
o1Len = length(o1);

% sampling rate is 100 HZ
fs = 100;

% process xcorr
[c1,lag1] = xcorr(f3,"coeff");
[c2,lag2] = xcorr(o1,"coeff");

% Time is 4.2-4.96
subplot(2,1,1);
lag1= lag1(f3Len:2*f3Len-1);
c1=c1(f3Len:2*f3Len-1);
plot(lag1/fs,c1);
title("f3")


subplot(2,1,2);
lag2= lag2(o1Len:2*f3Len-1);
c2=c2(o1Len:2*f3Len-1);
plot(lag2/fs,c2);
title("o1")