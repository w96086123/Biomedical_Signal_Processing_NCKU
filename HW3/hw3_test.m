% 假设您的 ECG 信号数据存储在变量 ecg_data 中
% ecg_data 是一个包含时间序列的向量
close all;

% Load the ECG signal
ecg_data = load('ecg_hfn.dat');
window_start = 1;  % 开始采样点
window_length = 800;  % 时间窗口长度

% 提取时间窗口内的信号
ecg_data = ecg_data(window_start : window_start + window_length - 1);

% 分段线性回归参数
segment_length = 60;  % 每个小段的长度
overlap = 1; % 重叠部分长度

% 初始化结果向量
fitted_ecg = zeros(size(ecg_data));

% 分段线性回归拟合
for i = 1:overlap:length(ecg_data) - segment_length + 1
    % 提取当前小段
    segment = ecg_data(i:i+segment_length-1);
    
    % 创建时间向量
    time = (1:length(segment))';
    
    % 进行线性拟合
    p = polyfit(time, segment, 1);  % 1 表示线性拟合
    
    % 使用拟合参数创建线性模型
    linear_model = p(1) * time + p(2);
    
    % 将拟合结果保存到结果向量
    fitted_ecg(i:i+segment_length-1) = linear_model;
end



% Specify the filename where you want to save the filtered ECG signal
filename = 'piece_ecg.dat';

% Save the filtered ECG signal as an ASCII file
save(filename, 'fitted_ecg', '-ascii');



% 绘制原始 ECG 信号和分段线性拟合结果
t = (0:length(ecg_data) - 1);
figure;
subplot(2, 1, 1);
plot(t, ecg_data);
title('原始 ECG 信号');
xlabel('时间点');
ylabel('振幅');

subplot(2, 1, 2);
plot(t, fitted_ecg);
title('分段线性拟合结果');
xlabel('时间点');
ylabel('振幅');
