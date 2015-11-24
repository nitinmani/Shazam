% playAudio
function playAudio(audio, fs, play_time)
  % Plays audio signal audio for play_time seconds
  player = audioplayer(audio, fs);
  play(player);
  pause(play_time);
  stop(player);
end