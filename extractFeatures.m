function features = extractFeatures(audio, window_samples, n_bits_per_window)

  % This function extracts features from the audio file 'filename'
  %
  % Inputs:
  % audio - column vector representing the audio waveform
  % window_samples - duration of the spectrogram window (in samples)
  % n_bits_per_window - # of bits used to represent each time-slice of the spectrogram; we'll use 16
  %
  % Outputs:
  % features - Nx1 vector of 16-bit decimal numbers, representing the
  %           features of this audio file, where N is related to the 
  %           length of the audio.
[~,F,T,P] = spectrogram(audio,window_samples);

band_remainder = mod(length(F), (n_bits_per_window + 1));
band_size = floor(length(F) / (n_bits_per_window + 1));
size(P);
size(audio);
size(F);
size(T);
chunks = (ones(1, n_bits_per_window + 1) .* band_size) + horzcat(ones(1, band_remainder), zeros(1, n_bits_per_window + 1 - band_remainder));
  
bands = mat2cell(P, chunks, ones(1, length(T)));

summed_bands = cellfun(@sum, bands);
[m, n] = size(summed_bands);
split_bands = mat2cell(summed_bands, n_bits_per_window + 1, ones(1, n));

compared_bands = cellfun(@(x) uint16(x(1:16) > x(2:17)), split_bands, 'UniformOutput', false);
features = zeros(n, 1);
for i = 1:n
    number = 0;
    for j = 1:16
        number = number + compared_bands{i}(j) * 2 ^ (j - 1);
    end
    features(i) = number;
end

    
end