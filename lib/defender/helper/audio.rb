module Defender
  module Helper
    class Audio
      def self.play(window, effect, options = {})
        source = nil

        case effect
          when :background_music
            source = "media/audio/music/digital_native.ogg"
          when :defense_built
            source = "media/audio/sfx/defense_built.wav"
          when :monster_attack
            source = "media/audio/sfx/monster_attack.wav"
        end

        if source
          sound = Gosu::Sample.new(window, source)
          sound.play
        end
      end
    end
  end
end