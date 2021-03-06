require 'spec_helper'

describe User do
  context 'scores' do
    let(:winner) { User.create! :name => 'Lucas' }
    let(:loser)  { User.create! :name => 'Odin' }
    let!(:games) do
      [5,7,8].map {|num| Game.create! :winner => winner, :loser => loser, :winner_score => 21, :loser_score => num, :played_date => Date.today }
    end

    it 'should return scores' do
      loser.scores.should eq [5,7,8]
    end

    it 'should return points per game' do
      loser.points_per_game.should be_within(0.1).of(6.666)
    end
  end

  context 'points per game' do
    let(:user) { User.create! :name => 'Lucas' }
    before do
      user.stub(:scores).and_return([10,5,21,18,16,14])
    end

    it 'should average scores' do
      user.points_per_game.should be_within(0.1).of(14)
    end
  end
end
