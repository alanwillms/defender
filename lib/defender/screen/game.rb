module Defender
  module Screen
    class Game
      attr_reader :window, :health_points

      def initialize(window)
        @window = window
        menu_width = 5 * 32
        @map = Map.new(@window, @window.width - menu_width, @window.height)
        @menu = Menu.new(self, menu_width, @window.height, @map.max_width, 0)

        @health_points = 100

        Helper::Audio.play(@window, :background_music, repeat: true)

        @monster_anim = Gosu::Image::load_tiles(@window, "media/images/monster_sprite.png", 32, 32, false)
        @monsters = Array.new
        monster = Monster.new(@monster_anim, @map.get_x_for_column(0), @map.get_y_for_row(0))
        monster.set_destination(@map.get_x_for_column(@map.columns - 1), @map.get_y_for_row(@map.rows - 1))
        @monsters.push(monster)
      end

      def update
        @monsters.each_with_index do |monster, index|
          @map.set_next_destination_for(monster)
          monster.move
          if @map.monster_at_defending_city?(monster)
            @health_points -= monster.attack
            @monsters.delete_at index
            Helper::Audio.play(@window, :monster_attack)

            monster = Monster.new(@monster_anim, @map.get_x_for_column(0), @map.get_y_for_row(0))
            monster.set_destination(@map.get_x_for_column(@map.columns - 1), @map.get_y_for_row(@map.rows - 1))
            @monsters.push(monster)
          end
        end
      end

      def draw
        @map.draw
        @menu.draw
        @monsters.each do |monster|
          monster.draw
        end
      end

      def button_down(id)
        if id == Gosu::MsLeft
          @map.on_click(@window.mouse_x, @window.mouse_y)
        end
      end
    end

    class Menu
      def initialize(screen, width, height, x, y)
        @screen = screen
        @window = screen.window
        @x = x
        @y = y
        @width = width
        @height = height
        @defense_button = Gosu::Image.new(@window, "media/images/defense.png", true)
        @font = Gosu::Font.new(@window, Gosu::default_font_name, 20)
      end

      def draw
        @font.draw("Defender", @x + 32, @y + 32, ZOrder::UI)
        @font.draw("HP = #{@screen.health_points}", @x + 32, @y + (32 * 2), ZOrder::UI)
        @defense_button.draw(@x + 32, @y + (3 * 32), ZOrder::UI)
      end
    end
  end
end