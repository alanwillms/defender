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

  attr_reader :matrix, :solution

  def initialize(rows, columns)
    @rows = rows
    @columns = columns
    # @matrix = create_matrix
    @matrix = load_matrix
    @solution = create_solution(@matrix)
  end

  def block(row, column)
    @matrix[row][column] = PATH_BLOCKED
    @solution = create_solution(@matrix)
  end

  def block_all_paths?(current_row, current_column)
    matrix = MapHelper.clone_matrix(@matrix)
    matrix[current_row][current_column] = PATH_BLOCKED
    solved_path = create_solution(matrix).solution
    blocked_all_paths = true
    for row in 0...@rows do
      for column in 0...@columns do
        current_cell = solved_path[row][column]
        if current_cell == PATH_GO_UP or current_cell == PATH_GO_DOWN or current_cell == PATH_GO_LEFT or current_cell == PATH_GO_RIGHT
          blocked_all_paths = false
          break
        end
      end
    end
    blocked_all_paths
  end

  private
    def create_matrix
      matrix = []
      for row in 0...@rows do
        matrix.push([])
        for column in 0...@columns do
          matrix[row].push(PATH_OPEN)
        end
      end
      matrix[@rows - 1][@columns - 1] = PATH_END
      matrix
    end

    def load_matrix
      [
        ['.','.','.','.','.','#','.','#','.','.','.','.','.','.','.','.','.','.','.','.','.','.','.','.','.'],
        ['#','#','#','#','.','.','#','#','.','.','.','.','.','.','.','.','.','.','.','.','.','.','.','.','.'],
        ['.','.','.','.','#','.','#','#','#','#','#','#','#','#','.','.','.','.','.','.','.','.','.','.','.'],
        ['.','.','.','#','.','.','#','#','.','.','.','.','.','.','#','#','.','.','.','.','.','.','.','.','.'],
        ['.','.','#','.','.','#','#','#','.','#','#','#','#','.','.','#','.','.','.','.','.','.','.','.','.'],
        ['#','#','.','.','#','#','#','#','.','#','.','.','#','.','.','.','#','.','.','.','.','.','.','.','.'],
        ['.','.','.','#','#','#','#','#','.','.','#','.','.','.','.','.','#','.','.','.','.','.','.','.','.'],
        ['.','#','#','#','#','#','#','#','#','.','.','#','.','.','.','.','#','.','.','.','.','.','.','.','.'],
        ['.','#','.','.','.','.','.','.','#','#','.','.','#','.','.','.','#','.','.','.','.','.','.','.','.'],
        ['.','.','.','#','#','#','#','.','.','#','#','.','.','#','.','.','#','.','.','.','.','.','.','.','.'],
        ['.','#','#','.','.','.','.','#','.','.','#','#','.','.','#','.','#','.','.','.','.','.','.','.','.'],
        ['#','.','.','.','.','.','.','.','#','.','.','#','#','.','#','.','#','.','.','.','.','.','.','.','.'],
        ['.','.','.','.','.','.','.','.','.','#','.','.','.','.','#','.','#','.','.','.','.','.','.','.','.'],
        ['.','.','.','.','.','.','.','.','.','.','#','#','#','#','.','.','#','.','.','.','.','.','.','.','.'],
        ['.','.','.','.','.','.','.','.','.','.','.','#','#','.','.','.','#','#','#','#','#','#','#','#','#'],
        ['.','.','.','.','.','.','.','.','.','.','.','.','.','.','.','.','.','.','.','.','.','.','.','.','G'],
      ]
    end

    def create_solution(matrix)
      MazeSolver.new(MapHelper.clone_matrix(matrix), 0, 0)
    end
end