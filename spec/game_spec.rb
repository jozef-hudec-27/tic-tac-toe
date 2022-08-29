require_relative '../game'

describe Board do
    describe '#check_for_winner' do
        context 'when there is a horizontal/vertical winner' do
            subject(:board_horizontal_winner) { described_class.new([['❌', '❌', '❌'], [4, 5, 6], [7, 8, 9]]) }
            subject(:board_vertical_winner) { described_class.new([[1, '🟢', 3], [4, '🟢', 6], [7, '🟢', 9]]) }
            
            it "returns the winner's symbol" do 
                expect(board_horizontal_winner.check_for_winner).to eql('❌')
            end

            it "returns the winner's symbol" do 
                expect(board_vertical_winner.check_for_winner).to eql('🟢')
            end
        end

        context 'when there is a diagonal winner' do 
            subject(:board_diagonal_winner1) { described_class.new([['❌', 2, 3], [4, '❌', 6], [7, 8, '❌']]) }
            subject(:board_diagonal_winner2) { described_class.new([[1, 2, '🟢'], [4, '🟢', 6], ['🟢', 8, 9]]) }

            it "returns the winner's symbol" do
                expect(board_diagonal_winner1.check_for_winner).to eql('❌')
            end

            it "returns the winner's symbol" do
                expect(board_diagonal_winner2.check_for_winner).to eql('🟢')
            end
        end

        context 'when there is no winner' do
            subject(:board_empty) { described_class.new }
            subject(:board_full) { described_class.new([['❌', '🟢', '❌'], ['🟢', '❌', '🟢'], ['🟢', '❌', '🟢']]) }

            it 'returns nil' do
                expect(board_empty.check_for_winner).to be_nil
            end

            it 'returns nil' do
                expect(board_full.check_for_winner).to be_nil
            end
        end
    end

    describe '#play_round' do
        let(:player1) { instance_double(Player, name: 'player1', symbol: '❌') }
        let(:player2) { instance_double(Player, name: 'player2', symbol: '🟢') }
        
        context 'when the position is valid' do
            subject(:board_empty) { described_class.new }

            it 'updates the board' do
                expect { board_empty.play_round(1, player1) }.to change { board_empty.board }.to([['❌', 2, 3], [4, 5, 6], [7, 8, 9]])
            end
        end

        context 'when the position is not valid' do
            subject(:board_mid_game) { described_class.new([[1, 2, '🟢'], [4, '❌', 6], ['🟢', 8, 9]]) }

            it 'returns nil' do
                expect(board_mid_game.play_round(3, player2)).to be_nil
            end

            it 'does not update the board' do
                invalid_position = 30
                expect { board_mid_game.play_round(invalid_position, player1) }.to_not change({ board_mid_game.board })
            end
        end
    end

    describe '#tie?' do
        context 'when the board is full and there is no winner' do
            subject(:board_tie) { described_class.new([['❌', '🟢', '❌'], ['🟢', '❌', '🟢'], ['🟢', '❌', '🟢']]) }

            it 'returns true' do
                expect(board_tie).to be_tie
            end
        end

        context 'when the board is not full' do
            subject(:board_mid_game) { described_class.new([[1, 2, '🟢'], [4, '❌', 6], ['🟢', 8, 9]]) }

            it 'returns false' do
                expect(board_mid_game).to_not be_tie
            end
        end

        context 'when the board is full and there is a winner' do
            subject(:board_full_with_winner) { described_class.new([['❌', '🟢', '❌'], ['🟢', '❌', '🟢'], ['🟢', '❌', '❌']])}
            it 'returns false' do 
                expect(board_full_with_winner).to_not be_tie
            end
        end
    end

    describe '#refresh' do
        context 'when the board is empty' do
            subject(:board_empty) { described_class.new }

            it 'stays empty' do
                expect { board_empty.refresh }.to_not change { board_empty.board }
            end
        end

        context 'when the board is mid game' do
            subject(:board_mid_game) { described_class.new([[1, 2, '🟢'], [4, '❌', 6], ['🟢', 8, 9]]) }
            let(:board_empty_array) { [[1, 2, 3], [4, 5, 6], [7, 8, 9]] }

            it 'becomes empty' do
                expect { board_mid_game.refresh }.to change { board_mid_game.board }.to(board_empty_array)
            end
        end
    end
end

