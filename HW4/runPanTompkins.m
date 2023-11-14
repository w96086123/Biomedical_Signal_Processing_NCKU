function ma_ecg = runPanTompkins(signal,fileName)
    
    disp(fileName);

    ECGLenght = length(signal);
    fs = 200;
    time = (1:ECGLenght)/fs;
    
    f1 = figure;
    
    % 获取屏幕大小
    screenSize = get(0, 'ScreenSize');
    
    % 设置图形大小为屏幕大小
    set(gcf, 'Position', screenSize);
    
    % show origin ECG signal
    figure(f1);
    subplot (611);
    plot(time,signal/max(signal));
    title("Original ECG signal");
    xlabel("Time (s)");
    
    % Implement Pan-Tompkins
    
    % BPF(low pass and high pass filter)
    ECGBPF = BPF(signal,fs);
    
    figure(f1);
    subplot(612);
    plot(time,ECGBPF/max(ECGBPF));
    title("BPF output");
    xlabel("Time (s)");
    
    % Differentiation
    derivative_ecg = diff(ECGBPF);
    
    figure(f1);
    subplot(613);
    plot(time(2:end),derivative_ecg/max(derivative_ecg));
    title("Derivative output");
    xlabel("Time (s)");
    
    % Squaring
    squared_ecg = derivative_ecg.^ 2;
    
    figure(f1);
    subplot(614);
    plot(time(2:end),squared_ecg/max(squared_ecg));
    title("Squaring output");
    xlabel("Time (s)");
    
    % Intergration
    window_width = round(0.150 * fs);
    ma_ecg = movmean(squared_ecg, window_width);
    
    figure(f1);
    subplot(615);
    plot(time(2:end),ma_ecg/max(ma_ecg));
    title("Intergration output");
    xlabel("Time (s)");


    rou = 0.2;
    th = 0.05;
    % Find peaks in the Hilbert-transformed signal
    threshold = th * max(squared_ecg); % Adjust this threshold value
    [~, locs] = findpeaks(squared_ecg, 'MinPeakHeight', threshold, 'MinPeakDistance', round(rou * fs));

    % Post-processing to select peaks with highest amplitude
    window_size = round(0.150 * fs); % 150 ms window
    selected_locs = [];
    for i = 1:length(locs)
        start_idx = max(1, locs(i) - window_size);
        end_idx = min(length(squared_ecg), locs(i) + window_size);
        [~, max_idx] = max(squared_ecg(start_idx:end_idx));
        selected_locs = [selected_locs, start_idx + max_idx - 1];
    end

    % Plot detected peaks
    subplot(616);
    plot(time, signal, 'b', time(selected_locs), signal(selected_locs), 'ro');
    title('ECG Signal with Detected Peaks');
    xlabel('Time (s)');
    ylabel('Amplitude');
    legend('ECG Signal', 'Detected Peaks');

    % Calculate RR intervals
    rr_intervals = diff(selected_locs) / fs;

    % Compute heart rate
    heart_rate = 60 / mean(rr_intervals);
    

    disp(heart_rate);

    diff_ma_ecg = diff(ma_ecg);
    figure;
    plot(time(3:end),diff_ma_ecg/max(diff_ma_ecg));
    
    point = findpeaks(diff_ma_ecg);
    temp = 0;
    for i = 1:2:length(point)-1
        temp = temp + time(point(i+1)) - time(point(i));
    end
    temp = temp \ length(point)-1 \2;
    disp(temp);

    saveas(gcf, "./"+fileName+'.jpg', 'jpg');


end




