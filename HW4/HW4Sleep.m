clear all;
close all;

files = ["./data/ECG_N2.mat","./data/ECG_N3.mat","./data/ECG_REM.mat","./data/ECG_Wake.mat"];

for i = 1:length(files)
    data = load(files{i});
    field_names = fieldnames(data);
    % Assuming there is only one field in the structure, use that field
    ecg = data.(field_names{1});
    ecg = resample(ecg,200,512);
    [~, fileName, ~] = fileparts(files{i});
    resultOfPanTompkins = runPanTompkins(ecg,fileName);
end