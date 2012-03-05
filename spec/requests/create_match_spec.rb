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
  it "should be able to record a match" do
    p1,p2 = players
    login! p1
    click_link "Record Play"
    select 'cherri', :from => 'match_creator_character'
    select p2.name, :from => 'match_opponent'
    select 'heketch', :from => 'match_opponent_character'
    check('match_creator_is_winner')
    click_on("Create Match")
    
  end
end