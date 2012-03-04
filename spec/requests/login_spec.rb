require 'spec_helper'

describe "Logging in/out" do
  describe "logging in" do
    it "Should let a user login" do
      player = FactoryGirl.create(:player, :password => 'secret')
      visit login_path
      fill_in "name", :with => player.name
      fill_in "password", :with => player.password
      click_button "Login"
      page.should have_content "Welcome back"
    end
  end
end