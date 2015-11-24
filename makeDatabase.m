function songs = makeDatabase(files, window_time, fs_target, n_bits_per_window)
  % This function creates a struct array with feature information for all the
  % songs in the database
  %
  % Inputs:
  % files - list of all the files in the database
  % window_time - duration of the spectrogram window (in seconds)
  % fs_target - desired sampling rate (we'll use 4kHz)
  % n_bits_per_window - # of bits used to represent each time-slice of the spectrogram; we'll use 16
  %
  % Outputs:
  % songs - cell array of features for each song lised in 'filelist'; this is a 
  %         "database" of all the spectrograms our recognition system will know about
  
  % preallocate the struct array
  songs(length(files)).name = [];
  songs(length(files)).features = [];
 
  for i = 1:(length(files))
    [w, fs] = audioread(files{i});
    w = w(:,1);
    w = resample(w,fs_target,fs);
    features = extractFeatures(w, fs_target * window_time,n_bits_per_window);
    songs(i).name = files{i};
    songs(i).features = features;  
  
  

  
end
