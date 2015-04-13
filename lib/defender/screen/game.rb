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