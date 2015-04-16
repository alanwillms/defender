class Building

  attr_reader :row, :column, :cost, :type

  def initialize(map, row, column, type)
    @map = map
    @row = row
    @column = column
    @type = type
    setup_attributes
  end

  def draw
    image = SpriteHelper.image(@type)
    fixed_y = y
    fixed_z = MapHelper.fix_z_for_row(z, @row)
    if image.height > MapHelper.tile_size
      fixed_y = y - (image.height - MapHelper.tile_size)
    elsif image.height < MapHelper.tile_size
      fixed_y = y + (MapHelper.tile_size - image.height)
    end
    image.draw(x, fixed_y, fixed_z)
  end

  def self.types
    {
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
      },
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
      }
    }
  end

  private

    def setup_attributes
      attributes = self.class.types[@type]
      @attack = attributes[:damage]
      @range = attributes[:range]
      @max_range = attributes[:max_range]
      @speed = attributes[:speed]
      @health_points = @initial_health_points = attributes[:life]
      @shield = attributes[:shield]
      @cost = attributes[:cost]
    end

    def x
      MapHelper.get_x_for_column(@column)
    end

    def y
      MapHelper.get_y_for_row(@row)
    end

    def z
      ZOrder::Entity
    end
end