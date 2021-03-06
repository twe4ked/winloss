require 'spec_helper'

describe Game do
  context 'parsing' do
    subject { described_class }
    it { should respond_to :parse }
    it { should respond_to :parse! }

    context do
      before do
        User.stub(:find_by_name).and_return { mock_model(User) }
      end

      it 'returns a valid game when parsing a correct string' do
        Game.parse('Odin beat Lucas 21-7').should be_valid
      end
    end

    it 'tries to save on parse!' do
      game = double 'game'
      Game.stub(:parse).and_return game
      game.should_receive(:save!).once

      Game.parse! 'Odin beat Lucas 21-7'
    end
  end

  context 'for_user' do
    it 'should select games where the user is either the winner or the loser' do
      Game.for_user(OpenStruct.new(:id => 5)).to_sql.should =~ /WHERE \(winner_id = 5 OR loser_id = 5\)$/
    end
  end

  context 'scores_for' do
    let(:winner) { User.create! :name => 'Lucas' }
    let(:loser)  { User.create! :name => 'Odin' }
    let!(:games) do
      [5,7,8].map {|num| Game.create! :winner => winner, :loser => loser, :winner_score => 21, :loser_score => num, :played_date => Date.today }
    end

    it 'should return scores' do
      Game.scores_for(loser).should eq [5,7,8]
    end
  end
end
