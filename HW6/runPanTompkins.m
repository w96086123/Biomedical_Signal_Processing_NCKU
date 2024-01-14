function ma_ecg = runPanTompkins(signal,fileName)
    
    disp(fileName);
    
    fid = fopen(fileName+".txt","w");

    ECGLenght = length(signal);
    fs = 200;
    time = (1:ECGLenght)/fs;
      
    % Implement Pan-Tompkins
    
    % BPF(low pass and high pass filter)
    ECGBPF = BPF(signal,fs);
    
    % Differentiation
    derivative_ecg = diff(ECGBPF);
    
    % Squaring
    squared_ecg = derivative_ecg.^ 2;
    
    % Intergration
    window_width = round(0.150 * fs);
    ma_ecg = movmean(squared_ecg, window_width);
    ma_ecg = ma_ecg / max(ma_ecg);

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
            end
        end
    end
    for i = 2:length(RPeak)
        fprintf(fid, '%f\n', (RPeak(i)-RPeak(i-1))/fs);
    end
    fclose(fid);
end




