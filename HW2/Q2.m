% plot hfn and process resample hfn
hfn = load("ecg_hfn.dat");
subplot(4,1,1);
plot(hfn);
subplot(4,1,2);
y = resample(hfn,1,5);
plot(y);
% plot lfn and process resample lfn
lfn = load("ecg_lfn.dat");
subplot(4,1,3);
plot(lfn);
y = resample(lfn,1,5);
subplot(4,1,4);
plot(y);