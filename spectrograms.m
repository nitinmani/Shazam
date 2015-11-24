%% Windowing
T_samp = 0.1;
t = 0:T_samp:5;

% TODO calculate x as defined in the lab
x = sin((2*pi/5)*t);
stem(t, x);

% TODO Calculate the DFT of x(n)
X = fft(x);
stem(abs(X));

% TODO calculate xhat and the DFT of Xhat
that = 0:T_samp:6;
xhat = sin((2*pi/5)*that);
Xhat = fft(xhat);
N1 = length(X);
N2 = length(Xhat);
% TODO calculate DFT of Xhat with the Hamming window applied
w = hamming(N2); 
xhat_w = xhat.*w';
Xhat_w = fft(xhat_w);



% TODO determine omega1, omega2 for the plot
omega1 = (0:N1-1)*2*pi/N1;
omega2 = (0:N2-1)*2*pi/N2;

figure()
hold on
stem(omega2, abs(Xhat), 'b')
stem(omega2, abs(Xhat_w), 'g')
stem(omega1, abs(X), 'r')
legend('xhat', 'xhat windowed', 'x')
%% Exploring Spectrograms
load testAudio

% TODO plot DFTs of the testAudio and scrambledAudio signals
testAudioFFT = fft(testAudio);
plot(abs(testAudioFFT));
scrambledAudioFFT = fft(scrambledAudio);
plot(abs(scrambledAudioFFT));

% Calculate Spectrograms
window = 0.25 * fs;
overlap = 0.2 * fs;
[~,F,T,P] = spectrogram(testAudio, window, overlap, window, fs);
figure()
imagesc(T,F,10*log10(P)); axis tight; 
xlabel('Time (Seconds)'); 
ylabel('Hz')

% calculate and plot spectrogram of scrambledAudio
[~,F,T,P] = spectrogram(scrambledAudio,window,overlap,window,fs);
figure()
imagesc(T,F,10*log10(P)); 
axis tight;
xlabel('Time (Seconds)'); ylabel('Hz')


%% Create the mystery signal from the spectrogram

fs = 1000;  % Hz

% TODO create the signal and store it in a variable called 'signal'

% To play back the signal, uncomment the following line: 
% sound(signal, fs);

% Generate the spectrogram
window = 0.25 * fs;
overlap = 0.2 * fs;
[~,F,T,P] = spectrogram(signal, window, overlap, window, fs);

figure()
surf(T, F, 10*log10(P), 'edgecolor', 'none'); 
axis tight; 
view(0, 90);
xlabel('Time (Seconds)'); 
ylabel('Hz');

set(gcf(), 'PaperPosition', [0 0 3.5 2]);
set(gcf(), 'PaperSize', [3.5 2]);
saveas(gcf(), 'tonechirp', 'pdf')

%% mySpectrogram
filename = 'tone.wav';
nfft = 256;
noverlap = 50;

% Read in file; only take the spectrogram of the first column because it's
% a two-channel audio signal but we only care about 1 channel
[w, fs] = audioread(filename);
w = w(:,1);

% TODO implement the mySpectrogram function
myS = mySpectrogram(w, nfft, noverlap);
figure(1)
imagesc([0, length(w)/fs], [0 2], log(abs(myS)));
title('mySpectrogram()')
xlabel('Time (sec)')
ylabel('Frequency (\pi radians/sample)')

% call the matlab spectrogram function for comparison
figure(2)
S = spectrogram(w, nfft, noverlap, nfft, fs);
imagesc([0, length(w)/fs], [0 1], log(abs(S)))
title('spectrogram()')
xlabel('Time (sec)')
ylabel('Frequency (\pi radians/sample)')
