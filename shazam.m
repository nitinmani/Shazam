% Main Shazam File

window_time = 0.37; % duration (sec) of each window
fs_target = 4000;   % desired sampling rate

n_bits_per_window = 16; % quantization of frequency
audio_directory = 'data';   % directory with test data
audio_database = sprintf('%s/db.mat', audio_directory); % database file


%% Database Prep
% find all the files in the data directory
files = getFiles(audio_directory);   

% load the database from a .mat file if it exists,
%  otherwise generate it from scratch and save it out.
if exist(audio_database, 'file') == 2
  load(audio_database,'songs');
  disp('Database loaded.')
else
  disp('Generating the database .... ')
  % TODO: implement makeDatabase
  songs = makeDatabase(files, window_time, fs_target, n_bits_per_window);
  save(audio_database,'songs');
  disp('Database constructed.');
end


%% Query Generation
disp('Generating query sample ... ')
% Play with these values and see how it affects performance!
SNR = 10;            % signal-to-noise ratio of queries in dB
query_length = 32;  % length of queries in features
threshold = 0.5;     % maximum error a "match" can have  

n_runs = 10;   % how many test queries to generate
incorrect = 0; % how many songs you guessed wrong
correct = 0;   % how many songs you correctly guessed
declined = 0;  % how many songs you didn't have an answer for
%testFiles = generateQuery(queryFilename, query_length, SNR, 0.37 , 4000, 16); 
%fileToReturn = testFiles(1);

for p = 1:n_runs
    % TODO: Shazam! Implement the algorithm, and measure correctness.
    fileNumber = randi(length(files),1);
    queryFilename = files{fileNumber};
    queryFeatures = generateQuery(queryFilename, query_length, SNR, 0.37 , 4000, 16);
    songToReturn = 0;
    minError = Inf;
    for q = 1:length(songs) 
        currentSong = songs(q).features; 
        for r = 1:length(currentSong) - query_length
            truncatedSong = currentSong(r:r+31);
            error = ber(queryFeatures, truncatedSong, n_bits_per_window);
            if(error >= threshold)
               continue
            end 
            if(error < minError)
                songToReturn = songs(q).name;
                minError = error;
            end 
        end
    end
    isCorrect = strcmp(queryFilename, songToReturn);
   disp(songToReturn);
   disp(queryFilename);
    if(isCorrect == 1)
        correct = correct + 1;
    end
    if(isCorrect == 0)
        incorrect = incorrect + 1;
    end
end


frac_correct = correct/(correct+incorrect);
fprintf('%g%% correct!\n', 100*frac_correct);
fprintf('  (Declined to answer %d/%d.)\n', declined, n_runs);

%%
-Inf = 10
-10 = 20
-3 =  50
 0 =  50
 3 =  80
 10 = 90
Inf = 100
