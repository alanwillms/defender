class Building

  attr_reader :row, :column

  def initialize(map, row, column, type)
    @map = map
    @row = row
    @column = column
    @map.build_at!(self, @row, @column)
    @type = type
  end

  def self.build_cost
    0
  end

  def draw
    SpriteHelper.image(@type).draw(x, y, z)
  end

  def self.types
    {
      monster_spawner: {
        damage: 0,
        range: 0,
        speed: 0,
        bullet_speed: 0,
        life: 100,
        shield: 0,
        cost: 0
      },
      defending_city: {
        damage: 0,
        range: 0,
        speed: 0,
        bullet_speed: 0,
        life: 100,
        shield: 0,
        cost: 0
      },
      wall: {
        damage: 0,
        range: 0,
        speed: 0,
        bullet_speed: 0,
        life: 100,
        shield: 500,
        cost: 5
      },
      cannon: {
        damage: 12,
        range: 4,
        max_range: 8,
        speed: 2,
        bullet_speed: 6,
        life: 100,
        shield: 100,
        cost: 300
      },
      archer_tower: {
        damage: 5,
        range: 5,
        max_range: 10,
        speed: 3,
        bullet_speed: 6,
        life: 100,
        shield: 50,
        cost: 100
      },
      wizard_tower: {
        damage: 30,
        range: 3,
        max_range: 5,
        speed: 3,
        bullet_speed: 5,
        life: 100,
        shield: 200,
        cost: 800
      },
      tesla: {
        damage: 25,
        range: 6,
        max_range: 10,
        speed: 20,
        life: 100,
        shield: 100,
        cost: 2000
      }
    }
  end

  private

    def x
      MapHelper.get_x_for_column(@column)
    end

    def y
      MapHelper.get_y_for_row(@row)
    end

    def z
      ZOrder::Building
    end
end