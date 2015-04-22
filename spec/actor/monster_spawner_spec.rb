describe MonsterSpawner do
  let :map do
    Map.new(instance_double('GameScreen'), 16, 16)
  end

  let :monster_spawner do
    MonsterSpawner.new(Cell.new(map, 0, 0))
  end

  before :each do
    allow(MapHelper).to receive(:screen_padding).and_return(0)
    allow(MapHelper).to receive(:tile_size).and_return(32)
  end

  context "#spawn_wave" do
    it "increases wave count" do
      monster_spawner.spawn_wave
      expect(monster_spawner.cell.map.wave).to be(1)
    end

    it "use preset wave if it exists" do
      expect(monster_spawner).to receive(:spawn).with(:weak_1)
      monster_spawner.spawn_wave
    end

    it "create random wave if it doesn't exist" do
      map.wave = 30
      expect(monster_spawner).not_to receive(:preset_wave)
      expect(monster_spawner).to receive(:spawn).exactly(30).times
      monster_spawner.spawn_wave
    end
  end
end