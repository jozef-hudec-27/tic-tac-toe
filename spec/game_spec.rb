require_relative '../game'

describe Board do
    describe '#check_for_winner' do
        context 'when there is a horizontal/vertical winner' do
            subject(:horizontal_winner_board) { described_class.new([['❌', '❌', '❌'], [4, 5, 6], [7, 8, 9]]) }
            subject(:vertical_winner_board) { described_class.new([[1, '🟢', 3], [4, '🟢', 6], [7, '🟢', 9]]) }
            
            it "returns the winner's symbol" do 
                expect(horizontal_winner_board.check_for_winner).to eql('❌')
            end

            it "returns the winner's symbol" do 
                expect(vertical_winner_board.check_for_winner).to eql('🟢')
            end
        end

        context 'when there is a diagonal winner' do 
            subject(:diagonal_winner_board1) { described_class.new([['❌', 2, 3], [4, '❌', 6], [7, 8, '❌']]) }
            subject(:diagonal_winner_board2) { described_class.new([[1, 2, '🟢'], [4, '🟢', 6], ['🟢', 8, 9]]) }

            it "returns the winner's symbol" do
                expect(diagonal_winner_board1.check_for_winner).to eql('❌')
            end

            it "returns the winner's symbol" do
                expect(diagonal_winner_board2.check_for_winner).to eql('🟢')
            end
        end

        context 'when there is no winner' do
            subject(:empty_board) { described_class.new }
            subject(:full_board) { described_class.new([['❌', '🟢', '❌'], ['🟢', '❌', '🟢'], ['🟢', '❌', '🟢']]) }

            it 'returns nil' do
                expect(empty_board.check_for_winner).to be_nil
            end

            it 'returns nil' do
                expect(full_board.check_for_winner).to be_nil
            end
        end
    end
end

