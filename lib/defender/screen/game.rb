class GameScreen < BaseScreen
  MENU_WIDTH = 160

  attr_reader :window, :defending_city, :monster_spawner, :map
  attr_accessor :money

  def initialize
    @money = 300
    @map = Map.new(self, Window.current_window.width - MENU_WIDTH, Window.current_window.height)
    @menu = Menu.new(self, MENU_WIDTH, Window.current_window.height, @map.max_width, 0)

    DefendingCity.new(@map, @map.last_row, @map.last_column)
    MonsterSpawner.new(@map, 0, 0).spawn_wave

    @map.build_random_walls

    AudioHelper.play(:background_music, false)
  end

  def update
    @map.monsters.each do |monster|
      monster.find_target
      monster.move

      @map.defending_cities.each do |defending_city|
        if defending_city.monster_arrived?(monster)
          monster.attack! defending_city
          @map.unspawn_monster monster
          AudioHelper.play(:monster_attack)
          if defending_city.health_points <= 0
            @map.maze.block(defending_city.row, defending_city.column)
          end
        end
      end

      @map.defenses.each do |defense|
        if defense.cooled_down? and defense.monster_at_range?(monster)
          defense.shoot! monster
          AudioHelper.play(:defense_shot)
          if monster.health_points <= 0
            @map.unspawn_monster monster
            @map.screen.money += monster.money_loot
            AudioHelper.play(:monster_death)
          end
        end
      end
    end

    if @map.health_points <= 0
      return Window.current_window.current_screen = GameOverScreen.new
    end
  end

  def draw
    @map.draw
    @menu.draw
    @map.monsters.each do |monster|
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
    padding = 16
    x = (@x + padding)
    y = (@y + padding)
    SpriteHelper.font.draw("Defender", x, y, ZOrder::UI)
    SpriteHelper.font.draw("Money = #{@screen.money}", x, y + (32 * 1), ZOrder::UI)
    SpriteHelper.font.draw("HP = #{@screen.map.health_points}", x, y + (32 * 2), ZOrder::UI)
    SpriteHelper.font.draw("Buildings = #{@screen.map.buildings_count}", x, y + (32 * 3), ZOrder::UI)
    SpriteHelper.font.draw("Monsters = #{@screen.map.monsters.size}", x, y + (32 * 4), ZOrder::UI)
    SpriteHelper.image(:defense_button).draw(x, y + (32 * 5), ZOrder::UI)
  end
end
