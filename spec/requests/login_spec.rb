require 'spec_helper'

describe "Logging in/out" do
  describe "logging in" do
    it "A user who enters the correct password should be logged in" do
      player = FactoryGirl.create(:player, :password => 'secret')
      visit login_path
      fill_in "name", :with => player.name
      fill_in "password", :with => player.password
      click_button "Login"
      page.should have_content "Welcome back"
    end
    it "should deny access for incorrect passwords" do
      player = FactoryGirl.create(:player, :password => 'secret')
      visit login_path
      fill_in "name", :with => player.name
      fill_in "password", :with => "somethingelse"
      click_button "Login"
      page.should have_content "Incorrect username or password."
    end
  end
end