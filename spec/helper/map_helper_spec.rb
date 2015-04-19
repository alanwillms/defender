describe MapHelper do
  before :each do
    allow(Game).to receive(:config).and_return({
      screen_padding: 5,
      tile_size: 10
    })
  end

  context ".screen_padding" do
    it "returns Game.config value" do
      expect(MapHelper.screen_padding).to eq(5)
    end
  end

  context ".tile_size" do
    it "returns Game.config value" do
      expect(MapHelper.tile_size).to eq(10)
    end
  end

  context ".get_x_for_column" do
    it "calculates based on tile size and screen padding" do
      expect(MapHelper.get_x_for_column(5)).to eq(55)
    end
  end

  context ".get_y_for_row" do
    it "calculates based on tile size and screen padding" do
      expect(MapHelper.get_y_for_row(5)).to eq(55)
    end
  end

  context ".get_column_for_x" do
    it "calculates based on tile size and screen padding" do
      expect(MapHelper.get_column_for_x(55)).to eq(5)
    end
  end

  context ".get_row_for_y" do
    it "calculates based on tile size and screen padding" do
      expect(MapHelper.get_row_for_y(55)).to eq(5)
    end
  end

  context ".fix_z_for_row" do
    it "increase z by number of rows" do
      expect(MapHelper.fix_z_for_row(0, 123)).to eq(123)
    end
  end

  context ".clone_matrix" do
    it "duplicates the matrix" do
      matrix = [[1, 2, 3], [4, 5, 6], [:value, 0, "Other"]]
      expect(MapHelper.clone_matrix(matrix)).to eq(matrix)
    end
  end

  context ".create_matrix" do
    it "creates matrix with informed value" do
      matrix = [[:value, :value, :value], [:value, :value, :value]]
      expect(MapHelper.create_matrix(2, 3, :value)).to eq(matrix)
    end
  end

  context ".tiles_distance" do
    it "calculates distance between two points in tiles" do
      p1 = [0, 0]
      p2 = [0, 40]
      expect(MapHelper.tiles_distance(p1, p2)).to eq(4)
    end
  end
end