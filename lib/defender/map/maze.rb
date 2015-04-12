class Maze
  PATH_START = 'S'
  PATH_END = 'G'
  PATH_OPEN = '.'
  PATH_BLOCKED = '#'
  PATH_RIGHT = '+'
  PATH_WRONG = 'x'
  PATH_GO_UP = '↑'
  PATH_GO_RIGHT = '→'
  PATH_GO_DOWN = '↓'
  PATH_GO_LEFT = '←'

  attr_reader :matrix

  def initialize(map)
    @map = map
    @matrix = create_matrix
  end

  def cell_blocked?(row, column)
    @matrix[row][column] == Maze::PATH_BLOCKED
  end

  def block(row, column)
    @matrix[row][column] = PATH_BLOCKED
  end

  # Check if ALL monster spawners are not blocked until the exit(s)
  def block_all_paths?(current_row, current_column)
    matrix = MapHelper.clone_matrix(@matrix)
    matrix[current_row][current_column] = PATH_BLOCKED
    @map.buildings.each do |building|
      if building.is_a? MonsterSpawner
        unless create_solution(matrix, building.row, building.column).has_solution?
          return true
        end
      end
    end
    return false
  end

  def create_solution(matrix, start_row, start_column)
    MazeSolver.new(MapHelper.clone_matrix(matrix), start_row, start_column)
  end

  private
    def create_matrix
      matrix = MapHelper.create_matrix(@map.rows, @map.columns, PATH_OPEN)
      @map.buildings.each do |building|
        if building.is_a? DefendingCity
          matrix[building.row][building.column] = PATH_END
        end
      end
      matrix
    end
end