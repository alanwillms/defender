class MapHelper
  @@tile_size = nil

  def self.get_x_for_column(column)
    column * tile_size
  end

  def self.get_y_for_row(row)
    row * tile_size
  end

  def self.get_column_for_x(x)
    x / tile_size
  end

  def self.get_row_for_y(y)
    y / tile_size
  end

  def self.tile_size
    @@tile_size ||= SpriteHelper.image(:floor).width
  end

  def self.clone_matrix(original)
    cloned_matrix = []
    original.each do |row|
      new_row = []
      row.each do |cell|
        new_row.push cell.dup
      end
      cloned_matrix.push new_row
    end
    cloned_matrix
  end

  def self.create_matrix(rows, columns, default_value = nil)
    matrix = []
    for row in 0...rows do
      row_items = []
      for column in 0...columns do
        row_items.push default_value
      end
      matrix.push row_items
    end
    matrix
  end

  def self.euclidean_distance(p1, p2)
    sum_of_squares = 0
    p1.each_with_index do |p1_coord,index|
      sum_of_squares += (p1_coord - p2[index]) ** 2
    end
    Math.sqrt sum_of_squares
  end
end