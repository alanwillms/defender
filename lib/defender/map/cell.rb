class Cell
  attr_reader :map, :row, :column

  def initialize(map, row, column)
    if row < 0 or column < 0
      raise ArgumentError.new "Row and column must be positive"
    end
    @map = map
    @row = row
    @column = column
  end

  def point
    @point ||= Point.new(
      MapHelper.get_x_for_column(@column),
      MapHelper.get_y_for_row(@row),
      0
    )
  end

  def blocked?
    @map.maze.matrix[@row][@column] == Maze::PATH_BLOCKED
  end

  def block
    @map.maze.matrix[@row][@column] = Maze::PATH_BLOCKED
  end

  def would_block_any_path?
    current_row = @row
    current_column = @column
    @map.monster_spawners.each do |monster_spawner|
      @map.defending_cities.each do |defending_city|
        matrix = MapHelper.clone_matrix(@map.maze.matrix)
        matrix.each do |row|
          row.each_with_index do |value, index|
            if value == Maze::PATH_START or value == Maze::PATH_END
              row[index] = Maze::PATH_OPEN
            end
          end
        end

        matrix[current_row][current_column] = Maze::PATH_BLOCKED
        matrix[defending_city.cell.row][defending_city.cell.column] = Maze::PATH_END

        unless @map.maze.create_solver(matrix, monster_spawner.cell).has_solution?
          return true
        end
      end
    end
    return false
  end

  def would_block_any_monster?
    blocks = false
    matrix = MapHelper.clone_matrix(@map.maze.matrix)
    matrix[@row][@column] = Maze::PATH_BLOCKED
    @map.monsters.each do |monster|
      monster_matrix = MapHelper.clone_matrix(matrix)
      start_cell = Cell.new(@map, monster.current_row, monster.current_column)
      solver = @map.maze.create_solver(monster_matrix, start_cell)
      unless solver.has_solution?
        blocks = true
        break
      end
    end
    blocks
  end

  def self.random(map)
    Cell.new(map, rand(0..map.last_row), rand(0..map.last_column))
  end
end