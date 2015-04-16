class AudioHelper
  @@audios = {}

  def self.play(effect, is_sfx = true)
    source = nil

    case effect
      when :background_music
        source = "media/audio/music/digital_native.ogg"
      when :defense_built
        source = "media/audio/sfx/defense_built.wav"
      when :monster_attack
        source = "media/audio/sfx/monster_attack.wav"
      when :cant_build
        source = "media/audio/sfx/error.wav"
      when :game_over
        source = "media/audio/music/we_are_all_under_the_stars.ogg"
      when :defense_shot
        source = "media/audio/sfx/defense_shot.wav"
      when :monster_death
        source = "media/audio/sfx/monster_death.wav"
    end

    if source
      identifier = (source + '_' + is_sfx.to_s).to_sym
      if @@audios[identifier].nil?
        if is_sfx
          @@audios[identifier] = Gosu::Sample.new(Game.current_window, source)
        else
          @@audios[identifier] = Gosu::Song.new(Game.current_window, source)
        end
      end
      audio = @@audios[identifier]
      if is_sfx
        audio.play
      else
        audio.play(true)
      end
    end
  end
end