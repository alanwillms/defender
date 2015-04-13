class GameScreen < BaseScreen
  MENU_WIDTH = 160

  attr_reader :window, :defending_city, :monster_spawner, :map, :menu
  attr_accessor :money

  def initialize
    @money = 300
    @map = Map.new(self, Window.current_window.width - MENU_WIDTH, Window.current_window.height)
    @menu = Menu.new(self, MENU_WIDTH, Window.current_window.height, @map.max_width, 0)

    defending_city = DefendingCity.new(@map, @map.last_row, @map.last_column)
    monster_spawner = MonsterSpawner.new(@map, 0, 0)

    @map.build(defending_city, @map.last_row, @map.last_column)
    @map.build(monster_spawner, 0, 0)
    @map.build_random_walls
    monster_spawner.spawn_wave

    Building.types.keys.each do |building_type|
      puts building_type.inspect
      @menu.add_item(building_type, -> { puts "clicked" })
    end

    AudioHelper.play(:background_music, false)
  end

  def update
    @menu.update
    @map.update
  end

  def draw
    @map.draw
    @menu.draw
  end

  def button_down(id)
    if id == Gosu::MsLeft
      @map.clicked
      @menu.clicked
    end
  end
end