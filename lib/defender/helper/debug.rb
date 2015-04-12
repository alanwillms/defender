class DebugHelper
  def self.matrix(matrix)
    puts ""
    matrix = MapHelper.clone_matrix(matrix)
    matrix.each do |row|
      puts row.join('')
    end
    puts ""
  end

  def self.string(value)
    puts value
  end
end