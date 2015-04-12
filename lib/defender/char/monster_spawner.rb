class MonsterSpawner
  attr_reader :monsters, :map, :x, :y
  ROW = 0
  COLUMN = 0

  def initialize(map)
    @map = map
    @monsters = Array.new
    @wave = 1
  end

  def spawn_wave
    for i in 0...@wave do
      spawn
    end
    @wave += 1
  end

  def unspawn(monster)
    @monsters.delete monster

    if @monsters.empty?
      spawn_wave
    end
  end

  def draw(x, y, z)
    SpriteHelper.image(:monster_spawner).draw(x, y, z)
  end

  def block_any_monster_path?(row, column)
    blocks = false
    matrix = MapHelper.clone_matrix(@map.maze.matrix)
    matrix[row][column] = Maze::PATH_BLOCKED
    @monsters.each do |monster|
      monster_matrix = MapHelper.clone_matrix(matrix)
      solver = @map.maze.create_solution(monster_matrix, monster.current_row, monster.current_column)
      unless solver.has_solution?
        blocks = true
        break
      end
    end
    blocks
  end

  private

    def spawn
      speed = rand(1..4)
      monster = Monster.new(@map.maze, speed)
      monster.warp(ROW, COLUMN)
      monster.find_target
      @monsters.push(monster)
      monster
    end
end