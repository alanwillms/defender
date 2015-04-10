module Defender
  module Helper
    class Audio
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
        end

        if source
          if is_sfx
            Gosu::Sample.new(Window.current_window, source).play
          else
            Gosu::Song.new(Window.current_window, source).play(true)
          end
        end
      end
    end
  end
end