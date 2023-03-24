%% 1: STEP FREQUENCY

load threeSubjects.mat
fs = 512; % Hz (sample rate)

% Let's see sbj1 signals plotted
gastrocnemio = sbj1(:,1);
tibiale = sbj1(:,2);

figure,
plot(gastrocnemio)
figure,
plot(tibiale)

% We notice that both signals contain a lot of noise. we can try and
% filter them: butter and filtfilt functions. 10-30Hz
% We can combine low pass and high pass filtering

lowp = 30; % (Hz) upper bound frequency
ord = 4; % filter order
nyqfreq = fs/2; % Nyquist frequency (for Shannon's Theorem Of Sampling)

% Cutoff Frequency
Wn = lowp/nyqfreq;

% Creating the actual filter with butter.
[b, a] = butter(ord, Wn, 'low');

emg_filtrata1 = filtfilt(b,a,sbj1);
emg_filtrata4 = filtfilt(b,a,sbj4);
emg_filtrata5 = filtfilt(b,a,sbj5);

% We have obtained filtered emgs (only low pass)

% Now we are high pass filtering (from 10 Hz)
highp = 10; %Hz
Wn = highp/nyqfreq;
[b, a] = butter(ord, Wn, 'high');
emg_filtrata1 = filtfilt(b, a, emg_filtrata1);
emg_filtrata4 = filtfilt(b, a, emg_filtrata4);
emg_filtrata5 = filtfilt(b, a, emg_filtrata5);

% Obtained the complete filtered version of emgs.

% Let's see what we got:
gastrocnemio2 = emg_filtrata1(:,1);
tibiale2 = emg_filtrata1(:,2);

figure, clf, plot(gastrocnemio), hold on
plot(gastrocnemio2), hold off
title('Filered 10-30Hz')
legend({'original', 'filtered'})
figure, clf, plot(tibiale), hold on
plot(tibiale2), hold off
title('Filered 10-30Hz')
legend({'original', 'filtered'})

% Feature extraction
emg_rms1 = rms(emg_filtrata1,2); % Root-mean-square
emg_rms4 = rms(emg_filtrata4,2); % Root-mean-square
emg_rms5 = rms(emg_filtrata5,2); % Root-mean-square
% Just to see each step better

% Event detection (Usually 20-30% of RMS)
threshold1 = 0.30*max(emg_rms1); % Threshold for event detection
threshold4 = 0.30*max(emg_rms4);
threshold5 = 0.30*max(emg_rms5);

% Find peaks above threshold
[peaks1,steps1] = findpeaks(emg_rms1,'MinPeakHeight',threshold1); 
[peaks4,steps4] = findpeaks(emg_rms4,'MinPeakHeight',threshold4);
[peaks5,steps5] = findpeaks(emg_rms5,'MinPeakHeight',threshold5); 

duration1 = size(sbj1,1)/fs; % Recording duration in seconds
% this is for how long did they walk, later we will recompute this number
frequency1 = length(steps1)/duration1; % Steps per second

duration4 = size(sbj4,1)/fs; % Recording duration in seconds
frequency4 = length(steps4)/duration4; % Steps per second

duration5 = size(sbj5,1)/fs; % Recording duration in seconds
frequency5 = length(steps5)/duration5; % Steps per second

% Let's see how the thresholds work

figure, hold on
plot(emg_rms1)
yline(threshold1, 'Color', 'r', 'LineWidth', 1),
legend({'RMS1', 'threshold'})
hold off

figure, hold on
plot(emg_rms4)
yline(threshold4, 'Color', 'r', 'LineWidth', 1),
legend({'RMS4', 'threshold'})
hold off

figure, hold on
plot(emg_rms5)
yline(threshold5, 'Color', 'r', 'LineWidth', 1),
legend({'RMS5', 'threshold'})
hold off

% Display the results (Frequency of steps)
disp(['Frequency of steps1: ',num2str(frequency1),' Hz']);
disp(['Frequency of steps4: ',num2str(frequency4),' Hz']);
disp(['Frequency of steps5: ',num2str(frequency5),' Hz']);

save THRESHOLD threshold4 threshold1 threshold5
save FILTERED emg_rms1 emg_rms4 emg_rms5

%% 2: HOW MANY STEPS FOR EACH SUBJECT? AND...
%% 3: HOW LONG DID THEY WALK?

load THRESHOLD
load FILTERED

fs = 512; % sample rate

% Loop on every subjects' rms to compute the number of steps
subjects = {emg_rms1, emg_rms4, emg_rms5};
thresholds = {threshold1, threshold4, threshold5};
ns = zeros(3,1);
wd = zeros(3,1);

for i = 1:numel(subjects)
    % Event detection
    % Find peaks above threshold
    [peaks,steps] = findpeaks(subjects{i},'MinPeakHeight',thresholds{i}); 

    % Compute the number of steps
    num_steps = length(steps); % How many peaks we got?
    ns(i) = num_steps; % we add them inside a data structure

    % Compute the walking duration
    walking_duration = length(subjects{i})/fs;
    wd(i) = walking_duration;

end

% Let's see the results
j = 1;
for i = 1:numel(subjects)
    if i==2
        j = 4;
    elseif i == 3
        j = 5;
    end
    disp(['Subject ',num2str(j),' number of steps: ',num2str(ns(i))]);
    disp(['And Walking Duration: ',num2str(wd(i))]);
end

%% NOTES:
% - Once the number of steps is computed, we can retrieve the time spent
%   while walking (and vice-versa)
% - By using a different feature extraction technique we can obtain
%   different (more/less precise) results
% - We can even modify the threshold at 20% of the RMS (results shouldn't
%   differ too much from what we got here)
% - We can change the filter, thus obtaining different results (the signals
%   are somehow very noisy)
% - I will provide different version of the code just to show some of these
%   differences