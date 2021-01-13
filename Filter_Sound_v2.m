% Generate waveforms and spectrograms after applying custom bandpass
% filters and spectrogram window settings to audio signals.
%% Author: Kushal Bakshi
clear
close all
%% ENTER USER-DEFINED INFORMATION BELOW - file name/location, filters, etc.

% Enter the audio file name in the first variable and full file location in
% the second. Add the format to the end of the file name and add the '\' to
% the end of the file location. 
FileName = ''; 
FileLocation = '';

% Enter the sampling rate in Hz
fs = 192000;

% Threshold over standard deviation to look for clicks in the waveform
threshold_over_std = 3;

% Enter lower and higher frequencies you want to keep (everything outside
% this range will be excluded). DO NOT SET THIS VERY CLOSE TO FREQUENCIES OF
% INTEREST
lower_freq = 1000;
upper_freq = 90000;

% Enter the sample window size and sample overlap for spectrogram
window_size = 1024;
overlap_size = 256;

%% Script for figures
[b,a] = butter(4,[lower_freq upper_freq]/(fs/2),'bandpass');

unfiltered_recording = audioread([FileLocation, FileName]);
filtered_recording = filtfilt(b,a,unfiltered_recording);

filtered_recording = filtered_recording(:,1); % Only uses ch. 1
thr = std(filtered_recording)*threshold_over_std;
[pks,locs] = findpeaks(filtered_recording, 'MinPeakHeight',thr,...
    'MinPeakDistance',(275*fs)/1000);

figure;

ax1 = subplot(2,1,1);
spectrogram(filtered_recording,window_size,overlap_size,window_size,fs,'yaxis');
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