class DebugHelper
  def self.matrix(matrix)
    puts ""
    if matrix
      matrix = MapHelper.clone_matrix(matrix)
      matrix.each do |row|
        puts row.join('')
      end
    else
      puts "INVALID MATRIX!"
    end
    puts ""
  end

  def self.string(value)
    puts value
  end
end