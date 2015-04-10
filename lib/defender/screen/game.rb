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

        Helper::Audio.play(@window, :background_music, false)

        @monster_spawner = MonsterSpawner.new(@map)
        @monster_spawner.spawn
      end

      def update
        @monster_spawner.monsters.each_with_index do |monster, index|
          @map.set_next_destination_for(monster)
          monster.move
          if @map.monster_at_defending_city?(monster)
            @health_points -= monster.attack
            @monster_spawner.unspawn(monster)
            Helper::Audio.play(@window, :monster_attack)

            if @health_points <= 0
              return @window.current_screen = GameOver.new(@window)
            end

            @monster_spawner.spawn
          end
        end
      end

      def draw
        @map.draw
        @menu.draw
        @monster_spawner.monsters.each do |monster|
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