describe Maze do
  let :maze do
    map = instance_double('Map', rows: 3, columns: 3)
    monster_spawner = MonsterSpawner.new(Cell.new(map, 0, 0))
    defending_city = DefendingCity.new(Cell.new(map, 2, 2))

    allow(map).to receive(:monster_spawners).and_return([monster_spawner])
    allow(map).to receive(:defending_cities).and_return([defending_city])
    Maze.new(map)
  end

  context "#create_solver" do
    it "returns an instance of MazeSolver" do
      expect(maze.create_solver(maze.matrix, Cell.new(maze.map, 0, 0))).to be_a(MazeSolver)
    end
  end
end