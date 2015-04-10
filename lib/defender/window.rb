module Defender
  class Window < Gosu::Window
    def initialize
      # width, height, fullscreen, update_interval (16.666666)
      super(960, 540, false)
      self.caption = 'Defender'

      menu_width = 5 * 32
      @map = Map.new(self, self.width - menu_width, self.height)
      @menu = Menu.new(self, menu_width, self.height, @map.max_width, 0)

      @music = Gosu::Sample.new(self, "media/audio/music/digital_native.ogg")
      @music.play

      @monster_anim = Gosu::Image::load_tiles(self, "media/images/monster_sprite.png", 32, 32, false)
      @monsters = Array.new
      monster = Monster.new(@monster_anim, @map.get_x_for_column(0), @map.get_y_for_row(0))
      monster.set_destination(@map.get_x_for_column(@map.columns - 1), @map.get_y_for_row(@map.rows - 1))
      @monsters.push(monster)
    end

    # called 60 times per second
    # game main logic
    # move objects, handle collisions, etc.
    def update
      @monsters.each do |monster|
        @map.set_next_destination_for(monster)
        monster.move
      end
    end

    # called after update
    # code to redraw the whole screen
    # no logic whatsoever
    def draw
      @map.draw
      @menu.draw
      @monsters.each do |monster|
        monster.draw
      end
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