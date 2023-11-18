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
    subplot (511);
    plot(time,signal/max(signal));
    title("Original ECG signal");
    xlabel("Time (s)");
    
    % Implement Pan-Tompkins
    
    % BPF(low pass and high pass filter)
    ECGBPF = BPF(signal,fs);
    
    figure(f1);
    subplot(512);
    plot(time,ECGBPF/max(ECGBPF));
    title("BPF output");
    xlabel("Time (s)");
    
    % Differentiation
    derivative_ecg = diff(ECGBPF);
    
    figure(f1);
    subplot(513);
    plot(time(2:end),derivative_ecg/max(derivative_ecg));
    title("Derivative output");
    xlabel("Time (s)");
    
    % Squaring
    squared_ecg = derivative_ecg.^ 2;
    
    figure(f1);
    subplot(514);
    plot(time(2:end),squared_ecg/max(squared_ecg));
    title("Squaring output");
    xlabel("Time (s)");
    
    % Intergration
    window_width = round(0.150 * fs);
    ma_ecg = movmean(squared_ecg, window_width);
    ma_ecg = ma_ecg / max(ma_ecg);
    figure(f1);
    subplot(515);
        hold on;

    plot(time(2:end),ma_ecg);
    title("Intergration output");
    xlabel("Time (s)");

    %% 實作課本上的findpeaks
    %% Defind
    % PEDKI: the detected new peak
    % SPKI: peak level of QRS peaks
    % NPKI: peak level of noo-QRS peaks
    
    [pks,locs] = findpeaks(ma_ecg,'MINPEAKDISTANCE',round(0.2*fs));
    LLp = length(pks);
    SIG_LEV = max(ma_ecg(1:2*fs)) * 1/3;
    NOISE_LEV = mean(ma_ecg(1:2*fs))* 1/2;                                       
    thres=NOISE_LEV+0.25*(SIG_LEV-NOISE_LEV);
    %% compute
    % SPKI = 0.125PEAKI + 0.875SPKI if PEAKI is signal peak
    % NPKI = 0.125PEAKI + 0.875NPKI if PEAKI is a noise peak
    % THRESHOLD I1 = NPKI + 0.25(SPKI - NPKI)
    % THRESHOLD I2 = 0.5 * THRESHOLD I1
    
    Beat = 0;Noi = 0;T=0;                                                                
    Noise_Count = 0;
    Sx(1)=0;Sy=SIG_LEV;
    Nx(1)=0;Ny=NOISE_LEV;
    Tx(1)=0;Ty(1)=thres;
    RPeak = [];
    for i=1:LLp
        if  pks(i)>thres
            SIG_LEV=0.125*pks(i)+0.875*SIG_LEV;
            Beat=Beat+1;
            Sx(Beat+1)=locs(i);
            Sy(Beat+1)=SIG_LEV;
            RPeak(end+1) = locs(i);
            q=plot(locs(i)/fs,pks(i),'m*');
        else
            NOISE_LEV=0.125*pks(i)+0.875*NOISE_LEV;      
            Noi=Noi+1;
            Nx(Noi+1)=locs(i);
            Ny(Noi+1)=NOISE_LEV;
        end
        thres=NOISE_LEV+0.25*(SIG_LEV-NOISE_LEV);
        T=T+1;
        Tx(T+1)=locs(i);
        Ty(T+1)=thres;
    end
    h1=plot(Sx/fs,Sy,'LineWidth',2,'Linestyle','--','color','r');
    h2=plot(Nx/fs,Ny,'LineWidth',2,'Linestyle','--','color','b');
    h3=plot(Tx/fs,Ty,'LineWidth',2,'Linestyle','--','color','g');
    legend([q h1 h2 h3],{'Detected QRS','Signal Level','Noise Level','Adaptive Threshold'},'Location','BestOutside');
    
    %% Search Back
    % 取得RR interval
    RR=mean(diff(Sx),2);
    for i=1:length(Sx)-1
        if  (Sx(i+1)-Sx(i))>RR*1.66
            new=thres(i)/2;
            x=find(locs==Sx(i));
            if(locs(x+1)>new)
                Beat=Beat+1;
                hold on;
                RPeak(end+1) = locs(x+1);
                plot(locs(x+1)/fs,pks(x+1),'m*');
            end
        end
    end
    neg_ma_ecg = -ma_ecg;
    [Q,Qpeak] = findpeaks(neg_ma_ecg,"MinPeakHeight",-0.1);
    QfindPeak = [];
    index = 1;
    Qfind = [];
    for i=1:length(Qpeak)
        if Qpeak(i) >= RPeak(index)
            QfindPeak(end+1) = Qpeak(i-1);
            Qfind(end+1) = Q(i-1);
            index = index+1;
            if index > length(RPeak)
                break;
            end
        end
    end

    QRSWidth = 0;
    for i=1:length(QfindPeak)
        QRSWidth = QRSWidth + (RPeak(i) - QfindPeak(i));
    end
    plot(QfindPeak/fs,Qfind/min(neg_ma_ecg),"go");

    rate2=Beat*60/time(end);
    x = sprintf("BPM= %f",rate2);
    disp(x);
    x = sprintf("QRS width= %f",QRSWidth/fs/length(QfindPeak));
    disp(x);
    saveas(gcf, "./"+fileName+'.jpg', 'jpg');


end




