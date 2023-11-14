clear all;
close all;

files = ["./data/ECG3.dat","./data/ECG4.dat","./data/ECG5.dat","./data/ECG6.dat"];

for i = 1:length(files)
    ecg = load(files{i});
    [~, fileName, ~] = fileparts(files{i});
    resultOfPanTompkins = runPanTompkins(ecg,fileName);
end