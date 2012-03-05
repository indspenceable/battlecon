require 'spec_helper'

describe "Landing" do
  let :player do
    FactoryGirl.create(:player, :password => 'secret')
  end
  
  describe "logging in" do
    it "A user who enters the correct password should be logged in" do
      login! player
      page.should have_content "Welcome back"
    end
    it "should deny access for incorrect passwords" do
      login! player, 'incorrect'
      page.should have_content "Incorrect username or password."
    end
  end
  describe "logging out" do
    it "should be able to log out" do
      login! player
      click_link "Logout"
      page.should have_content "Login"
    end
  end
end