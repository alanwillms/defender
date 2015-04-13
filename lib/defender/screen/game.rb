class GameScreen < BaseScreen
  attr_reader :window, :defending_city, :monster_spawner, :map, :menu
  attr_accessor :money

  def initialize
    @money = 300
    @map = Map.new(self, inner_width - menu_width, inner_height)
    @menu = Menu.new(self, menu_width, inner_height, inner_width - menu_width + screen_padding, screen_padding)

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

  private

    def menu_width
      @menu_width ||= 5 * MapHelper.tile_size
    end

    def screen_padding
      MapHelper.screen_padding
    end

    def screen_width
      Window.current_window.width
    end

    def screen_height
      Window.current_window.height
    end

    def inner_height
      screen_height - (screen_padding * 2)
    end

    def inner_width
      screen_width - (screen_padding * 2)
    end
end