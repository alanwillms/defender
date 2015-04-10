module Defender
  class Window < Gosu::Window
    attr_reader :health_points

    def initialize
      # width, height, fullscreen, update_interval (16.666666)
      super(960, 540, false)
      self.caption = 'Defender'

      menu_width = 5 * 32
      @map = Map.new(self, self.width - menu_width, self.height)
      @menu = Menu.new(self, menu_width, self.height, @map.max_width, 0)

      @health_points = 100

      Helper::Audio.play(self, :background_music, repeat: true)

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
      @monsters.each_with_index do |monster, index|
        @map.set_next_destination_for(monster)
        monster.move
        if @map.monster_at_defending_city?(monster)
          @health_points -= monster.attack
          @monsters.delete_at index
          Helper::Audio.play(self, :monster_attack)

          monster = Monster.new(@monster_anim, @map.get_x_for_column(0), @map.get_y_for_row(0))
          monster.set_destination(@map.get_x_for_column(@map.columns - 1), @map.get_y_for_row(@map.rows - 1))
          @monsters.push(monster)
        end
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
      if id == Gosu::MsLeft
        @map.on_click(mouse_x, mouse_y)
      end
    end
  end
end