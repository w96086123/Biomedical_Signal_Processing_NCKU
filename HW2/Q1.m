% sampling rate is 1000HZ
fs = 1000;
% load hfn and lfn
hfn = load("ecg_hfn.dat");
subplot(4,1,1);
lag1 = 0:length(hfn)-1;
plot(lag1/fs,hfn);
xlabel("original eeg hfn");

lfn = load("ecg_lfn.dat");
subplot(4,1,2);
lag2 = 0:length(lfn)-1;
plot(lag2/fs,lfn);
xlabel("original eeg lfn");

% main process(1000HZ to 200HZ)
new_hfn = hfn(1:5:length(hfn));
subplot(4,1,3);
lag3 = 0:length(new_hfn)-1;
plot(lag3/fs*5,new_hfn);
xlabel("revise eeg hfn");

new_lfn = lfn(1:5:length(lfn));
subplot(4,1,4);
lag4 = 0:length(new_lfn)-1;
plot(lag4/fs*5,new_lfn);
xlabel("revise eeg lfn");
