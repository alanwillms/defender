module Defender
  module Screen
    class Game
      attr_reader :window, :health_points

      def initialize
        menu_width = 5 * 32
        @map = Map.new(Window.current_window.width - menu_width, Window.current_window.height)
        @menu = Menu.new(self, menu_width, Window.current_window.height, @map.max_width, 0)

        @health_points = 100

        Helper::Audio.play(:background_music, false)

        @monster_spawner = MonsterSpawner.new(@map)
        @monster_spawner.spawn_wave
      end

      def update
        @monster_spawner.monsters.each_with_index do |monster, index|
          @map.set_next_destination_for(monster)
          monster.move
          if @map.monster_at_defending_city?(monster)
            @health_points -= monster.attack
            @monster_spawner.unspawn(monster)
            Helper::Audio.play(:monster_attack)

            if @health_points <= 0
              return Window.current_window.current_screen = GameOver.new
            end
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
          @map.on_click(Window.current_window.mouse_x, Window.current_window.mouse_y)
        end
      end
    end

    class Menu
      def initialize(screen, width, height, x, y)
        @screen = screen
        @x = x
        @y = y
        @width = width
        @height = height
      end

      def draw
        Helper::Sprite.font.draw("Defender", @x + 32, @y + 32, ZOrder::UI)
        Helper::Sprite.font.draw("HP = #{@screen.health_points}", @x + 32, @y + (32 * 2), ZOrder::UI)
        Helper::Sprite.image(:defense_button).draw(@x + 32, @y + (3 * 32), ZOrder::UI)
      end
    end
  end
end