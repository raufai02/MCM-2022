function [filtdata] = filtdatafunc(data)
Fs = 100; % Sampling frequency of data (Hz) ie interval 
%interval separating each data point in time series data


% Design a 4th order butterworth bandpass filter
N1 = 4; % Order
lb = 20/(0.5*Fs); % Lower cutoff (Hz)
ub = 400/(0.5*Fs); % Upper cutoff (Hz)
[b1,a1] = butter(N1,[lb ub],'bandpass');

% Design a 2nd order butterworth notch filter
N2   = 2;   % Order
Fc1 = 48;  % First Cutoff Frequency in Hz
Fc2 = 52;  % Second Cutoff Frequency in Hz
h  = fdesign.bandstop('N,F3dB1,F3dB2', N2, Fc1, Fc2, Fs);
Hd = design(h, 'butter');


% Design a 3rd order butterworth lowpass filter
N3 = 3; %Order
lb = 10/(0.5*Fs); % Lower cutoff frquency
[b2,a2] = butter(N3,lb,'low');


data1(:,1) = filtfilt(b1,a1,data);
notch(:,1) = filter(Hd,data1);
filtdata(:,1) = filtfilt(b2,a2,notch);

end


