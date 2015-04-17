describe Monster do
  monster_settings = {
    speed: 10,
    max_speed: 10,
    life: 50,
    damage: 10,
    shield: 0,
    money: 5
  }

  let :image do
    image = instance_double("Gosu::Image")
    allow(image).to receive(:width).and_return(32)
    allow(image).to receive(:height).and_return(32)
    image
  end

  let :monster do
    maze = double('Maze')
    maze_solver = double('MazeSolver')
    allow(maze).to receive(:matrix).and_return({})
    allow(maze).to receive(:create_solution).and_return(maze_solver)
    type = :example
    Monster.new(maze, type)
  end

  let :target do
    double('Building')
  end

  before :each do
    allow(Game).to receive(:config).and_return({monsters: {example: monster_settings}})
    allow(MapHelper).to receive(:tile_size).and_return(32)
    allow(MapHelper).to receive(:screen_padding).and_return(0)
    tileset = []
    (Monster::SPRITE_FRAMES_COUNT * 4).times { tileset << image }
    allow(SpriteHelper).to receive(:tiles).and_return(tileset)
  end

  context "#warp" do
    it "changes monster row, column, x and y" do
      monster.warp(1, 1)
      expect(monster.x).to eq(32)
      expect(monster.y).to eq(32)
      expect(monster.current_row).to eq(1)
      expect(monster.current_column).to eq(1)
    end
  end

  context "#attack!" do
    context "target has more health points than damage suffered" do
      it "reduces target health_points" do
        allow(target).to receive(:health_points).and_return(30)
        expect(target).to receive(:health_points=).with(30 - monster_settings[:damage])
        monster.attack! target
      end
    end

    context "target has more health points than damage suffered" do
      it "zero target health_points" do
        allow(target).to receive(:health_points).and_return(1)
        expect(target).to receive(:health_points=).with(0)
        monster.attack! target
      end
    end
  end

  context "#find_target" do
    it "sets target x and y positions" do
      allow(monster.maze_solver).to receive(:next_position_for).and_return([0, 1])
      monster.warp(0, 0)
      monster.find_target
      expect(monster.target_x).to be(32)
      expect(monster.target_y).to be(0)
    end

    it "turn up if y decreased" do
      allow(monster.maze_solver).to receive(:next_position_for).and_return([0, 1])
      monster.warp(1, 1)
      monster.find_target
      expect(monster.facing).to be(Monster::SPRITE_UP_POSITION)
    end

    it "turn down if y increased" do
      allow(monster.maze_solver).to receive(:next_position_for).and_return([2, 1])
      monster.warp(1, 1)
      monster.find_target
      expect(monster.facing).to be(Monster::SPRITE_DOWN_POSITION)
    end

    it "turn left if x decreased" do
      allow(monster.maze_solver).to receive(:next_position_for).and_return([1, 0])
      monster.warp(1, 1)
      monster.find_target
      expect(monster.facing).to be(Monster::SPRITE_LEFT_POSITION)
    end

    it "turn right if x increased" do
      allow(monster.maze_solver).to receive(:next_position_for).and_return([1, 2])
      monster.warp(1, 1)
      monster.find_target
      expect(monster.facing).to be(Monster::SPRITE_RIGHT_POSITION)
    end
  end

  context "move" do
    context "horizontally" do
      it "decrease x if target at the left" do
        allow(monster.maze_solver).to receive(:next_position_for).and_return([1, 0])
        monster.warp(1, 1)
        monster.find_target
        monster.move
        expect(monster.x).to be(32 - monster.speed)
      end

      it "increase x if target at the right" do
        allow(monster.maze_solver).to receive(:next_position_for).and_return([1, 2])
        monster.warp(1, 1)
        monster.find_target
        monster.move
        expect(monster.x).to be(32 + monster.speed)
      end

      it "changes current column if arrived at target" do
        allow(monster.maze_solver).to receive(:next_position_for).and_return([1, 2])
        monster.warp(1, 1)
        monster.speed = 32
        monster.find_target
        monster.move
        expect(monster.current_column).to be(2)
      end
    end

    context "vertically" do
      it "decrease y if target at the top" do
        allow(monster.maze_solver).to receive(:next_position_for).and_return([0, 1])
        monster.warp(1, 1)
        monster.find_target
        monster.move
        expect(monster.y).to be(32 - monster.speed)
      end

      it "increase y if target at the bottom" do
        allow(monster.maze_solver).to receive(:next_position_for).and_return([2, 1])
        monster.warp(1, 1)
        monster.find_target
        monster.move
        expect(monster.y).to be(32 + monster.speed)
      end

      it "changes current row if arrived at target" do
        allow(monster.maze_solver).to receive(:next_position_for).and_return([2, 1])
        monster.warp(1, 1)
        monster.speed = 32
        monster.find_target
        monster.move
        expect(monster.current_row).to be(2)
      end
    end
  end

  context "#draw" do
    it "renders the image" do
      expect(image).to receive(:draw)
      monster.draw
    end

    it "renders a health bar" do
      health_bar = double('health_bar')
      allow(HealthBar).to receive(:new).and_return(health_bar)
      expect(image).to receive(:draw)
      expect(health_bar).to receive(:draw)
      monster.draw
    end
  end

  context "#center" do
    it "returns center x,y of the center" do
      allow(MapHelper).to receive(:tile_size).and_return(32)
      monster.warp(0, 0)
      expect(monster.center).to eq([16, 16])
    end
  end
end