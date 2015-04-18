describe MonsterSpawner do
  building_settings = {
    damage: 1,
    range: 2,
    max_range: 3,
    speed: 4,
    bullet_speed: 5,
    life: 6,
    shield: 7,
    cost: 8
  }

  monster_settings = {
    speed: 10,
    max_speed: 10,
    life: 50,
    damage: 10,
    shield: 0,
    money: 5
  }

  let :map do
    Map.new(instance_double('GameScreen'), 1024, 768)
  end

  let :monster_spawner do
    MonsterSpawner.new(map, 0, 0)
  end

  before :each do
    allow(Game).to receive(:config).and_return({
      buildings: {monster_spawner: building_settings},
      monsters: { monster_1: monster_settings, monster_2: monster_settings },
      waves: {0 => { monster_1: 1, monster_2: 3 } }
    })
    allow(MapHelper).to receive(:tile_size).and_return(32)
  end

  context "#spawn_wave" do
    it "increases wave count" do
      monster_spawner.spawn_wave
      expect(monster_spawner.map.wave).to be(1)
    end

    it "use preset wave if it exists" do
      expect(monster_spawner).to receive(:spawn).with(:monster_1)
      expect(monster_spawner).to receive(:spawn).with(:monster_2).exactly(3).times
      monster_spawner.spawn_wave
    end

    it "create random wave if it doesn't exist" do
      map.wave = 3
      expect(monster_spawner).not_to receive(:preset_wave)
      expect(monster_spawner).to receive(:spawn).exactly(3).times
      monster_spawner.spawn_wave
    end
  end
end