module Defender
  module Screen
    class GameOver
      def initialize
        Helper::Audio.play(:game_over, false)
        @font = Gosu::Font.new(Window.current_window, Gosu::default_font_name, 20)
      end

      def update
      end

      def draw
        @font.draw("GAME OVER!", 64, 64, ZOrder::UI, 3, 3)
      end

      def button_down(id)
      end
    end
  end
end