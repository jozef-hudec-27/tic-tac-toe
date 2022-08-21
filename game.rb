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

  def initialize
    @board = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
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
    board.flatten.select { |position| position.instance_of?(Integer) } == []
  end

  def play_round(position, player)
    row_col = get_row_and_col(position)
    board[row_col[:row]][row_col[:col]] = player.symbol
  end

  def occupied?(position)
    row_col = get_row_and_col(position)
    %w[❌ 🟢].include?(board[row_col[:row]][row_col[:col]])
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

puts '⚪ Choose name for Player 1'
player1_name = gets.chomp.strip
player1_name = 'Player 1' if player1_name == ''

puts '⚪ Choose name for Player 2'
begin
  player2_name = gets.chomp.strip
  player2_name = 'Player 2' if player2_name == ''
  raise 'Invalid name.' if player2_name == player1_name
rescue
  puts "🔴 Users can't have the same name. Enter name again for Player 2."
  retry
end

player1 = Player.new(player1_name, '❌')
player2 = Player.new(player2_name, '🟢')

board = Board.new

loop do
  9.times do |round|
    puts "⚪ ROUND #{round + 1}, CURRENT BOARD: "
    board.print_board

    current_player = round.even? ? player1 : player2

    puts "⚪ It's #{current_player.name}'s turn (#{current_player.symbol}) Please select available field."

    begin
      selected_field = gets.chomp.to_i
      raise 'Invalid field.' if (selected_field < 1 || selected_field > 9) || board.occupied?(selected_field)
    rescue
      puts '🔴 Not a valid field. Please, pick again.'
      retry
    else
      board.play_round(selected_field, round.even? ? player1 : player2)

      winner_symbol = board.check_for_winner

      if !winner_symbol.nil?
        board.print_board

        winner_name = Player.players[winner_symbol].name
        puts "🎉🎉🎉 #{winner_name} WINS THE GAME! 🎉🎉🎉"
        break
      elsif board.tie?
        board.print_board

        puts "🟢 All fields are taken. It's a tie!"
      end
    end
  end

  board.refresh

  puts "🟢 Do you want to play again? Enter 'y' if so."
  play_again = gets.chomp

  break if play_again.downcase != 'y'
end
