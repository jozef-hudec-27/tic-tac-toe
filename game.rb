class Player
  attr_reader :symbol, :name

  @@players = {}

  def initialize(name, symbol)
    @name = name
    @symbol = symbol

    @@players[symbol] = self
  end

  def self.players
    @@players
  end
end

class Board
  attr_accessor :board

  def initialize(board = [[1, 2, 3], [4, 5, 6], [7, 8, 9]])
    @board = board
  end

  def check_for_winner
    return board[0][0] if [board[0][0], board[1][1], board[2][2]].uniq.length == 1
    return board[0][2] if [board[0][2], board[1][1], board[2][0]].uniq.length == 1

    3.times do |i|
      return board[i][0] if board[i].uniq.length == 1
      return board[0][i] if [board[0][i], board[1][i], board[2][i]].uniq.length == 1
    end

    nil
  end

  def tie?
    !check_for_winner && board.flatten.select { |position| position.instance_of?(Integer) } == []
  end

  def play_round(position, player)
    return unless (1..9).include? position

    row_col = get_row_and_col(position)
    return unless (1..9).include? board[row_col[:row]][row_col[:col]]

    board[row_col[:row]][row_col[:col]] = player.symbol
  end

  def occupied?(position)
    return unless (1..9).include? position

    row_col = get_row_and_col(position)
    !(1..9).include?(board[row_col[:row]][row_col[:col]])
  end

  def print_board
    puts "
            #{board[0][0]}    |    #{board[0][1]}    |    #{board[0][2]}
            --------------------------
            #{board[1][0]}    |    #{board[1][1]}    |    #{board[1][2]}
            --------------------------
            #{board[2][0]}    |    #{board[2][1]}    |    #{board[2][2]}
            "
  end

  def refresh
    self.board = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
  end

  private

  def get_row_and_col(position)
    row = (position - 1).divmod(3)[0]
    col = (position - 1).divmod(3)[1]
    { row: row, col: col }
  end
end
