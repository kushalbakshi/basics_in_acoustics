% Generate waveforms and spectrograms after applying custom bandpass
% filters and spectrogram window settings to audio signals.
clear
close all
%% ENTER USER-DEFINED INFORMATION BELOW - file name/location, filters, etc.

% Enter the audio file name in the first variable and full file location in
% the second. Add the format to the end of the file name and add the '\' to
% the end of the file location. 
FileName = ''; 
FileLocation = '';

% Enter the sampling rate in Hz
fs = 96000;

% Enter lower and higher frequencies you want to keep (everything outside
% this range will be excluded). DO NOT SET THIS VERY CLOSE TO FREQUENCIES OF
% INTEREST
lower_freq = 1000;
upper_freq = 45000;

% Enter the sample window size and sample overlap for spectrogram
window_size = 1024;
overlap_size = 256;

%% Script for figures
[b,a] = butter(4,[lower_freq upper_freq]/(fs/2),'bandpass');
%[d,c] = ellip(2,3,40,[(32000/(fs/2)),(33000/(fs/2))],'stop');
unfiltered_recording = audioread([FileLocation, FileName]);
filtered_recording = filtfilt(b,a,unfiltered_recording);
%filtered_recording = filtfilt(d,c,filtered_recording);
filtered_recording = filtered_recording(:,1);
threshold = std(filtered_recording)*2;
[pks,locs] = findpeaks(filtered_recording, 'MinPeakHeight',threshold,...
    'MinPeakDistance',(275*fs)/1000);
SNR = 85;

figure;

ax1 = subplot(2,1,1);
spectrogram(filtered_recording,window_size,overlap_size,window_size,fs,'yaxis',...
    'MinThreshold',-SNR);
colormap jet
colorbar off
title('Filtered Sound')
xlim([0 5]);
ax2 = subplot(2,1,2);
plot(linspace(0,(length(filtered_recording)/fs)/60,length(filtered_recording)),...
    filtered_recording)
hold on
plot((locs/fs)/60,pks,'ro')
xlabel('Time (Minutes)')
xlim([0 5]);
linkaxes([ax1,ax2],'x');

disp(['Total Number of Calls is ',num2str(length(pks))])

calls_per_min = zeros(5,1);
temp = zeros(1,1);
for m=1:5
    temp = find(fs*((m-1)*60)<locs & locs<fs*(m*60));
    calls_per_min(m,1) = numel(temp==1);
end
calls_per_min