class Map
  attr_reader :rows, :columns, :last_row, :last_column, :monsters, :screen
  attr_accessor :wave

  def initialize(screen, rows, columns)
    @screen = screen
    @wave = 0

    @columns = columns
    @rows = rows
    @last_column = columns - 1
    @last_row = rows - 1

    @buildings_map = MapHelper.create_matrix(rows, columns)
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

  def build_random_walls
    rand(1..(@rows*@columns/5)).times do
      cell = Cell.random(self)
      if can_build_at?(cell)
        build(Building.new(cell, :wall))
      end
    end
  end

  def build(object)
    @buildings_map[object.cell.row][object.cell.column] = object
    unless object.is_a?(MonsterSpawner) or object.is_a?(DefendingCity)
      object.cell.block
    end
  end

  def pay(cost)
    @screen.money = @screen.money - cost
  end

  def has_element_at?(cell)
    @buildings_map[cell.row][cell.column].nil? == false
  end

  def draw
    for column in 0...@columns do
      for row in 0...@rows do
        x = MapHelper.get_x_for_column(column)
        y = MapHelper.get_y_for_row(row)

        SpriteHelper.image(:floor).draw_resized(x, y, ZOrder::Background)

        unless @buildings_map[row][column].nil?
          @buildings_map[row][column].draw
        end
      end
    end
    @monsters.each do |monster|
      monster.draw
    end
  end

  def update
    @monsters.each do |monster|
      monster.find_target
      monster.move

      defending_cities.each do |defending_city|
        if defending_city.monster_arrived?(monster)
          monster.attack! defending_city
          unspawn_monster monster
          AudioHelper.play_sound :monster_attack
          if defending_city.health_points == 0
            defending_city.cell.block
          end
        end
      end

      defenses.each do |defense|
        if defense.cooled_down? and defense.monster_at_range?(monster)
          defense.shoot! monster
          AudioHelper.play_sound :defense_shot
          if monster.health_points <= 0
            unspawn_monster monster
            @screen.money += (monster.money_loot * @wave)
            AudioHelper.play_sound :monster_death
          end
        end
      end
    end

    if health_points <= 0
      return Game.current_window.current_screen = GameOverScreen.new
    end
  end

  def clicked
    if mouse_over
      defense_type = @screen.menu.selected_item.defense_type
      defense = Defense.new(clicked_cell, defense_type)

      can_pay = can_pay_for? defense.cost
      can_build = can_build_at? defense.cell

      if can_pay and can_build
        build defense
        pay defense.cost
        AudioHelper.play_sound :defense_built
      else
        AudioHelper.play_sound :cant_build

        if not can_pay
          ToastHelper.add_message('Not enough money!', :error)
        elsif not can_build
          ToastHelper.add_message('You can\'t build it here!', :error)
        end
      end
    end
  end

  private

    def mouse_over
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

        unless clicked_column < 0 or clicked_column > @last_column or clicked_row < 0 or clicked_row > @last_row
          return true
        end
      end
      false
    end

    def clicked_cell
      if mouse_over
        clicked_column = MapHelper.get_column_for_x(Game.current_window.mouse_x.to_i)
        clicked_row = MapHelper.get_row_for_y(Game.current_window.mouse_y.to_i)
        Cell.new(self, clicked_row, clicked_column)
      end
    end

    def can_pay_for?(cost)
      cost <= @screen.money
    end

    def can_build_at?(cell)
      at_blocked_cell = has_element_at?(cell)
      blocks_path = cell.would_block_any_path?
      blocks_monster = cell.would_block_any_monster?

      DebugHelper.string("at_blocked_cell: #{at_blocked_cell.inspect}")
      DebugHelper.string("blocks_path: #{blocks_path.inspect}")
      DebugHelper.string("blocks_monster: #{blocks_monster.inspect}")

      not (at_blocked_cell or blocks_path or blocks_monster)
    end
end