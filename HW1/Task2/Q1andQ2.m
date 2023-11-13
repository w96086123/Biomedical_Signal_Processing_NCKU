close all;
clear all;

% load hfn
hfn = load("ecg_hfn.dat");
N = length(hfn);

% sampling rate is 1000 HZ
fs = 1000;

% main process
[c,lag] = xcorr(hfn,selectQRS(hfn));
c = c/max(c);
lag1= lag(N:2*N-1);
c1=c(N:2*N-1);
plot(lag1/fs,c1);
hold on;
[pk, lk] = findpeaks(c1,"MinPeakHeight",0.8);
plot(lk/fs,pk,'o');
xlabel("Time in seconds")
ylabel("Cross-correlation with template")

% calculate BPM
 for i = 2:length(lk)
     time = (lk(i) - lk(i-1))/fs;
     BPM =  (1 / time) * 60; 
     time
     int16(BPM)
end 

% function for select QRS
function QRS = selectQRS(x)
    QRS = x(270:340);
end