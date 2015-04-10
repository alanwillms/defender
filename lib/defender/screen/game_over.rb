module Defender
  module Screen
    class GameOver
      def initialize
        Helper::Audio.play(:game_over, false)
      end

      def update
      end

      def draw
        Helper::Sprite.font.draw("GAME OVER!", 64, 64, ZOrder::UI, 3, 3)
      end

      def button_down(id)
      end
    end
  end
end