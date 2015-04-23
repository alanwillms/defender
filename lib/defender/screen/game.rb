class GameScreen < BaseScreen
  attr_reader :map, :menu
  attr_accessor :money

  def initialize
    set_attributes
    set_buildings
    set_monsters
    set_menu_items
    AudioHelper.play_song :background_music
  end

  def update
    @menu.update
    @map.update
    ToastHelper.update
  end

  def draw
    draw_background
    @map.draw
    @menu.draw
    ToastHelper.draw
  end

  def button_down(id)
    if id == Gosu::MsLeft
      @map.clicked
      @menu.clicked
    end
  end

  private

    def set_attributes
      screen_padding = Game.config[:screen_padding]
      inner_height = Game.config[:height] - (screen_padding * 2)
      inner_width = Game.config[:width] - (screen_padding * 2)
      menu_width = 5 * Game.config[:tile_size]
      map_size = 16 * Game.config[:tile_size]
      @money = 300
      @map = Map.new(self, 16, 16)
      @menu = Menu.new(self, menu_width, inner_height, map_size + screen_padding, screen_padding)
      @background_animation = Animation.new(:sea)
    end

    def set_buildings
      defending_city = DefendingCity.new(Cell.new(@map, @map.last_row, @map.last_column))
      monster_spawner = MonsterSpawner.new(Cell.new(@map, 0, 0))

      @map.build(defending_city)
      @map.build(monster_spawner)
      @map.build_random_walls
    end

    def set_monsters
      @map.monster_spawners.each do |monster_spawner|
        monster_spawner.spawn_wave
      end
    end

    def set_menu_items
      Game.config[:buildings].keys.each do |building_type|
        @menu.add_item(building_type, -> { puts "clicked" })
      end
    end

    def draw_background
      horizontal_count = (Game.current_window.width / MapHelper.tile_size).ceil
      vertical_count = (Game.current_window.height / MapHelper.tile_size).ceil
      for row in 0..vertical_count do
        for column in 0..horizontal_count do
          x = column * MapHelper.tile_size
          y = row * MapHelper.tile_size
          @background_animation.draw(x, y, 0)
        end
      end
    end
end