%% Plot spectrogram figure from audiofile
%% Author: Kushal Bakshi
% Written for importing audio recordings of mice vocalizations and
% generating spectrograms of the 5 minute recording files

% Import and preprocess files
fs = 192000;
[b,a] = butter(2,[500 90000]/(fs/2),'bandpass');
d7_114 = audioread('D:\Hook Lab\114 D7 4C.wav');
d7_114 = filtfilt(b,a,d7_114);
d7_176 = audioread('D:\Hook Lab\176 D7 4C.wav');
d7_176 = filtfilt(b,a,d7_176);
d21_115 = audioread('D:\Hook Lab\115 D21 4C.wav');
d21_115 = filtfilt(b,a,d21_115);
d21_148 = audioread('D:\Hook Lab\148 D21 4C.wav');
d21_148 = filtfilt(b,a,d21_148);

% Set Spectrogram Parameters
window_size = 1024;
overlap_size = 512;
SNR = 120;

%% Generates Spectrograms
fig1 = figure;
set(gcf,'color','w','WindowState','maximized','Name','Spectrograms of recordings',...
    'DefaultAxesFontSize',14)

ax1 = subplot(4,1,1);
spectrogram(d7_176(:,1),window_size,overlap_size,window_size,fs,'yaxis',...
    'MinThreshold',-SNR);
colormap jet
ylim([0 20])
xlim([0 5])
xlabel('')
ylabel('')
set(gca,'Xticklabel',[],'Yticklabel',[]);
colorbar
caxis([-SNR -70])
title('Day 7 - Animal 176 at 4 degrees')

ax2 = subplot(4,1,2);
spectrogram(d7_114(:,1),window_size,overlap_size,window_size,fs,'yaxis',...
    'MinThreshold',-SNR);
colormap jet
ylim([0 20])
xlim([0 5])
xlabel('')
ylabel('')
set(gca,'Xticklabel',[],'Yticklabel',[]);
colorbar
caxis([-SNR -70])
title('Day 7 - Animal 114 at 4 degrees')

ax3 = subplot(4,1,3);
spectrogram(d21_115(:,1),window_size,overlap_size,window_size,fs,'yaxis',...
    'MinThreshold',-SNR);
colormap jet
ylim([0 20])
xlim([0 5])
xlabel('')
ylabel('')
set(gca,'Xticklabel',[],'Yticklabel',[]);
colorbar
caxis([-SNR -70])
title('Day 21 - Animal 115 at 4 degrees')

ax4 = subplot(4,1,4);
spectrogram(d21_148(:,1),window_size,overlap_size,window_size,fs,'yaxis',...
    'MinThreshold',-SNR);
colormap jet
ylim([0 20])
xlim([0 5])
title('Day 21 - Animal 148 at 4 degrees')
c = colorbar;
caxis([-SNR -70])
c.Label.String = 'Power/Frequency (dB/Hz)';
c.Label.FontSize = 14;

sgtitle('Spectrograms for Day 7 and Day 21 Vocalizations', 'FontWeight','bold');

%% Generates Waveforms
x_in_minutes = linspace(0,5,(192000*5*60));
fig2 = figure;
set(gcf,'color','w','WindowState','maximized','Name','Waveforms of recordings',...
    'DefaultAxesFontSize',14)

ax1 = subplot(4,1,1);
plot(x_in_minutes, d7_176(1:length(x_in_minutes),1));
ylim([-0.07 0.07])
set(gca,'TickLength',[0 0],'Xticklabel',[])
title('Day 7 - Animal 176 at 4 degrees')

ax2 = subplot(4,1,2);
plot(x_in_minutes, d7_114(1:length(x_in_minutes),1));
ylim([-0.07 0.07])
set(gca,'TickLength',[0 0],'Xticklabel',[])
title('Day 7 - Animal 114 at 4 degrees')

ax3 = subplot(4,1,3);
plot(x_in_minutes, d21_115(1:length(x_in_minutes),1));
ylim([-0.03 0.03])
set(gca,'TickLength',[0 0],'Xticklabel',[])
title('Day 21 - Animal 115 at 4 degrees')

ax4 = subplot(4,1,4);
plot(x_in_minutes, d21_148(1:length(x_in_minutes),1));
ylim([-0.03 0.03])
set(gca,'TickLength',[0 0])
title('Day 21 - Animal 148 at 4 degrees')
ylabel('Relative amplitude (V)')
xlabel('Time (minutes)')
sgtitle('Acoustic Waveforms for Day 7 and Day 21 Vocalizations',...
    'FontWeight','bold')