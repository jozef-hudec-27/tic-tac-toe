require_relative 'game'

puts '> Choose name for Player 1'
player1_name = gets.chomp.strip
player1_name = 'Player 1' if player1_name == ''

puts '> Choose name for Player 2'
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

catch :main_loop do
  loop do
    9.times do |round|
      puts "\n\n> ROUND #{round + 1}, CURRENT BOARD: "
      board.print_board

      current_player = round.even? ? player1 : player2

      puts "> It's #{current_player.name}'s turn (#{current_player.symbol}) Please select available field."

      begin
        selected_field = gets.chomp.strip
        throw :main_loop if selected_field == 'q'
        selected_field = selected_field.to_i
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

          puts "🏳️🏳️🏳️ All fields are taken. It's a tie! 🏳️🏳️🏳️"
        end
      end
    end

    board.refresh

    puts "> Do you want to play again? Enter 'y' if so."
    play_again = gets.chomp

    break if play_again.downcase != 'y'
  end
end
