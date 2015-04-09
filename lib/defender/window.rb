module Defender
  class Window < Gosu::Window
    def initialize
      # width, height, fullscreen
      super(960, 540, false)
      self.caption = 'Defender'

      @map = Map.new(self)

      @music = Gosu::Sample.new(self, "media/audio/music/digital_native.ogg")
      @music.play
    end

    # called 60 times per second
    # game main logic
    # move objects, handle collisions, etc.
    def update
    end

    # called after update
    # code to redraw the whole screen
    # no logic whatsoever
    def draw
      @map.draw
    end

    # Show system cursor
    def needs_cursor?
      true
    end

    def button_down(id)
      if id == Gosu::KbEscape
        close
      end
    end
  end
end