class DebugHelper
  def self.matrix(matrix)
    if matrix.is_a? Array
      string ""
      matrix = MapHelper.clone_matrix(matrix)
      matrix.each do |row|
        string row.join('')
      end
      string ""
    else
      string "INVALID MATRIX!"
    end
  end

  def self.string(value)
    if Game.config[:environment] == :development
      puts value
    end
  end
end