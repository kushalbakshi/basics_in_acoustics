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

% Enter spectrograme start and end times in seconds. IF BLANK: []
SpecGram_Start = [];
SpecGram_End = [];

% Enter the sampling rate in Hz
fs = 96000;

% Enter lower and higher frequencies you want to keep (everything outside
% this range will be excluded). DO NOT SET THIS VERY CLOSE TO FREQUENCIES OF
% INTEREST
lower_freq = 1000; 
upper_freq = 30000;

% Enter the sample window size and sample overlap for spectrogram
window_size = 512;
overlap_size = 128;

%% Script for figures
[b,a] = butter(4,[lower_freq upper_freq]/(fs/2),'bandpass');
unfiltered_recording = importdata([FileLocation, FileName]).data;
filtered_recording = filtfilt(b,a,unfiltered_recording);

if isempty(SpecGram_Start) == 1
    figure;
    
    subplot(2,1,1)
    spectrogram(unfiltered_recording,window_size,overlap_size,window_size,...
        fs,'yaxis')
    colormap jet
    colorbar off
    title('Unfiltered Sound')
        
    subplot(2,1,2)
    plot(linspace(0,length(unfiltered_recording)/fs,length(unfiltered_recording)),...
        unfiltered_recording)
    xlabel('Time(s)')

    figure;
    
    subplot(2,1,1)
    spectrogram(filtered_recording,window_size,overlap_size,window_size,...
        fs,'yaxis')
    colormap jet
    colorbar off
    title('Filtered Sound')
    
    subplot(2,1,2)
    plot(linspace(0,length(filtered_recording)/fs,length(filtered_recording)),...
        filtered_recording)
    xlabel('Time(s)')    
else
    
    figure;
    
    subplot(2,1,1)
    spectrogram(unfiltered_recording(SpecGram_Start*fs:SpecGram_End*fs,1),...
        window_size, overlap_size, window_size, fs, 'yaxis')
    colormap jet
    colorbar off
    title('Unfiltered Sound')
    
    subplot(2,1,2)
    plot(linspace(0,SpecGram_End-SpecGram_Start,...
        length(unfiltered_recording(SpecGram_Start*fs:SpecGram_End*fs))),...
        unfiltered_recording(SpecGram_Start*fs:SpecGram_End*fs))
    xlabel('Time(s)')
        
    figure;
    
    subplot(2,1,1)
    spectrogram(filtered_recording(SpecGram_Start*fs:SpecGram_End*fs,1),...
        window_size, overlap_size, window_size, fs, 'yaxis')
    colormap jet
    colorbar off
    title('Filtered Sound')
    
    subplot(2,1,2)
    plot(linspace(0,SpecGram_End-SpecGram_Start,...
        length(filtered_recording(SpecGram_Start*fs:SpecGram_End*fs))),...
        filtered_recording(SpecGram_Start*fs:SpecGram_End*fs))
    xlabel('Time(s)')
    
end