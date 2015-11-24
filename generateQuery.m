function query = generateQuery(filename, query_length, SNR, window_time, fs_target, n_bits_per_window)

  % This function selects a random, noisy sample from the audio file filename
  %
  % Inputs:
  % filename - name of the file to sample from
  % SNR - amount of noise to add (signal-to-noise ratio in dB)
  % window_time - duration of the spectrogram window (in seconds)
  % fs_target - desired sampling rate (we'll use 4kHz)
  % n_bits_per_window - # of bits used to represent each time-slice of the spectrogram; we'll use 16
  %
  % Outputs:
  % features - query_length×1 vector of 16-bit decimal numbers, representing the noisy query
  [w, fs] = audioread(filename);
  w = w(:, 1);
  clean = resample(w,fs_target,fs);
  noisy = awgn(clean,SNR,'measured');
  noisyFeatures = extractFeatures(noisy, window_time * fs_target, n_bits_per_window);
  %noisyFeatures = extractFeatures(clean, window_time * fs_target, n_bits_per_window);
  query = zeros(32);
  randFeatureStart = randi(1, length(noisyFeatures));
  query = noisyFeatures(randFeatureStart:randFeatureStart+query_length-1);
end
