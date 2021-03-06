function [ features ] = extract_FD_features( sensor, Fs )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

for i = 1:3
    for j = 1:3
        for k = 1:(20*2^i)
            
            signal = sensor{i,j}(:,k);
            FFT_signal = fft(signal);
            
            % Sum of amplitude spectrum components.
            tmp{1}{i, j}(1, k) = real(sum(FFT_signal));
            
            % Number of Peaks Power Spectrum
            [P,freq] = periodogram(signal,[],[],Fs,'power');
            [~,lc] = findpeaks(P,'SortStr','descend');
            tmp{2}{i,j}(1,k) = length(lc);
            
            % Signal bandwidth
            tmp{3}{i,j}(1,k) = obw(signal,Fs);
            
            % Average distance power peak frequency
            [~, lc] = findpeaks(P);
            tmp{4}{i,j}(1,k) = mean(diff(freq(lc)));
            
            % Average power of the signal
            tmp{5}{i,j}(1,k) = bandpower(signal);
            
            % Average frequency peaks for the power density signal
            [P, freq] = pwelch(signal);
            [~, lc] = findpeaks(P);
            tmp{6}{i,j}(1,k) = mean(diff(freq(lc)));
            
            % Average frequency of the 3 peaks with more amplitude
            % for the power density signal
            [~,lc] = findpeaks(P,'SortStr','descend', 'NPeaks',3);
            tmp{7}{i,j}(1,k) = mean(freq(lc));
            
            % Sum amplitude power density
            tmp{8}{i,j}(1,k) = sum(P);
            
        end;
    end;
end;

features = tmp;


end

