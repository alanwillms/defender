module Defender
  class Window < Gosu::Window
    attr_accessor :current_screen

    def initialize
      # width, height, fullscreen, update_interval (16.666666)
      super(960, 540, false)
      self.caption = 'Defender'

      @current_screen = Screen::Game.new(self)
    end

    # called 60 times per second
    # game main logic
    # move objects, handle collisions, etc.
    def update
      @current_screen.update
    end

    # called after update
    # code to redraw the whole screen
    # no logic whatsoever
    def draw
      @current_screen.draw
    end

    # Show system cursor
    def needs_cursor?
      true
    end

    def button_down(id)
      if id == Gosu::KbEscape
        close
      end
      @current_screen.button_down(id)
    end
  end
end