class GameScreen < BaseScreen
  attr_reader :window, :defending_city, :monster_spawner

  def initialize
    menu_width = 5 * 32
    @map = Map.new(Window.current_window.width - menu_width, Window.current_window.height)
    @menu = Menu.new(self, menu_width, Window.current_window.height, @map.max_width, 0)
    AudioHelper.play(:background_music, false)

    @defending_city = DefendingCity.new(@map)
    @monster_spawner = MonsterSpawner.new(@map)
    @map.build_at!(@monster_spawner, 0, 0)
    @map.build_at!(@defending_city, @map.last_row, @map.last_column)
    @map.build_random_walls

    @monster_spawner.spawn_wave
  end

  def update
    @monster_spawner.monsters.each_with_index do |monster, index|
      monster.find_target
      monster.move
      if @map.monster_at_defending_city?(monster)
        monster.attack!(@defending_city)
        @monster_spawner.unspawn(monster)
        AudioHelper.play(:monster_attack)

        if @defending_city.health_points <= 0
          return Window.current_window.current_screen = GameOverScreen.new
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
    SpriteHelper.font.draw("Defender", @x + 32, @y + 32, ZOrder::UI)
    SpriteHelper.font.draw("HP = #{@screen.defending_city.health_points}", @x + 32, @y + (32 * 2), ZOrder::UI)
    SpriteHelper.image(:defense_button).draw(@x + 32, @y + (3 * 32), ZOrder::UI)
  end
end
