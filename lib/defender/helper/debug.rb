class DebugHelper
  def self.matrix(matrix)
    string ""
    if matrix
      matrix = MapHelper.clone_matrix(matrix)
      matrix.each do |row|
        string row.join('')
      end
    else
      string "INVALID MATRIX!"
    end
    string ""
  end

  def self.string(value)
    if Game.config[:environment] != :development
      return
    end
    puts value
  end
end