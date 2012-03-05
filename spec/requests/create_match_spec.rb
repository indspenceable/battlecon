require 'spec_helper'

describe "creating a match" do
  # we want players in a league
  let :players do
    p1 = FactoryGirl.create(:player, :name => "one",:password => 'secret')
    p2 = FactoryGirl.create(:player, :name => "two",:password => 'secret')
    league = FactoryGirl.create(:league)
    [p1,p2].each do |p|
      p.leagues << league
      p.update_attributes(:active_league => league)
    end
  end
  let :p1 do
    players.first
  end
  let :p2 do
    players.last
  end
  
  def record_match as, vs, c1, c2, won
    login! p1
    click_link "Record Play"
    select c1, :from => 'match_creator_character'
    select p2.name, :from => 'match_opponent'
    select c2, :from => 'match_opponent_character'
    if won
      check('match_creator_is_winner')
    else
      check('creator-loser-checkbox')
    end
    click_on("Create Match")
  end
  def check_match m, wp, lp, wc, lc
    m.winning_character.should == Character.find_by_name(wc)
    m.losing_character.should == Character.find_by_name(lc)
    m.winning_player.should == wp
    m.losing_player.should == lp
  end
  
  it "should be able to record a win" do
    record_match p1, p2, 'cherri', 'heketch', true
    check_match ::Match.last, p1, p2, 'cherri', 'heketch'
  end
  it "should be able to record a loss" do
    record_match p1, p2, 'khadath', 'rukyuk', false
    check_match ::Match.last, p2, p1, 'rukyuk', 'khadath'
  end
end