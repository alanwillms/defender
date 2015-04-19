class AudioHelper
  @@sounds = {}
  @@songs = {}

  def self.play_sound(sound)
    source = Game.config[:sounds][sound]
    if source
      @@sounds[sound] ||= Gosu::Sample.new(Game.current_window, source)
      @@sounds[sound].play
    end
  end

  def self.play_song(song)
    source = Game.config[:songs][song]
    if source
      @@songs[song] ||= Gosu::Song.new(Game.current_window, source)
      @@songs[song].play(true)
    end
  end
end