class Map
  attr_reader :max_width, :max_height, :rows, :columns, :last_row, :last_column, :monsters, :screen
  attr_accessor :wave

  def initialize(screen, max_width, max_height)
    @screen = screen
    @max_width = max_width
    @max_height = max_height
    @wave = 0

    @columns = @max_width.to_i / MapHelper.tile_size
    @rows = @max_height.to_i / MapHelper.tile_size
    @last_column = @columns - 1
    @last_row = @rows - 1

    @buildings_map = MapHelper.create_matrix(@rows, @columns)
    @monsters = []
  end

  def maze
    @maze ||= Maze.new(self)
  end

  def unspawn_monster(monster)
    @monsters.delete monster

    if @monsters.empty?
      monster_spawners.each do |monster_spawner|
        monster_spawner.spawn_wave
      end
      @wave += 1
    end
  end

  def buildings
    list = []
    @buildings_map.each do |row|
      row.each do |building|
        unless building.nil?
          list.push(building)
        end
      end
    end
    list
  end

  def defending_cities
    buildings.find_all { |building| building.is_a? DefendingCity }
  end

  def monster_spawners
    buildings.find_all { |building| building.is_a? MonsterSpawner }
  end

  def defenses
    buildings.find_all { |building| building.is_a? Defense }
  end

  def health_points
    hp = 0
    defending_cities.each do |building|
      hp += building.health_points
    end
    hp
  end

  def buildings_count
    counter = 0
    @buildings_map.each do |row|
      row.each do |cell|
        unless cell.nil?
          counter += 1
        end
      end
    end
    counter
  end

  def build_random_walls
    rand(1..(@rows*@columns/5)).times do
      row, column = *random_cell
      if can_build_at?(row, column)
        wall = Wall.new(self, row, column)
        build(wall, row, column)
      end
    end
  end

  def build(object, row, column)
    @buildings_map[row][column] = object
    unless object.is_a?(MonsterSpawner) or object.is_a?(DefendingCity)
      maze.block(row, column)
    end
  end

  def pay(cost)
    @screen.money = @screen.money - cost
  end

  def has_element_at?(row, column)
    @buildings_map[row][column].nil? == false
  end

  def draw
    for column in 0...@columns do
      for row in 0...@rows do
        x = MapHelper.get_x_for_column(column)
        y = MapHelper.get_y_for_row(row)

        SpriteHelper.image(:floor).draw(x, y, ZOrder::Background)

        unless @buildings_map[row][column].nil?
          @buildings_map[row][column].draw
        end
      end
    end
    @monsters.each do |monster|
      monster.draw
    end
  end

  def monster_at_defending_city?(monster)
    monster_row = MapHelper.get_row_for_y(monster.y)
    monster_column = MapHelper.get_column_for_x(monster.x)
    monster_row == @last_row and monster_column == @last_column
  end

  def update
    @monsters.each do |monster|
      monster.find_target
      monster.move

      defending_cities.each do |defending_city|
        if defending_city.monster_arrived?(monster)
          monster.attack! defending_city
          unspawn_monster monster
          AudioHelper.play(:monster_attack)
          if defending_city.health_points <= 0
            @maze.block(defending_city.row, defending_city.column)
          end
        end
      end

      defenses.each do |defense|
        if defense.cooled_down? and defense.monster_at_range?(monster)
          defense.shoot! monster
          AudioHelper.play(:defense_shot)
          if monster.health_points <= 0
            unspawn_monster monster
            @screen.money += (monster.money_loot * @wave)
            AudioHelper.play(:monster_death)
          end
        end
      end
    end

    if health_points <= 0
      return Game.current_window.current_screen = GameOverScreen.new
    end
  end

  def clicked
    mouse_x = Game.current_window.mouse_x
    mouse_y = Game.current_window.mouse_y
    x1 = 0
    x2 = MapHelper.get_x_for_column(@last_column) + MapHelper.tile_size
    y1 = 0
    y2 = MapHelper.get_y_for_row(@last_row) + MapHelper.tile_size
    x_inside = (mouse_x >= x1 and mouse_x <= x2)
    y_inside = (mouse_y >= y1 and mouse_y <= y2)

    if x_inside and y_inside

      clicked_column = MapHelper.get_column_for_x(mouse_x.to_i)
      clicked_row = MapHelper.get_row_for_y(mouse_y.to_i)

      if clicked_column < 0 or clicked_column > @last_column or clicked_row < 0 or clicked_row > @last_row
        return
      end

      defense_type = @screen.menu.selected_item.defense_type
      defense = Defense.new(self, clicked_row, clicked_column, defense_type)

      can_pay = can_pay_for? defense.cost
      can_build = can_build_at?(clicked_row, clicked_column)

      if can_pay and can_build
        build(defense, clicked_row, clicked_column)
        pay(defense.cost)
        AudioHelper.play :defense_built
      else
        AudioHelper.play :cant_build

        if not can_pay
          ToastHelper.add_message('Not enough money!', :error)
        elsif not can_build
          ToastHelper.add_message('You can\'t build it here!', :error)
        end
      end
    end
  end

  private

    def random_cell
      [rand(0..@last_row), rand(0..@last_column)]
    end

    def can_pay_for?(cost)
      cost <= @screen.money
    end

    def can_build_at?(row, column)
      at_blocked_cell = has_element_at?(row, column)
      blocks_path = maze.block_all_paths?(row, column)
      blocks_monster = block_any_monster_path?(row, column)

      DebugHelper.string("at_blocked_cell: #{at_blocked_cell.inspect}")
      DebugHelper.string("blocks_path: #{blocks_path.inspect}")
      DebugHelper.string("blocks_monster: #{blocks_monster.inspect}")

      not (at_blocked_cell or blocks_path or blocks_monster)
    end

    def block_any_monster_path?(row, column)
      blocks = false
      matrix = MapHelper.clone_matrix(maze.matrix)
      matrix[row][column] = Maze::PATH_BLOCKED
      @monsters.each do |monster|
        monster_matrix = MapHelper.clone_matrix(matrix)
        solver = maze.create_solution(monster_matrix, monster.current_row, monster.current_column)
        unless solver.has_solution?
          blocks = true
          break
        end
      end
      blocks
    end
end