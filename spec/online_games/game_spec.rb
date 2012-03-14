require 'spec_helper'
require 'online_game/game.rb'

describe "Randomly Played online games" do
  500.times do |x|
    it "Should keep playing without raising errors. Game #{x}" do
      begin
        g = Online::Game.new.run []
        inputs = []
        until g.state == :finished
          
          # lets do some sanity checking here - no one should have life < 0, positions outside 0..7
          
          p1n = g.pending_input 'p1'
          p2n = g.pending_input 'p2'
          inputs << "p1:#{p1n.sample}" if p1n.try(:any?)
          inputs << "p2:#{p2n.sample}" if p2n.try(:any?)
          g = Online::Game.new.run inputs.dup
        end
      rescue Exception => e
        puts "Current input list is #{inputs}"
        raise e
      end
    end
  end
end
